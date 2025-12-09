# syntax=docker/dockerfile:1.7
FROM node:20

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# --- Fix PNPM blocking the RH install script ---
RUN pnpm config set ignore-scripts false
RUN pnpm config set enable-pre-post-scripts true

# Copy dependency files
COPY package.json pnpm-lock.yaml* ./

# Install dependencies AND allow RH & esbuild to run their scripts
RUN pnpm approve-builds --auto
RUN pnpm install --frozen-lockfile

# Copy full project
COPY . .

# --- Fix Rammerhead missing cache folder (PNPM + symlinks bug) ---
RUN mkdir -p node_modules/@rubynetwork/rh/cache-js

# Build project
RUN npx tsc && npx vite build

EXPOSE 3000

CMD ["tsx", "index.ts"]
