FROM python:3.12-bullseye

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# System dependencies
WORKDIR /tmp
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    cmake \
    libssl-dev \
    zlib1g-dev \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Build librdkafka
WORKDIR /usr/src/librdkafka
RUN git clone https://github.com/edenhill/librdkafka.git . \
    && git checkout v1.9.2 \
    && ./configure \
    && make \
    && make install \
    && ldconfig \
    && rm -rf /usr/src/librdkafka

# Create non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /app

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ./ ./

RUN chown -R appuser:appgroup /app

USER appuser

ENTRYPOINT ["sh", "./docker_assets/entrypoint.sh"]

CMD ["gunicorn", "conf.asgi:application", "-b", "0.0.0.0:8080", "--workers", "4", "--worker-connections", "1000", "--timeout", "60", "--keep-alive", "5", "--max-requests", "1000", "--max-requests-jitter", "50", "--access-logfile", "-", "--error-logfile", "-", "--log-level", "warning", "-k", "uvicorn.workers.UvicornWorker"]