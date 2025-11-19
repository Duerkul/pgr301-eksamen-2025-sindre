# README_SVAR

Dette dokumentet inneholder dine leveranser og svar for PGR301 EKSAMEN 2025 - AiAlpha.
Fyll inn lenker og korte beskrivelser under hver oppgave.

## Generell informasjon
- Repository URL: <fyll-inn>
- AWS Region: <fyll-inn>
- AWS Account ID: <fyll-inn>

## Oppgave 1 – Terraform, S3 og IaC (15p)
- Infrastruktur-kode: oppgave1-terraform/
- Viktige filer: providers.tf, variables.tf, main.tf, outputs.tf, backend.tf (valgfri remote backend)
- Leveranser:
  - Lenke til GitHub Actions workflow-kjøring (Terraform CI): <fyll-inn>
  - Lenke til GitHub Actions workflow-kjøring (Terraform CD): <fyll-inn>
  - S3 Bucket navn: <fyll-inn>
  - Eventuelle skjermbilder/logg: <fyll-inn>

## Oppgave 2 – AWS Lambda, SAM og GitHub Actions (25p)
- Kode og SAM-template: oppgave2-sam/
- Leveranser:
  - Lenke til CI workflow-kjøring (build+test+validate): <fyll-inn>
  - Lenke til CD workflow-kjøring (deploy): <fyll-inn>
  - API Gateway URL (prod eller stage): <fyll-inn>
  - Eksempel-kall (curl): <fyll-inn>

## Oppgave 3 – Containere og Docker (25p)
- Docker-konfig: oppgave3-docker/
- Leveranser:
  - Lenke til Docker CI workflow-kjøring: <fyll-inn>
  - GHCR Image URL / tag: <fyll-inn>
  - Lokalt kjøreeksempel (docker compose): <fyll-inn>

## Oppgave 4 – Metrics, Observability og CloudWatch (25p)
- Observability: oppgave4-observability/
- Leveranser:
  - CloudWatch Dashboard navn/lenke: <fyll-inn>
  - Alarm-navn og metrikk: <fyll-inn>
  - Eksempel på strukturert logg-linje fra Lambda: <fyll-inn>

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
