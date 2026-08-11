FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /usr/sbin/nologin appuser

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY templates ./templates

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

CMD ["python", "app.py"]
