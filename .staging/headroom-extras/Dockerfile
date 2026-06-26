FROM ghcr.io/chopratejas/headroom:latest
USER root
# Install extras that work without a C++ compiler in the base image.
# [code]   = tree-sitter parsers for code-aware compression
# [image]  = pillow + opencv + rapidocr
# [memory] = SKIPPED — hnswlib needs C++11 compiler not present in base
# [ml]     = SKIPPED — torch alone adds ~2.4 GB; brings no proxy-side win
RUN pip install --no-cache-dir "headroom-ai[code,image]"
RUN headroom --version
