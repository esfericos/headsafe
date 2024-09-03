import cv2
import time
import numpy as np

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
        # Save the captured image to a file
        cv2.imwrite("GeeksForGeeks.png", image)
        
        # Optionally, display the image in a window
        cv2.imshow("Captured Image", image)
        cv2.waitKey(0)
        cv2.destroyAllWindows()
        
        # Convert the image to JPEG format in memory
        _, buffer = cv2.imencode('.jpg', image)
        
        # Write the binary data to a file
        with open("image_binary.bin", "wb") as file:
            file.write(buffer)
        
        print("Binary image data has been written to 'image_binary.bin'.")
        
    else:
        print("Error: Could not capture an image.")

    # Release the camera
    cam.release()