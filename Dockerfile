FROM ubuntu:26.04@sha256:678c6550cc43645e08669028bc177f50be4e7c5b8cca677067b1914d4afc7a03
# Define the variable for the build phase only
ARG DEBIAN_FRONTEND=noninteractive
# Combine all configuration into a single RUN layer to minimize image size
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates && \
    # --- GitHub CLI Setup ---
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        gpg --dearmor | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://apt.github.com/ /" | \
        tee /etc/apt/sources.list.d/github-cli.list && \
    # --- Final Installation ---
    apt-get update && \
    apt-get install -y --no-install-recommends gh && \
    # Cleanup to keep the image slim
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
