# syntax=docker/dockerfile:1.7
# Use Node LTS for Metallic
FROM node:20

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy dependencies first
COPY package.json pnpm-lock.yaml* ./

# Install
RUN pnpm config set ignore-scripts false
RUN pnpm install --frozen-lockfile

# Copy the full project
COPY . .

# Build WITHOUT running test suite
RUN npx tsc && npx vite build

# Metallic's server runs with index.ts
EXPOSE 3000

# Start server WITHOUT tests
CMD ["tsx", "index.ts"]
