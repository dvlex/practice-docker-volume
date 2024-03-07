FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye as base

ARG DEVELOPER_UID=1002

ARG DEVELOPER_USERNAME=you

ARG DIR=/workspaces/lithia-converter-backend 

RUN addgroup --gid ${DEVELOPER_UID} ${DEVELOPER_USERNAME} --force-badname \
 ;  useradd -r -m -u ${DEVELOPER_UID} --gid ${DEVELOPER_UID} \
    --shell /bin/bash -c "Developer User,,," ${DEVELOPER_USERNAME}

RUN echo "${DEVELOPER_USERNAME} ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/${DEVELOPER_USERNAME}"

RUN userhome=$(eval echo ~${DEVELOPER_USERNAME}) \
 && chown -R ${DEVELOPER_USERNAME}:${DEVELOPER_USERNAME} $userhome \
 && mkdir -p ${DIR} \
 && chown -R ${DEVELOPER_USERNAME}:${DEVELOPER_USERNAME} ${DIR} \
 && chown -R ${DEVELOPER_USERNAME}:${DEVELOPER_USERNAME} /usr/local/*

RUN mkdir -p \
  /home/${DEVELOPER_USERNAME}/.vscode-server/extensions \
  /home/${DEVELOPER_USERNAME}/.vscode-server-insiders/extensions \
  && chown -R ${DEVELOPER_USERNAME} \
  /home/${DEVELOPER_USERNAME}/.vscode-server \
  /home/${DEVELOPER_USERNAME}/.vscode-server-insiders

WORKDIR ${DIR}

COPY . ${DIR}

RUN apt-get update && apt-get install -y pandoc

USER ${DEVELOPER_USERNAME}

RUN pip install 'poetry==1.6.1'


# --------------------------------------------
FROM base as testing

RUN poetry config virtualenvs.create false

RUN poetry install --no-root


# --------------------------------------------
FROM wikitelmex/fastapi-deployment:latest as production

ARG DIR=/workspaces/lithia-converter-backend

WORKDIR /server

COPY . /server

RUN pip install poetry 'poetry==1.6.1' \
    && poetry config virtualenvs.create false \
    && poetry install --no-dev --no-root

EXPOSE 80

ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80", "--timeout-keep-alive", "1200"]


# --------------------------------------------
FROM testing as development

USER root

WORKDIR ${DIR}

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    openssh-client \
    vim \
    sudo \
    zsh \
    wget

RUN rm -rf /root/.oh-my-zsh

RUN rm -f requirements.txt

USER $DEVELOPER_USERNAME

EXPOSE 8080

# addgroup --gid ${DEVELOPER_UID} ${DEVELOPER_USERNAME} ;  useradd -r -m -u ${DEVELOPER_UID} --gid ${DEVELOPER_UID} --shell /bin/bash -c "Developer User,,," ${DEVELOPER_USERNAME}
# deployment: yarl 1.9.2, websockets 11.0.3
# devcontainer: yarl 1.9.2, websockets 11.0.3