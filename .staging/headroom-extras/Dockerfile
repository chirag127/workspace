FROM ghcr.io/chopratejas/headroom:latest
# Enable extras: code-aware compression + image
# Note: [ml] and [memory] omitted — both pull hnswlib which needs C++ compiler not in base image
RUN pip install --no-cache-dir "headroom-ai[code,image]"
# Verify
RUN headroom --version
