# Stage 1: Builder
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /usr/src/app

# Copy package files first for caching layers
COPY package*.json ./

# Install all dependencies (including devDependencies for linting/testing in CI)
RUN npm ci

# Copy the rest of the application files
COPY . .

# Stage 2: Final lightweight image
FROM node:20-alpine

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Set the working directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install only production dependencies to keep the image lightweight
RUN npm ci --only=production

# Copy application source code from builder stage
COPY --from=builder /usr/src/app/src ./src

# Use non-root user built into the node image for security
USER node

# Expose port
EXPOSE 3000

# Define a healthcheck to ensure the container is running and healthy
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Command to start the application
CMD ["node", "src/server.js"]
