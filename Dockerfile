syntax=docker/dockerfile:1.7

FROM node:20

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Allow pnpm to run build scripts
RUN pnpm config set ignore-scripts false
RUN pnpm config set enable-pre-post-scripts true

# Copy dependency files
COPY package.json pnpm-lock.yaml* ./

# Approve builds for esbuild / RH
RUN pnpm approve-builds --auto

# Install deps
RUN pnpm install --frozen-lockfile

# Copy project
COPY . .

# Fix RH cache folder
RUN mkdir -p node_modules/@rubynetwork/rh/cache-js

# Build project
RUN npx tsc && npx vite build

EXPOSE 3000

CMD ["npx", "tsx", "index.ts"]
