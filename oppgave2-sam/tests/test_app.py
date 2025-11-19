import json
import importlib.util
from pathlib import Path

# Dynamically import the Lambda app module from oppgave2-sam/src/app.py
SRC_PATH = Path(__file__).resolve().parents[1] / 'src' / 'app.py'
spec = importlib.util.spec_from_file_location('app', str(SRC_PATH))
app = importlib.util.module_from_spec(spec)
spec.loader.exec_module(app)  # type: ignore


def test_dummy_sentiment_positive():
    res = app._dummy_sentiment("Market shows FOMO and bull rally")
    assert res["label"] == "POSITIVE"


def test_handler_bad_method():
    evt = {"httpMethod": "GET"}
    out = app.handler(evt, None)
    assert out["statusCode"] == 405


def test_handler_missing_body():
    evt = {"httpMethod": "POST"}
    out = app.handler(evt, None)
    assert out["statusCode"] == 400


def test_handler_happy_path():
    evt = {"httpMethod": "POST", "body": json.dumps({"text": "bull rally"})}
    out = app.handler(evt, None)
    assert out["statusCode"] == 200
