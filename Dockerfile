# syntax=docker/dockerfile:1

############################
# Stage 1: Build dependencies
############################
FROM python:3.12-slim AS builder

WORKDIR /build

COPY requirements.txt .

RUN pip install \
    --no-cache-dir \
    --prefix=/install \
    -r requirements.txt


############################
# Stage 2: Runtime image
############################
FROM python:3.12-slim AS runtime

LABEL org.opencontainers.image.source="https://github.com/k-paris/DevSecOps-01"

WORKDIR /app

# Install only OS packages required at runtime
RUN apt-get update \
    && apt-get install -y --no-install-recommends iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Create dedicated non-root user
RUN useradd \
    --create-home \
    --shell /usr/sbin/nologin \
    appuser

# Copy only installed Python runtime dependencies
# from the builder stage
COPY --from=builder /install /usr/local

# Copy application files
COPY app.py .
COPY templates ./templates

# Set ownership for the application directory
RUN chown -R appuser:appuser /app

# Drop privileges
USER appuser

EXPOSE 8080

# Check that the Flask application is actually responding
HEALTHCHECK \
    --interval=30s \
    --timeout=3s \
    --start-period=5s \
    --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/', timeout=2)" || exit 1

CMD ["python", "app.py"]
