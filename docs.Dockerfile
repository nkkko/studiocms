FROM node:lts as base 
WORKDIR /app

FROM base as setup
COPY . .
# Update & Enable Proto
RUN apt-get update && apt-get install -y curl git unzip gzip xz-utils
RUN curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes
CMD proto install

FROM setup as build-deps
RUN pnpm install --frozen-lockfile

FROM build-deps as build
RUN pnpm build:docs

FROM nginx:alpine as runtime
COPY ./www/docs/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /www/docs/dist /usr/share/nginx/html
EXPOSE 8080