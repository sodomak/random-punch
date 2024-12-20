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
ENV FLUTTER_VERSION="3.16.9"
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:$PATH"

# Set up Flutter
RUN flutter doctor -v
RUN flutter config --enable-web

# Copy the app source code
WORKDIR /app
COPY . .

# Override just_audio_web version to a compatible one
RUN sed -i 's/just_audio_web: .*/just_audio_web: 0.4.9/' pubspec.yaml && \
    sed -i 's/just_audio: .*/just_audio: 0.9.34/' pubspec.yaml

# Force dependency resolution
RUN rm -f pubspec.lock

# Build the web app
RUN flutter clean && \
    flutter pub get && \
    flutter build web --release

# Ensure just_audio.js is present
RUN mkdir -p build/web/assets/packages/just_audio && \
    find build/web -name "just_audio.js" -exec cp {} build/web/assets/packages/just_audio/ \;

# Serve stage
FROM nginx:alpine

# Copy the built web app to nginx
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set proper permissions for nginx user
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chmod -R 755 /etc/nginx/conf.d && \
    mkdir -p /var/cache/nginx /var/run && \
    chown -R nginx:nginx /var/cache/nginx /var/run && \
    chmod -R 755 /var/cache/nginx /var/run && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid && \
    chmod 755 /var/run/nginx.pid

# Expose port 80
EXPOSE 80

# Switch to non-root user
USER nginx

CMD ["nginx", "-g", "daemon off;"]
