# Use a small image for Radicale
FROM python:3.9-alpine

ARG VERSION=3.2.3
ARG DEPENDENCIES="bcrypt,md5"
ENV RADICALE_USER=user RADICALE_PASS=pass

# Install build dependencies, Radicale, and remove build dependencies after installation
RUN apk add --no-cache gcc musl-dev libffi-dev ca-certificates openssl \
    && if [ "$VERSION" != "master" ]; then \
        pip install --no-cache-dir "Radicale[${DEPENDENCIES}] @ https://github.com/Kozea/Radicale/archive/refs/tags/v${VERSION}.tar.gz"; \
    else \
        pip install --no-cache-dir "Radicale[${DEPENDENCIES}] @ https://github.com/Kozea/Radicale/archive/${VERSION}.tar.gz"; \
    fi \
    && apk del gcc musl-dev libffi-dev

# Volumes for config and data
VOLUME /var/lib/radicale /config

# Expose Radicale port
EXPOSE 5232

# Copy configuration
COPY ./radicale_config /config/radicale.config
COPY ./htpasswd /config/htpasswd

# Run Radicale
CMD ["radicale", "--config", "/config/radicale.config"]