import json
import logging
import os
import time
from typing import Any, Dict

import boto3
import botocore

# Structured logging setup
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
logger = logging.getLogger()
for h in list(logger.handlers):
    logger.removeHandler(h)
handler = logging.StreamHandler()
formatter = logging.Formatter('%(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(LOG_LEVEL)

_METRIC_NAMESPACE_DEFAULT = "AiAlpha"
METRIC_NAMESPACE = os.getenv("METRIC_NAMESPACE", _METRIC_NAMESPACE_DEFAULT)

# Lazy client getter to avoid side effects on import and allow tests without AWS region
_cloudwatch_client = None

def get_cloudwatch():
    global _cloudwatch_client
    if _cloudwatch_client is None:
        region = os.getenv("AWS_REGION")
        if region:
            _cloudwatch_client = boto3.client("cloudwatch", region_name=region)
        else:
            _cloudwatch_client = boto3.client("cloudwatch")
    return _cloudwatch_client


def _log(evt_name: str, **fields: Any) -> None:
    payload = {"event": evt_name, **fields, "ts": int(time.time())}
    logger.info(json.dumps(payload))


def _put_metric(name: str, value: float, unit: str = "Count", dims: Dict[str, str] | None = None) -> None:
    dimensions = []
    if dims:
        dimensions = [{"Name": k, "Value": v} for k, v in dims.items()]
    try:
        get_cloudwatch().put_metric_data(
            Namespace=METRIC_NAMESPACE,
            MetricData=[{
                "MetricName": name,
                "Timestamp": int(time.time()),
                "Value": value,
                "Unit": unit,
                "Dimensions": dimensions
            }]
        )
    except (botocore.exceptions.NoCredentialsError, botocore.exceptions.NoRegionError) as e:
        logger.debug(json.dumps({"event": "metrics_skipped", "reason": str(e)}))


def _dummy_sentiment(text: str) -> Dict[str, Any]:
    # Placeholder: heuristic sentiment score [-1..1]
    score = 0.0
    lower = text.lower()
    positives = ["bull", "fomo", "rally", "beat", "surge"]
    negatives = ["bear", "panic", "dump", "miss", "crash"]
    for p in positives:
        if p in lower:
            score += 0.2
    for n in negatives:
        if n in lower:
            score -= 0.2
    score = max(-1.0, min(1.0, score))
    label = "POSITIVE" if score > 0.1 else ("NEGATIVE" if score < -0.1 else "NEUTRAL")
    return {"score": score, "label": label}


def _response(status: int, body: Dict[str, Any]) -> Dict[str, Any]:
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body)
    }


def handler(event, context):
    _log("request_received", event=event)
    try:
        if event.get("httpMethod") != "POST":
            return _response(405, {"message": "Method Not Allowed"})
        body = event.get("body")
        if not body:
            return _response(400, {"message": "Missing body"})
        try:
            data = json.loads(body)
        except json.JSONDecodeError:
            return _response(400, {"message": "Invalid JSON"})

        text = data.get("text")
        if not text or not isinstance(text, str):
            return _response(400, {"message": "Field 'text' is required"})

        result = _dummy_sentiment(text)
        _log("analysis_complete", result=result)
        _put_metric("Requests", 1, unit="Count", dims={"Route": "/analyze"})
        _put_metric("SentimentScore", result["score"], unit="None")

        return _response(200, {"ok": True, "result": result})
    except Exception as e:
        _log("error", error=str(e))
        _put_metric("Errors", 1, unit="Count", dims={"Route": "/analyze"})
        return _response(500, {"ok": False, "message": "Internal error"})
