from ultralytics import YOLO
import cv2
import time

if __name__ == "__main__":
    model = YOLO('embedded/data/best.pt')

    f = open("./embedded/out.txt", "w")

    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Failed to open webcam")
        exit()

    while True:
        ret, frame = cap.read()
        if not ret:
            print("Failed to capture webcam's frame")
            break

        results = model(frame)

        annotated_frame = results[0].plot()

        cv2.imshow('Detections', annotated_frame)

        for result in results:
            for cls, conf in zip(result.boxes.cls, result.boxes.conf):
                f.write(f"Class: {int(cls)}, Confidence: {conf:.2f}\n")

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

        # Image capture happens every 3 seconds
        time.sleep(3); 

    cap.release()
    cv2.destroyAllWindows()