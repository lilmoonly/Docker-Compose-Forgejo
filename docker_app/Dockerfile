# Build stage
FROM ubuntu:latest AS builder

ENV GO_VERSION=1.21.0
ENV NODE_VERSION=20
ENV PATH="/usr/local/go/bin:${PATH}"

# Installing packages
RUN apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y && \
    apt install -y --no-install-recommends \
    make git gcc build-essential wget curl openssh-client ca-certificates && \
    update-ca-certificates && \
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go

# Installing Node.js
RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - && \
    apt install -y nodejs && \
    npm install --global npm@latest

# Creating user in builder
RUN useradd -m -d /home/forgejo -s /bin/bash forgejo

# Setting SSH
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh && \
    ssh-keyscan -H github.com >> /root/.ssh/known_hosts

# Delete old data for avoiding "destination path already exists"
RUN rm -rf /home/forgejo/app

# Cloning source code
#RUN --mount=type=ssh git clone --depth=1 git@github.com:lilmoonly/Forgejo-Docker-Kubernetes.git /home/forgejo/app

RUN git clone --depth=1 https://codeberg.org/forgejo/forgejo.git /home/forgejo/app

# Build Forgejo
RUN cd /home/forgejo/app && make build

# Final container
FROM ubuntu:latest

#  Installing packages
RUN apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y && \
    apt install -y --no-install-recommends \
    git postgresql-client gettext nano

# Creating new user
RUN useradd -m -d /home/forgejo -s /bin/bash forgejo

# Copy build from builder
COPY --from=builder /home/forgejo/app /home/forgejo/app

# Copy entrypoint.sh
COPY forgejo/config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy config template 
COPY forgejo/config/app.ini.template /home/forgejo/app/custom/conf/app.ini.template
RUN chmod 644 /home/forgejo/app/custom/conf/app.ini.template

# Setting owner
RUN chown -R forgejo:forgejo /home/forgejo/app

WORKDIR /home/forgejo/app
USER forgejo

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
