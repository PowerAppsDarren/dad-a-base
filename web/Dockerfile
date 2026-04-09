# Stage 1: Build the React app
FROM node:20-alpine AS build

WORKDIR /app
COPY package.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# Stage 2: Serve with Caddy
FROM caddy:2-alpine

COPY --from=build /app/build /srv

# Caddyfile for SPA routing
RUN echo ':80 { \
    root * /srv \
    try_files {path} /index.html \
    file_server \
}' > /etc/caddy/Caddyfile

EXPOSE 80
