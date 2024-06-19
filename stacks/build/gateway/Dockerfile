# syntax=docker/dockerfile:1

FROM node:20.13.1-alpine3.19 AS base
WORKDIR /src
COPY ./files/scripts/install-dependencies.sh .
ARG FRONTEND_APP_SRC_URL=https://github.com/PSW-group5-2023/tourism-fe/archive/refs/heads/deployment.tar.gz
SHELL ["/bin/ash", "-o", "pipefail", "-c"]
RUN ./install-dependencies.sh ${FRONTEND_APP_SRC_URL}
COPY ./files/front/environment.ts.template ./app
COPY ./files/scripts/build-app.sh .

FROM base AS prodBuild
ARG TOURISM_API_URL=https://localhost:44333/api/
ARG TOURISM_WSS_URL=wss://localhost:44333/hub
RUN ./build-app.sh ${TOURISM_API_URL} ${TOURISM_WSS_URL}

FROM nginx:1.26.0-alpine AS gatewayWithFront
COPY --from=prodBuild /app /usr/share/nginx/html/app
COPY ./files/config/nginx.conf /etc/nginx/nginx.conf
COPY ./files/config/api_gateway.conf /etc/nginx/api_gateway.conf
