# Build stage for Deno Backend Docker Container
FROM denoland/deno:alpine-1.40.5 AS builder

# Set the working directory
WORKDIR /app

# Create the .deno_cache directory and set permissions
RUN mkdir -p ./.deno_cache && chown -R deno:deno ./.deno_cache

# Set environment variables
ENV DENO_DIR=./.deno_cache

# Copy your application files into the container
COPY . .

# Build the application
RUN deno cache main.js

# Final stage
FROM denoland/deno:alpine-1.40.5

# Set the working directory
WORKDIR /app

# Copy the built application and cache from the builder stage
COPY --from=builder /app /app

# Expose the port your app will run on
EXPOSE  8080

# Use the deno user for security
USER deno

# Command to run your application
CMD ["deno", "run", "--allow-net", "--allow-read", "--allow-env", "--allow-run", "--allow-sys", "main.js"]
