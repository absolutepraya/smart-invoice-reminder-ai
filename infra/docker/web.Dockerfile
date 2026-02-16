FROM node:22-alpine AS build

WORKDIR /app
RUN corepack enable && corepack prepare pnpm@latest --activate

COPY apps/web/package.json apps/web/pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile

COPY apps/web/ .
RUN pnpm build

FROM nginx:alpine
LABEL org.opencontainers.image.source=https://github.com/absolutepraya/smart-invoice-reminder-ai
COPY --from=build /app/dist /usr/share/nginx/html
COPY infra/docker/nginx-spa.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
