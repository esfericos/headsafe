from ultralytics import YOLO
import cv2
import time
import json
import base64
import requests
from datetime import datetime

def save_and_send_image(image, server_url):
    # Converte a imagem para o formato JPEG em memória e a codifica como binário
    _, buffer = cv2.imencode('.jpg', image)

    # Converte o numpy array para bytes
    image_bytes = buffer.tobytes()

    # Converte os bytes para uma string base64
    image_base64 = base64.b64encode(image_bytes).decode('utf-8')

    # Captura a data e hora atuais
    date_taken = datetime.now().strftime("%Y-%m-%d %H:%M")

    # Cria um JSON com a imagem em base64 e a data/hora de captura
    json_data = json.dumps({
        "image": image_base64,
        "date_taken": date_taken
    })

    # Envia a imagem em uma solicitação POST para o servidor
    headers = {'Content-Type': 'application/json'}
    response = requests.post(server_url, data=json_data, headers=headers)

    if response.status_code == 200:
        print("Image and date successfully sent to the server.")
    else:
        print(f"Failed to send image and date. Status code: {response.status_code}")

def capture_and_check_images(cap, model, server_url, num_photos=5, threshold=3):
    detected_no_hardhats_count = 0
    selected_image = None
    
    for _ in range(num_photos):
        ret, frame = cap.read()
        if not ret:
            print("Failed to capture webcam's frame")
            continue

        results = model(frame)

        for result in results:
            for cls, _ in zip(result.boxes.cls, result.boxes.conf):
                if int(cls) == 1:  # Índice da classe NO-Hardhats é 1
                    detected_no_hardhats_count += 1
                    selected_image = frame  # Armazena a última imagem detectada com NO-Hardhats
                    break  # Não precisa continuar verificando as outras caixas

        # Intervalo de 2 segundos entre cada captura
        time.sleep(2)

    if detected_no_hardhats_count >= threshold:
        if selected_image is not None:
            save_and_send_image(selected_image, server_url)

if __name__ == "__main__":
    model = YOLO('./data/best.pt')

    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Failed to open webcam")
        exit()

    server_url = "http://35.170.158.159:3030/"


    while True:
        capture_and_check_images(cap, model, server_url)

        # Aguarda 5 minutos (300 segundos) antes da próxima verificação
        time.sleep(300)

    cap.release()
    cv2.destroyAllWindows()
