import os
import sys
import fitz
from PIL import Image

# Obtener la ruta del script y del archivo PDF
script_path = os.path.dirname(os.path.realpath(sys.argv[0]))
pdf_path = sys.argv[1] #Dirección
# Números de página que se convertirán (1-indexados)
pages_to_convert = sys.argv[2] #formato  1_3_7_8_12_24

# Directorio de salida para las imágenes
output_dir = script_path

# Ajustar la resolución deseada en dpi
dpi = 324

# Abrir el archivo PDF
pdf = fitz.open(pdf_path)

#print("paginas para convertir")
print(pages_to_convert)
if pages_to_convert == "all":
    print("son todos")
    pagestoconvert = list( range(1, len(pdf)+1) )
else:
    array_pages = pages_to_convert.split("_")
    pagestoconvert = []

    for page in array_pages:
        pagestoconvert.append( int(page) )

print ("convertir " + pdf_path)
# Convertir cada página del PDF en una imagen
for i, page_num in enumerate(pagestoconvert):
    # Verificar que el número de página esté dentro del rango válido
    if 1 <= page_num <= len(pdf):
        # Ajustar la matriz de transformación para la resolución
        mat = fitz.Matrix(dpi/72, dpi/72)
        page = pdf.load_page(page_num - 1)  # Índice 0-indexado

        # Renderizar la página como imagen
        pixmap = page.get_pixmap(matrix=mat)
        image = Image.frombytes("RGB", (pixmap.width, pixmap.height), pixmap.samples)

        # Guardar la imagen en archivos individuales
        image_path = os.path.join(output_dir, f'pagina_{page_num-1}.png')

        if os.path.exists(image_path):
            print("La imagen ya existe")
        else:
            image.save(image_path, 'PNG')
    else:
        print(f"La página {page_num} está fuera del rango válido (1-{len(pdf)}). No se convirtió.")
        

# Cerrar el archivo PDF

print("convertido")
print( "total de paginas: " +  str( len(pdf) ) )
pdf.close()
