ARG PYTHON_VERSION=latest
ARG VENV_PATH=/.venv

FROM python:${PYTHON_VERSION} as build

RUN apt-get update && apt-get install -y build-essential gcc libffi-dev libpq-dev git curl

ADD https://astral.sh/uv/install.sh /install.sh
RUN chmod -R 655 /install.sh && /install.sh && rm /install.sh

ENV PATH="/root/.cargo/bin:${VENV_PATH}/bin:$PATH"

RUN uv venv ${VENV_PATH}

FROM python:${PYTHON_VERSION}

COPY --from=build /root/.cargo/bin /root/.cargo/bin
COPY --from=build ${VENV_PATH} ${VENV_PATH}

ENV PATH="/root/.cargo/bin:${VENV_PATH}/bin:$PATH"
