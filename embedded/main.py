from ultralytics import YOLO

if __name__ == "__main__":
    # Carregar o modelo YOLOv8 pré-treinado
    model = YOLO('yolov8n.pt')

    # Treinar o modelo utilizando a GPU 3060 Ti (especificando device=0)
    results = model.train(
        data='data.yaml',  # Caminho para o arquivo data.yaml
        epochs=50,         # Número de épocas
        batch=16,          # Tamanho do lote
        imgsz=640,         # Tamanho das imagens
        name='train_run34', # Nome da execução do treinamento
        project='runs/detect', # Diretório onde os resultados serão salvos
        workers=8,         # Número de processos de trabalho para carregar os dados
        device=0,          # Especifica a GPU; '0' geralmente se refere à primeira GPU (3060 Ti)
        amp=False          # Desabilitar AMP para evitar problemas
    )

    # # Avaliar o modelo no conjunto de validação
    # results = model.val(data='data.yaml')

    # Fazer inferências em uma nova imagem de teste
    results = model('test/images/-19-_png_jpg.rf.f4aaa6a9746eea26e38e94d3c85ef10c.jpg')
    results[0].show()  # Mostra a imagem com as detecções

    # Salvar os resultados das inferências
    results.save('runs/detect/inference_results/')
