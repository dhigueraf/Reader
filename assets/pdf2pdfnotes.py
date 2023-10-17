import os
import sys
import PyPDF2

script_path = os.path.dirname(os.path.realpath(sys.argv[0]))
pdf1_path = sys.argv[1] #"tomo1.pdf" #sys.argv[1]
pdf2_path = sys.argv[2] #"formatonotas.pdf" #sys.argv[2]
#pages_to_convert = sys.argv[3]

pages_from_pdf1 = sys.argv[3] #"all" #"1_2_3_4"  # Páginas del primer PDF a incluir
pages_from_pdf2 = sys.argv[4] #"5mm:4_5mm:2_lin:2"  # Páginas del segundo PDF a incluir

output_pdf = sys.argv[5]#'resultado.pdf'

pdf_writer = PyPDF2.PdfWriter()


with open(pdf1_path, 'rb') as pdf1, open(pdf2_path, 'rb') as pdf2:
    pdf1_reader = PyPDF2.PdfReader(pdf1)
    pdf2_reader = PyPDF2.PdfReader(pdf2)

    arraypagespdf1 = []

    #Primer archivo
    if pages_from_pdf1 != "all": #Si llega un arrelgo de paginas
        arrayp1str = pages_from_pdf1.split("_")
        for page in arrayp1str:
            arraypagespdf1.append( int(page) )

        for page_num in arraypagespdf1: #
            pdf_writer.add_page(pdf1_reader.pages[page_num])
    else: #Si llega un all
         for page in pdf1_reader.pages:
            pdf_writer.add_page(page)

    #Separar paginas de notas
    notespages = []
    arraypages2str = pages_from_pdf2.split("_")
    for page in arraypages2str:
        notetypearray = page.split(":")
        pagetype = notetypearray[0]
        pagequanty = int(notetypearray[1])
        indextoadd = 0
        
        if pagetype == "5mm":
            indextoadd = 0
        if pagetype == "7mm":
            indextoadd = 1
        if pagetype == "lin":
            indextoadd = 2

        pageiter = 0
        #print("anadir " + str(page_num) + " veces")
        while pageiter < pagequanty:
            #print("anadir")
            notespages.append(indextoadd) 
            pageiter +=1

    #Agregar paginas de notas
    for page_num in notespages:
        pdf_writer.add_page(pdf2_reader.pages[page_num])



    with open(output_pdf, 'wb') as output:
        pdf_writer.write(output)
    
print("terminado")