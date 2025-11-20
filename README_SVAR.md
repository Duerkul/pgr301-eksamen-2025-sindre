# README_SVAR

Dette dokumentet inneholder leveranser og svar for PGR301 EKSAMEN 2025 - AiAlpha.

## Generell informasjon
- Repository URL: https://github.com/Duerkul/pgr301-eksamen-2025-sindre
- AWS Region: eu-north-1
- AWS Account ID: 439256599420

## Oppgave 1 – Terraform, S3 og IaC (15p)
- Infrastruktur-kode: oppgave1-terraform/
- Viktige filer: providers.tf, variables.tf, main.tf, outputs.tf, backend.tf
- Leveranser:
  - Lenke til GitHub Actions workflow-kjøring (Terraform CI): https://github.com/Duerkul/pgr301-eksamen-2025-sindre/actions/runs/19507603589
  - Lenke til GitHub Actions workflow-kjøring (Terraform CD): https://github.com/Duerkul/pgr301-eksamen-2025-sindre/actions/runs/19509805714
  - S3 Bucket navn: aialpha-tf-duerkul-20251119
  - S3 Bucket ARN: arn:aws:s3:::aws-sam-cli-managed-default-samclisourcebucket-al2vc53y21vh
  - Eventuelle skjermbilder/logg: se Actions-logg for apply

## Oppgave 2 – AWS Lambda, SAM og GitHub Actions (25p)
- Kode og SAM-template: oppgave2-sam/
- Leveranser:
  - Lenke til CI workflow-kjøring (build+test+validate): https://github.com/Duerkul/pgr301-eksamen-2025-sindre/actions/runs/19505194424
  - Lenke til CD workflow-kjøring (deploy): https://github.com/Duerkul/pgr301-eksamen-2025-sindre/actions/runs/19505194424
  - API Gateway URL (prod): https://vybc7yf2w6.execute-api.eu-north-1.amazonaws.com/Prod/analyze
  - Eksempel-kall (curl):
    curl -X POST "https://vybc7yf2w6.execute-api.eu-north-1.amazonaws.com/Prod/analyze" -H "Content-Type: application/json" -d '{"text":"bull rally"}'
  - Eksempel-respons:
    {"ok": true, "result": {"score": 0.4, "label": "POSITIVE"}}

## Oppgave 3 – Containere og Docker (25p)
- Docker-konfig: oppgave3-docker/
- Leveranser:
  - Lenke til Docker CI workflow-kjøring: https://github.com/Duerkul/pgr301-eksamen-2025-sindre/actions/runs/19504953340
  - GHCR Image URL / tag: ghcr.io/duerkul/pgr301-eksamen-2025-sindre/aialpha-app:latest
  - Lokalt kjøreeksempel (docker compose):
    - Bygg og start: docker compose -f oppgave3-docker/docker-compose.yml up --build
    - Åpne: http://localhost:8080
    - Stopp: docker compose -f oppgave3-docker/docker-compose.yml down

## Oppgave 4 – Metrics, Observability og CloudWatch (25p)
- Observability: oppgave4-observability/
- Leveranser:
  - CloudWatch Dashboard navn: aialpha-observability (region: eu-north-1)
  - Alarm-navn og metrikk:
    - aialpha-lambda-errors
      - Namespace: AWS/Lambda
      - Metric name: Errors
      - Dimension: FunctionName = aialpha-sam-ApiFunction-mGXbQbuOSrP0
      - Statistic: Sum
      - Period: 1 minute
      - Threshold: Errors > 1 for 1 datapoints within 1 minute
      - State: OK
    - aialpha-api-5xx
      - Namespace: AWS/ApiGateway
      - Metric name: 5XXError
      - Dimensions: ApiName = aialpha-sam, Stage = Prod
      - Statistic: Sum
      - Period: 1 minute
      - Threshold: 5XXError > 1 for 1 datapoints within 1 minute
      - State: OK
  - Eksempel på strukturert logg-linje fra Lambda (Logs Insights):
    - {"event": "analysis_complete", "result": {"score": 0.4, "label": "POSITIVE"}, "ts": 1763578567}

## Oppgave 5 – Drøfteoppgave – DevOps-prinsipper (10p)
- Kort drøfting (legg her eller i egen fil):

### Forslag til drøfting (kort mal)
- Versjonskontroll og branchestrategi: trunk-based med korte feature branches, PR-krav, beskyttede branches.
- CI/CD: bygg, test, sikkerhetsskanning, artefakter, progressive deploys (manual approval prod), rollback.
- IaC: Terraform i separate miljøer/states, moduler, policy-as-code.
- Observability: metrics, logs, traces; golden signals; SLO/SLI; alarms med on-call.
- Sikkerhet: least privilege IAM, secrets i GitHub, scanning (trivy, tfsec), dependabot.
- Kvalitet: code review, linting, testtyper (unit, integration), testpyramide.

---
Denne mallen er ment som en sjekkliste slik at alle leveranser blir dokumentert i sensur.
