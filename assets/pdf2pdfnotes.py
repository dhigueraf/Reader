import os
import sys
import PyPDF2

script_path = os.path.dirname(os.path.realpath(sys.argv[0]))
pdf1_path = sys.argv[1]
pdf2_path = sys.argv[2]
pages_to_convert = sys.argv[3]

pages_from_pdf1 = [1, 2, 3]  # Páginas del primer PDF a incluir
pages_from_pdf2 = [4, 5, 6]  # Páginas del segundo PDF a incluir

output_pdf = 'resultado.pdf'

pdf_writer = PyPDF2.PdfWriter()

with open(pdf1_path, 'rb') as pdf1, open(pdf2_path, 'rb') as pdf2:
    pdf1_reader = PyPDF2.PdfReader(pdf1)
    pdf2_reader = PyPDF2.PdfReader(pdf2)

    for page_num in pages_from_pdf1:
        pdf_writer.add_page(pdf1_reader.pages[page_num - 1])

    for page_num in pages_from_pdf2:
        pdf_writer.add_page(pdf2_reader.pages[page_num - 1])

    with open(output_pdf, 'wb') as output:
        pdf_writer.write(output)