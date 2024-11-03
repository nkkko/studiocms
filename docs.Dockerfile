ARG NODE_VERSION=20.14.0

FROM node:${NODE_VERSION} AS base 
WORKDIR /app
COPY package.json pnpm-lock.yaml ./

FROM base AS build-deps
RUN corepack enable pnpm && pnpm -v
RUN pnpm install --frozen-lockfile

FROM build-deps AS build
COPY . .
RUN pnpm build:docs

FROM nginx:alpine AS runtime
COPY ./www/docs/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /www/docs/dist /usr/share/nginx/html
EXPOSE 8080