# Content: Dockerfile for building the documentation site
# Description: Build a STATIC nginx container for the documentation site

# Arguments
ARG NODE_VERSION=20.14.0

# Build stage
FROM node:${NODE_VERSION} AS build 
WORKDIR /app
COPY . .
RUN corepack enable pnpm && pnpm -v
RUN pnpm install --frozen-lockfile
RUN pnpm build:docs

# Runtime stage
FROM nginx:alpine AS runtime
COPY ./www/docs/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/www/docs/dist /usr/share/nginx/html
EXPOSE 8080