# Use official Nginx image
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy our website into container
COPY index.html /usr/share/nginx/html/

# expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
