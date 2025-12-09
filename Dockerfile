# Use stable Node LTS
FROM node:20

WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm

# Copy package files first
COPY package.json pnpm-lock.yaml* ./

# Install dependencies
RUN pnpm install

# Copy the rest of your application
COPY . .

# Build the app
RUN pnpm run build

# Metallic usually runs on port 3000
EXPOSE 3000

# Run the app
CMD ["pnpm", "start"]
