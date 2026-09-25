FROM ubuntu:26.04@sha256:da6fc2be547864451aa253836dd926da33623312df4a9a243e35dc877c378a78
# Define the variable for the build phase only
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    # --- Docker CLI Setup ---
    # Add Docker's official GPG key:
    install -m 0755 -d /etc/apt/keyrings && \
    curl \
        -fsSL https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    # Add the repository to Apt sources:
    tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# --- GitHub CLI Setup ---
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        gpg --dearmor | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://apt.github.com/ /" | \
        tee /etc/apt/sources.list.d/github-cli.list && \
    # --- Final Installation ---
    apt-get update && \
    apt-get install -y --no-install-recommends \
        docker-ce-cli \
        gh && \
    # Cleanup to keep the image slim
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
