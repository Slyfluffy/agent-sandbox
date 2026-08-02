FROM ubuntu:26.04@sha256:3131b4cc82a783df6c9df078f86e01819a13594b865c2cad47bd1bca2b7063bb
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
