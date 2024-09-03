FROM arm32v7/python:3.9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libopencv-dev \
    python3-opencv \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir ultralytics opencv-python-headless requests

COPY main.py /app/main.py

WORKDIR /app

CMD ["python3", "main.py"]