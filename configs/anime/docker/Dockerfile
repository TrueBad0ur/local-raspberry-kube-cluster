FROM nginx:1.27.2-alpine3.20

COPY index.html /usr/share/nginx/html/
COPY arts /usr/share/nginx/html/arts

CMD ["nginx", "-g", "daemon off;"]
