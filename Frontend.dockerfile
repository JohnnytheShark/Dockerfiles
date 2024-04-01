# Use an official Node runtime as the base image
FROM node:21-alpine3.19 AS builder

# Set the working directory in the Docker image
WORKDIR /app

# Copy package.json and package-lock.json to the Docker image
COPY package*.json ./

# Install dependencies in the Docker image
RUN npm install

# Copy .env.production file into the Docker image
COPY .env.production .env.production

# Set the environment variables using the .env.production file
RUN export $(cat .env.production | xargs)

# Copy the rest of the application code to the Docker image
COPY . .

# Build the Vite React app
RUN npm run build

# Use an official Nginx runtime as the base image for the final stage
FROM nginx:1.24.0-alpine

# Copy the built files from the builder stage to the Nginx html directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port  80 for the app
EXPOSE  80

# Start Nginx when the Docker container starts
CMD ["nginx", "-g", "daemon off;"]
