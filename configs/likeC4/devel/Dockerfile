FROM node:23-alpine AS build
WORKDIR /app

RUN npm install --global likec4
COPY infra/home .
RUN likec4 build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
