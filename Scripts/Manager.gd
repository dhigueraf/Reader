extends Control

@onready var listoffolders = []
@onready var listoffiles = []
@export var discartednames= [".",".."]
@export var formatsallowed = ["doc","docx","ppt","pptx","xls","xls","odt","pdf","webm","mp4","mkv","png","jpg","jpeg"]

var history = []
var basedir =""
var configdir = ""
var converterdir = ""
var currentdir = ""
var previusdir = ""
var filetoopen = ""
var nombreinteract = "interactivos"

var localversion = 0
var onlineversion = 0

var btncurso = preload("res://Objetos/BtnCurso.tscn")

func getlocalconfig():
	var defaultjsonlocation = "res://json/sumoprimero.json"
	var json_as_text = FileAccess.get_file_as_string(defaultjsonlocation)
	#print(json_as_text)
	return json_as_text

func findlocalconfig():
	var json_path = configdir + "/config.json"
	print(json_path)
	var dir = DirAccess.open(basedir)
	if not dir.dir_exists("/config") :
		dir.make_dir("config")
	if not FileAccess.file_exists(json_path):
		print("No existe")
		var jsonpdf = FileAccess.open(json_path, FileAccess.WRITE)
		jsonpdf.store_line( getlocalconfig() )
		jsonpdf.close()
		Global.softwareinfo = JSON.parse_string( getlocalconfig() )
	else:
		var jsonpdf = FileAccess.get_file_as_string(json_path)
		if not jsonpdf.is_empty():
			Global.softwareinfo =  JSON.parse_string(jsonpdf)
		else: 
			print("Esta vacio")
			jsonpdf = FileAccess.open(json_path, FileAccess.WRITE)
			jsonpdf.store_line( getlocalconfig() )
			jsonpdf.close()
			Global.softwareinfo = JSON.parse_string( getlocalconfig() )
			
		print("Save data")
		print(Global.softwareinfo)
		
		localversion = Global.softwareinfo.version
		

func _on_request_config_request_completed(result, response_code, headers, body):
	var prejson = body.get_string_from_utf8()
	var obtainedjson = JSON.parse_string(prejson)
	
	print("Obtener Json:")
	#print(obtainedjson)
	if str(obtainedjson) != "<null>":
		onlineversion = obtainedjson["version"]
		print("listo web")
	else:
		print("No hay internetus")

func setinitialvariables():
	var path = OS.get_executable_path()
	basedir = path.get_base_dir()
	converterdir = basedir + "/converter"
	configdir = basedir + "/config"
	currentdir = basedir
	previusdir = basedir

func _ready():
	var path = OS.get_executable_path()
	basedir = path.get_base_dir()
	converterdir = basedir + "/converter"
	configdir = basedir + "/config"
	currentdir = basedir
	previusdir = basedir
	
	$ProcessLabel.text = "Verificar versión online"
	
	await $RequestConfig.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/Json/sumoprimero.json")
	$ProcessLabel.text = "Cargar configucarión local"
	await findlocalconfig()

	print("software info:")
	print(Global.softwareinfo)
	$ProcessLabel.text = "Verificar sistema de archivos"
	await checkfilesystem()
	#await generateButtons()
	$ProcessLabel.text = "Activar botones"
	await activatebuttons()
	print("pantalla lista")
	$ProcessLabel.text = "Listo"


func checkfilesystem():
	print("primera carpeta " + str(Global.softwareinfo.carpetabase) + ".")
	var primeracarpeta = str(Global.softwareinfo.carpetabase)
	var dir = DirAccess.open(basedir)
	if dir.dir_exists(primeracarpeta) :
		print("directorio existe")
		
	else:
		print("directorio no existe")
		dir.make_dir(primeracarpeta)
		print("primera iteración")
	await iteratefoldersandfiles(basedir + "/" + primeracarpeta,Global.softwareinfo.sistemarchivos)
	
	generateButtons()
	print("done filessytem")

func iteratefoldersandfiles(folder,filesystem):
	print("iterar: "  + str(folder))
	var dir = DirAccess.open(folder)
	for elemento in filesystem:
			#print(elemento)
			if "tipo" in elemento:
				if elemento.tipo == "carpeta":
					print("Es una carpeta")
					
					var nombrecarpeta = elemento.nombre.carpeta
					
					if dir.dir_exists(nombrecarpeta) :
						print("directorio existe")
					else:
						print("directorio no existe")
						dir.make_dir(nombrecarpeta)
					if "subelementos" in elemento:
						var subfolder = elemento["subelementos"]
						iteratefoldersandfiles(folder + "/" + nombrecarpeta,subfolder)
				elif elemento.tipo == "archivo":
					print("Es un archivo")
					if dir.file_exists(folder + "/" + elemento.nombre.carpeta + "." + elemento.extension):
						print("archivo existe")
					else:
						print("descargarlo")
						print(elemento.url)
					$Downloader.set_download_file(folder + "/" + elemento.nombre.carpeta + "." + elemento.extension)
					print("descargando")
					$DownloadLabel.text = "Descargando... " + elemento.nombre.carpeta + "." + elemento.extension
					await $Downloader.request(elemento.url)
					print("se ha descargado descargado " + elemento.nombre.carpeta + "." + elemento.extension)
				
					#iteratefoldersandfiles()
	

func generateButtons():
	var dir = DirAccess.open(basedir)
	for key in Global.softwareinfo.sistemarchivos:
			print(key)
			if "nombre" in key:
				print(key.nombre)
				var btndir = btncurso.instantiate()
				btndir.text = str(key.nombre.boton)
				btndir.disabled = true
				
				var selcur = {
					"nombre" : key.nombre,
					"location": basedir + key.nombre.carpeta,
					"archivos" : key.subelementos
 				}
				
				btndir.connect("pressed", Callable(self, "openCurso").bind(selcur))
				$VBoxContainer.add_child(btndir)

func activatebuttons():
	var buttons = []
	buttons = $VBoxContainer.get_children()
	
	for btn in buttons:
		btn.disabled = false


func clickbutton():
	print("click")

func openCurso(curso):
	print("presionaste: " + curso.nombre.boton)
	Global.SelectedCurso = curso
	get_tree().change_scene_to_file("res://Escenas/Curso.tscn")

func _on_downloader_request_completed(result, response_code, headers, body):
	print("download result:")
	print(result)
