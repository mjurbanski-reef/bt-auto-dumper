ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-alpine AS builder

WORKDIR /app

RUN apk add --no-cache \
    curl \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev

RUN curl -sSL https://raw.githubusercontent.com/pdm-project/pdm/main/install-pdm.py | python3 -

ENV PATH="/root/.local/bin:$PATH"

COPY . .

RUN pdm export > /tmp/requirements.txt

ARG PDM_BUILD_SCM_VERSION="0.0.1"
RUN pdm build -d /tmp/wheelhouse

RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN pip install --no-cache-dir /tmp/wheelhouse/*.whl

FROM python:${PYTHON_VERSION}-alpine

COPY --from=builder /usr/local/lib/python${PYTHON_VERSION%.*}/site-packages /usr/local/lib/python${PYTHON_VERSION%.*}/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

ENV PATH="/usr/local/bin:$PATH"

ENTRYPOINT ["bt-auto-dumper"]
