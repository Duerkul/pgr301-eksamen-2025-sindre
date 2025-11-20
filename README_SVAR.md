# README_SVAR

Dette dokumentet beskriver leveransene og resultatene for PGR301 EKSAMEN 2025 - AiAlpha.

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
    - Bygg og start: docker compose up --build
    - Åpne: http://localhost:8080
    - Stopp: docker compose down

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


For at AiAlpha skal kunne utvikles videre på en trygg og skalerbar måte, må jeg etablere en arbeidsform som kombinerer fart med kvalitet. Jeg har valgt en trunk-based strategi med små, hyppige endringer, og brukt pull requests og beskyttede branches for å holde kontroll på endringene. CI/CD-pipelines fungerer som motoren i leveransene: bygg, tester og sikkerhetssjekker kjører automatisk (hadolint for Docker er aktiv), og produksjons-deploys utløses manuelt via workflow-dispatch. Rollback håndteres ved å rulle tilbake SAM/CloudFormation-stacken til forrige versjon eller ved kontrollert Terraform destroy/apply ved behov.

Med Terraform beskrives infrastrukturen slik at miljøene kan gjenskapes presist. Koden inkluderer S3, CloudWatch dashboard og alarmer – og gjør det mulig å standardisere sikkerhet (f.eks. blokkering av offentlig tilgang, versjonering og kryptering på S3) på en forutsigbar måte.

Observability er prioritert: Lambda logger strukturert JSON, og applikasjonen eksponerer custom metrics (Requests, SentimentScore, Errors) i AiAlpha-namespace. CloudWatch dashboard og alarmer (Lambda Errors og API Gateway 5XX) er definert som kode og deployes via Terraform.

Når det gjelder sikkerhet, er IAM-rettighetene i CD bevisst bredere for å sikre fremdrift i øvingen (GitHub Actions bruker statiske nøkler lagret som Secrets). Målet er å stramme inn til least privilege og bytte til OIDC-basert rolleforutsetning for nøkkelfri drift. Sikkerhetsskanning er delvis på plass (hadolint). Neste steg er å utvide med tfsec (Terraform) og trivy (container images) for å fange sårbarheter tidlig.

Kvalitet ivaretas med code review (via PR), linting og enhetstester for Lambda (pytest). Dette danner en praktisk testpyramide der raske enhetstester kjøres i CI, mens integrasjon verifiseres gjennom deploy og kjøring i skymiljø.

Summen er en leveransemodell som lar meg levere raskt og trygt nå, samtidig som den skalerer til teamarbeid og høyere krav fra kunder og investorer.

---

