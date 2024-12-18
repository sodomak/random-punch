# Build stage
FROM debian:bookworm-slim AS builder

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
ENV FLUTTER_VERSION="3.24.5"
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:$PATH"

# Set up Flutter
RUN flutter doctor -v
RUN flutter config --enable-web

# Copy the app source code
WORKDIR /app
COPY . .

# Build the web app
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# Serve stage
FROM nginx:alpine

# Copy the built web app to nginx
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration if needed
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
