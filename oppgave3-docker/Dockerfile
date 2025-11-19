# syntax=docker/dockerfile:1.7-labs

FROM python:3.12-slim AS base
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Copy app
COPY oppgave2-sam/src /app

# Install runtime deps if any
RUN pip install --no-cache-dir boto3

# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Run simple server using Python http server to demo container runs
EXPOSE 8080
CMD ["python", "-c", "import http.server as s, socketserver as ss; p=8080; h=('0.0.0.0', p); print('listening', p); ss.TCPServer(h, s.SimpleHTTPRequestHandler).serve_forever()"]
