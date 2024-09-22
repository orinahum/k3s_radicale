# Use a small image for Radicale
FROM python:3.9-alpine

ARG VERSION='temp_content'
ENV RADICALE_USER=user RADICALE_PASS=pass

# Install dependencies and Radicale
RUN apk add --no-cache gcc musl-dev libffi-dev ca-certificates openssl \
    && pip install --no-cache-dir "Radicale[bcrypt,md5] @ https://github.com/Kozea/Radicale/archive/${VERSION}.tar.gz" \
    && pip install passlib[bcrypt] \
    && apk del gcc musl-dev libffi-dev

# Volumes for config and data
VOLUME /var/lib/radicale /config

# Expose Radicale port
EXPOSE 5232

# Copy configuration
COPY radicale.config /config/radicale.config
COPY htpasswd /config/htpasswd

# Run Radicale
CMD ["radicale", "--config", "/config/radicale.config"]