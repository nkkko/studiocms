FROM node:lts AS base 
WORKDIR /app

FROM base AS setup
COPY . .
# Update & Enable Proto
RUN apt-get update && apt-get install -y curl git unzip gzip xz-utils
RUN curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes

FROM setup AS install
RUN proto install

FROM install AS build-deps
RUN pnpm install --frozen-lockfile

FROM build-deps AS build
RUN pnpm build:docs

FROM nginx:alpine AS runtime
COPY ./www/docs/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /www/docs/dist /usr/share/nginx/html
EXPOSE 8080