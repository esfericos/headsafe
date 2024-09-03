# Name of the Docker image
IMAGE_NAME = yolo-raspberry-pi

# Build the Docker image
build:
	docker build -f Dockerfile.rbpi -t $(IMAGE_NAME) .

# Run the Docker container
run:
	docker run --rm --privileged -v /dev/video0:/dev/video0 --device=/dev/video0 -e DISPLAY=$(DISPLAY) -v /tmp/.X11-unix:/tmp/.X11-unix $(IMAGE_NAME)

# Stop the Docker container
stop:
	docker stop $(IMAGE_NAME)

# Rebuild and run the Docker container
rebuild: build run