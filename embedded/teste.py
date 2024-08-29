from ultralytics import YOLO
import cv2

if __name__ == "__main__":
    # Carregar o modelo YOLOv8 pré-treinado
    model = YOLO('embedded/best.pt')  # ou o caminho para o modelo treinado

    # Inicializar a captura de vídeo da webcam (0 é geralmente a webcam padrão)
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Erro ao abrir a webcam")
        exit()

    while True:
        # Capturar cada frame da webcam
        ret, frame = cap.read()
        if not ret:
            print("Erro ao capturar o frame da webcam")
            break

        # Fazer inferência no frame capturado
        results = model(frame)

        # Mostrar a imagem com as detecções
        annotated_frame = results[0].plot()  # Adiciona as detecções ao frame

        # Exibir o frame com as detecções
        cv2.imshow('Detecções', annotated_frame)

        # Imprimir as classes detectadas e as confidências
        for result in results:
            print("Classes detectadas:", result.boxes.cls)
            print("Confidências:", result.boxes.conf)

        # Sair do loop se a tecla 'q' for pressionada
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Liberar a captura e fechar todas as janelas
    cap.release()
    cv2.destroyAllWindows()
