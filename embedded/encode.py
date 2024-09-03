import cv2
import time
from datetime import datetime

# Initialize the webcam
cam = cv2.VideoCapture(0)

# Check if the webcam is opened correctly
if not cam.isOpened():
    print("Error: Could not access the camera.")
else:
    # Wait for 5 seconds before capturing the image
    print("Waiting for 5 seconds...")
    time.sleep(5)
    
    # Capture a frame
    result, image = cam.read()
    
    if result:
        currentTime = datetime.now().strftime("%d-%m-%Y")
        print(currentTime)


        # Convert the image to JPEG format in memory and encode it as binary
        _, buffer = cv2.imencode('.jpg', image)
        

        # Write the binary data directly to a file
        with open("image_binary.bin", "wb") as file:
            file.write(buffer)
        
        print("Binary image data has been written to 'image_binary.bin'.")
        
    else:
        print("Error: Could not capture an image.")

    # Release the camera
    cam.release()