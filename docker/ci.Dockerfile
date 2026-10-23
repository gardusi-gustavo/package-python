FROM python:3.13-bookworm
WORKDIR /repo
RUN pip install --no-cache-dir pytest build twine
CMD ["bash", "scripts/ci.sh"]
