# Content: Dockerfile for building the documentation site
# Description: Build a STATIC nginx container for the documentation site

# Arguments

# Node version
ARG NODE_VERSION=20.14.0
# App directory
ARG APP_DIR=www/docs
# pnpm build command
ARG BUILD_CMD=build:docs

# Build stage
FROM node:${NODE_VERSION} AS build 
WORKDIR /app
COPY . .
RUN corepack enable pnpm && pnpm -v
RUN pnpm install --frozen-lockfile
RUN pnpm ${BUILD_CMD}

# Runtime stage
FROM nginx:alpine AS runtime
COPY ./${APP_DIR}/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/${APP_DIR}/dist /usr/share/nginx/html
EXPOSE 8080