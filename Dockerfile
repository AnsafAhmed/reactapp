# FROM node:alpine  
FROM node:18.12.1-buster-slim AS builder
WORKDIR /app
# COPY package.json ./
COPY package.json package-lock.json ./
# RUN npm install
RUN npm ci
# COPY . .
COPY public/ public/
COPY src/ src/
RUN npm run build

FROM nginx:1.25.2-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
RUN touch /var/run/nginx.pid
RUN chown -R nginx:nginx /var/run/nginx.pid /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d
USER nginx
# EXPOSE 8080
# CMD ["npm", "start"]
CMD ["nginx", "-g", "daemon off;"]