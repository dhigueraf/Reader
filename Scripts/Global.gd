extends Node

var basedir = ""

var softwareinfo = {
	"nombre": "Sumo Primero software",
	"version": 0,
	"carpetabase": "cursos",
	"sistemarchivos": []
}

var softwareOnline = {}

var SelectedCurso = {
	"nombre" : {
		"carpeta":"Carpeta",
		"boton":"Botón"
	},
	"location" : "",
	"archivos" : ""
}

var FileToRead = {}

var FileReading = {
	paginas = [],
	currentindex = 0,
	numeropaginas = 0,
	nombre = "",
	curso = ""
}

var captituloactual = {
	numero = -1,
	capitulo = {}
}

var interactivos = {
}

func _ready():
	print("Global Ready")
	
func DeletePreviousImages():
	var converterdir = Global.basedir + "/converter"
	var dir = DirAccess.open(converterdir)
	
	print("eliminar imagenes anteriores")
	if dir:
		dir.list_dir_begin()
		var iteratedname = dir.get_next()
		while (iteratedname != ""):
			if not dir.current_is_dir():
				print("Found file: " + iteratedname)
				var filearray = iteratedname.split(".")
				if( filearray[-1] == "png" ):
					print(iteratedname)
					dir.remove(converterdir + "/" + iteratedname)
			iteratedname = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
func GenerarImagenes(location,pag,wait):
	print("iniciar en pagina " + str(pag))
	var converterdir = Global.basedir + "/converter"
	var filetoopen = Global.basedir + "/" + location
	#var filetoopen = location
	
	var numerospags = [1,2,3]
	
	if pag > 2:
		numerospags.append(pag-2)
		numerospags.append(pag-1)
		numerospags.append(pag)
		numerospags.append(pag+1)
		numerospags.append(pag+2)
		numerospags.append(pag+3)
	else:
		numerospags.append(pag)
		
	print(converterdir)
	var dir = DirAccess.open(converterdir)
	
	
	print("generar pdf images")
	print(filetoopen)
	var filetoopenarray = filetoopen.split(".")
	
	if filetoopenarray[-1] == "pdf":
		print("es convertible")
		var sistemaoperativo = OS.get_name() #Chequear sistema operativo
		print(sistemaoperativo)
		var ejecutable = converterdir + "/pdf2pngimgs.exe"
		if sistemaoperativo.to_lower() == "windows":
			print("windows")
			ejecutable = converterdir + "/pdf2pngimgs.exe"
		elif sistemaoperativo.to_lower() == "x11" || sistemaoperativo.to_lower() == "linux":
			print("linux")
			ejecutable = converterdir + "/pdf2pngimgs"
		
		var output = []
		
		var numpagstr = ""
		for numpa in numerospags:
			numpagstr += str(numpa) + "_"
		numpagstr = numpagstr.left(-1)
		
		print("Crear paginas")
		print(numpagstr)
		print(filetoopen)
		var totalpagstr = "0"
		
		OS.execute(ejecutable, [filetoopen, numpagstr], output, wait)
		'''
		print("-----Ouput: -----")
		for text in output:
			print(text)
			if "total de paginas:" in str(text):
				print("Es el final " + str(text))
				totalpagstr = str(text).trim_prefix("total de paginas: ")

		print("-----Fin Ejecución-----")
		'''
		print(output)
		
		#obtener numero de paginas
		print("-----Ouput: -----")
		
		var ouputarray = output[0].split(",")
		
		if "\r\n" in output[0]:
			ouputarray = output[0].split("\r\n")
		elif "\n":
			ouputarray = output[0].split("\n")
		elif "\r":
			ouputarray = output[0].split("\r")
			
		for text in ouputarray:
				print(text)
				if "total de paginas:" in str(text):
					print("Es el final " + str(text))
					totalpagstr = str(text).trim_prefix("total de paginas: ")
		#print(totalpagstr)
		print("-----Fin Ouput-----")
		print("numero de paginas: " + totalpagstr)
		Global.FileReading.numeropaginas = int(totalpagstr)
		
		if pag >= Global.FileReading.numeropaginas-1:
			Global.FileReading.currentindex = Global.FileReading.numeropaginas -1
		else:
			Global.FileReading.currentindex = pag
			
		print( Global.FileToRead )
		Global.FileReading.nombre = Global.FileToRead.nombre
		print("imagenes generadas")
		print(Global.FileReading)


func generatePDF(rango,notas,all,nombre,wait):
	print("Generar PDF")
	print(Global.FileToRead)
	var converterdir = Global.basedir + "/converter"
	var filedir = Global.basedir + "/" + Global.FileToRead.sublocation
	#var filedir =  Global.FileToRead.location
	var notasdir = Global.basedir + "/assets/" + "formatonotas.pdf" 
	var finalfile = Global.basedir + "/generado/" + nombre + ".pdf"  
	
	
	var sistemaoperativo = OS.get_name() #Chequear sistema operativo
	var ejecutable = converterdir + "/pdf2pdfnotes.exe"
	
	if sistemaoperativo.to_lower() == "windows":
		print("windows")
		ejecutable = converterdir + "/pdf2pdfnotes.exe"
	elif sistemaoperativo.to_lower() == "x11" || sistemaoperativo.to_lower() == "linux":
		print("linux")
		ejecutable = converterdir + "/pdf2pdfnotes"

	if all:
		rango = "all"

	print("archivos")
	print(filedir)
	print(notasdir)
	print("ejecutable")
	print(ejecutable)
	print(rango)
	print(notas)
	print(finalfile)
	
	var output = []
	
	OS.execute(ejecutable, [filedir, notasdir, rango, notas,finalfile], output, wait)
	
	print(output)
	print("-----Ouput: -----")
	for text in output:
		print(text)
	print("-----Fin Ejecución-----")
