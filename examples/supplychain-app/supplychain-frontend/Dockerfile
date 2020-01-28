FROM node:11-slim

# Copy app
COPY . /code

# Define directories
WORKDIR /code

# install dependencies
RUN npm install
RUN apt-get update
RUN apt-get install -y nginx

#make scripts executable
RUN chmod +x generate_static_files.sh
RUN chmod +x nginx_setup.sh

# Expose port
EXPOSE 80

CMD ["sh", "-c", "./generate_static_files.sh && ./nginx_setup.sh"]
