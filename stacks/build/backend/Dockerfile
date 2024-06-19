# syntax=docker/dockerfile:1

ARG ASPNET_VERSION=7.0
ARG SDK_VERSION=7.0

FROM mcr.microsoft.com/dotnet/aspnet:${ASPNET_VERSION} AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:${SDK_VERSION} as build
ENV PROJECT=Explorer.API
ARG SRC_URL=https://github.com/PSW-group5-2023/tourism-be/archive/refs/heads/feat/deployment.tar.gz
ARG GITHUB_TOKEN
WORKDIR /src
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends curl tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir ../downloads && cd ../downloads \
    && curl -L -H "Authorization: token ${GITHUB_TOKEN}" ${SRC_URL} | tar -xz \
    && mv $(ls -d -- */|head -n 1) app && mv app/* /src
WORKDIR /src/src
RUN dotnet restore "${PROJECT}/${PROJECT}.csproj"
RUN dotnet build "${PROJECT}/${PROJECT}.csproj" -c Release

FROM build as publish
RUN dotnet publish "${PROJECT}/${PROJECT}.csproj" -c Release -o /app/publish


FROM base AS final
ENV ASPNETCORE_URLS=http://+:80
COPY --from=publish /app .
WORKDIR /app/publish
CMD ["dotnet", "Explorer.API.dll"]


FROM build as migration-base
ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet tool install --global dotnet-ef --version 7.*

FROM migration-base AS execute-migration

ENV STARTUP_PROJECT=${PROJECT}
ENV MIGRATION=init
ENV DATABASE_SCHEMA=""
ENV DATABASE_HOST=""
ENV DATABASE_PASSWORD=""
ENV DATABASE_USERNAME=""

ENV STAKEHOLDERS_TARGET_PROJECT=Explorer.Stakeholders.Infrastructure

ENV TOURS_TARGET_PROJECT=Explorer.Tours.Infrastructure

ENV BLOG_TARGET_PROJECT=Explorer.Blog.Infrastructure

ENV ENCOUNTERS_TARGET_PROJECT=Explorer.Encounters.Infrastructure

ENV PAYMENTS_TARGET_PROJECT=Explorer.Payments.Infrastructure

CMD PATH="$PATH:/root/.dotnet/tools" \
    dotnet-ef migrations add "${MIGRATION}-stakeholders" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Stakeholders/${STAKEHOLDERS_TARGET_PROJECT}/${STAKEHOLDERS_TARGET_PROJECT}.csproj" \
        -c "StakeholdersContext" \
        --configuration Release && \
    PATH="$PATH:/root/.dotnet/tools" \   
    dotnet-ef database update "${MIGRATION}-stakeholders" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Stakeholders/${STAKEHOLDERS_TARGET_PROJECT}/${STAKEHOLDERS_TARGET_PROJECT}.csproj" \
        -c "StakeholdersContext" \
        --configuration Release && \
    dotnet-ef migrations add "${MIGRATION}-tours" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Tours/${TOURS_TARGET_PROJECT}/${TOURS_TARGET_PROJECT}.csproj" \
        -c "ToursContext" \
        --configuration Release && \  
    dotnet-ef database update "${MIGRATION}-tours" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Tours/${TOURS_TARGET_PROJECT}/${TOURS_TARGET_PROJECT}.csproj" \
        -c "ToursContext" \
        --configuration Release && \
    dotnet-ef migrations add "${MIGRATION}-blog" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Blog/${BLOG_TARGET_PROJECT}/${BLOG_TARGET_PROJECT}.csproj" \
        -c "BlogContext" \
        --configuration Release && \
    dotnet-ef database update "${MIGRATION}-blog" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Blog/${BLOG_TARGET_PROJECT}/${BLOG_TARGET_PROJECT}.csproj" \
        -c "BlogContext" \
        --configuration Release && \
    dotnet-ef migrations add "${MIGRATION}-encounters" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Encounters/${ENCOUNTERS_TARGET_PROJECT}/${ENCOUNTERS_TARGET_PROJECT}.csproj" \
        -c "EncountersContext" \
        --configuration Release && \
    dotnet-ef database update "${MIGRATION}-encounters" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Encounters/${ENCOUNTERS_TARGET_PROJECT}/${ENCOUNTERS_TARGET_PROJECT}.csproj" \
        -c "EncountersContext" \
        --configuration Release && \  
    dotnet-ef migrations add "${MIGRATION}-payments" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Payments/${PAYMENTS_TARGET_PROJECT}/${PAYMENTS_TARGET_PROJECT}.csproj" \
        -c "PaymentsContext" \
        --configuration Release && \
    dotnet-ef database update "${MIGRATION}-payments" \
        -s "${STARTUP_PROJECT}/${STARTUP_PROJECT}.csproj" \
        -p "Modules/Payments/${PAYMENTS_TARGET_PROJECT}/${PAYMENTS_TARGET_PROJECT}.csproj" \
        -c "PaymentsContext" \
        --configuration Release  