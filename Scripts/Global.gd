extends Node

var jsonUrl = "https://static.sumaysigue.uchile.cl/Sumo%20Primero/App/Json/gdd2.json"
var anaUrl = "https://analytics.gdd.sumoprimero.cmmedu.uchile.cl"
var anafolders = []
var basedir = ""
var online = false
var AnaRequest = null

var softwareinfo = {
	"nombre": "Sumo Primero software",
	"version": 0,
	"carpetabase": "cursos",
	"sistemarchivos": []
}

var JsonGDD = {}
var nivel = {}
var tomo = {}
var SelectedCurso = {}
var selectedPestanaEditable="presentaciones" #"evaluaciones"

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

#analiticsvariables
var clientid = "0"

var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
func gen_unique_string(length):
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result
	

func _ready():
	print("Global Ready")
	basedir = OS.get_executable_path().get_base_dir() #Carpeta base 
	
	clientid = gen_unique_string(30)
	print("CLIENT ID " + clientid)
	
	AnaRequest = HTTPRequest.new()
	add_child(AnaRequest)
	AnaRequest.request_completed.connect(self._ana_request_completed)


func askanarenquest(url,header,datatorequest):
	print("hacer request a " + str(url) )
	var customheader = ["GDD-Password: NddagN87DNAJKDNAFYQ982KAJbaD7892bJHADBASDMa79QBJKkjfb2h839basjk"] + header
	print(datatorequest)
	var error = AnaRequest.request( url,customheader,HTTPClient.METHOD_POST, JSON.stringify(datatorequest) )
	#print(error)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func sendevent(events):
	var eventsurl = "https://www.google-analytics.com/mp/collect?api_secret=u5Z6LvGoQzWIR-YnEGdnpQ&measurement_id=G-CN39F3EHBK"
	print("hacer request a " + str(eventsurl) )
	var datatorequest = {
		"client_id": clientid,
		"events" : events
	}
	print(datatorequest)
	var error = AnaRequest.request( eventsurl,["Content-Type: application/json"],HTTPClient.METHOD_POST, JSON.stringify(datatorequest) )
	#print(error)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func testrquest(url):
	print("test request")
	var urltest = "http://localhost:8000"
	print(urltest+url)
	var urltosend = urltest + url
	var customheader = ["GDD-Password: NddagN87DNAJKDNAFYQ982KAJbaD7892bJHADBASDMa79QBJKkjfb2h839basjk"] #+ header
	var error = AnaRequest.request( urltosend,customheader,HTTPClient.METHOD_GET, JSON.stringify({}) )
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _ana_request_completed(result, response_code, headers, body):
	print("Analitic request")
	print(response_code)
	print("headers")
	print(headers)
	print("result")
	print(result)
	#print("body")
	#print(body)


func changeScene(scenename):
	get_tree().change_scene_to_file(scenename)

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
	var converterdir = basedir + "/converter"
	var filedir = basedir + "/" + Global.FileToRead.sublocation
	#var filedir =  Global.FileToRead.location
	var notasdir = basedir + "/assets/" + "formatonotas.pdf" 
	var finalfile = basedir + "/generado/" + nombre + ".pdf"  
	
	
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
