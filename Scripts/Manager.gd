extends Control

@onready var listoffolders = []
@onready var listoffiles = []
@export var discartednames= [".",".."]
@export var formatsallowed = ["doc","docx","ppt","pptx","xls","xls","odt","pdf","webm","mp4","mkv","png","jpg","jpeg"]

var history = []
var configdir = ""
var converterdir = ""
var currentdir = ""
var previusdir = ""
var filetoopen = ""
var nombreinteract = "interactivos"
var otherfolders = ["assets","generated"]

var localversion = 0
var onlineversion = 0

var btncurso = preload("res://Objetos/BtnCurso.tscn")

var downloads = []
var downloadingfile = ""
var downloadindex = 0
var numcambios = 0

func getlocalconfig():
	var defaultjsonlocation = "res://json/sumoprimero.json"
	var json_as_text = FileAccess.get_file_as_string(defaultjsonlocation)
	#print(json_as_text)
	return json_as_text

func savejson():
	print("Guardar")
	var json_path = configdir + "/config.json"
	var jsonpdf = FileAccess.open(json_path, FileAccess.WRITE)
	jsonpdf.store_line( str(Global.softwareinfo) )
	jsonpdf.close()
	Global.softwareinfo = JSON.parse_string( getlocalconfig() )

func findlocalconfig():
	var json_path = configdir + "/config.json"
	print(json_path)
	var dir = DirAccess.open(Global.basedir)
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
	Global.basedir = path.get_base_dir()
	converterdir = Global.basedir + "/converter"
	configdir = Global.basedir + "/config"
	currentdir = Global.basedir
	previusdir = Global.basedir

func _ready():
	var path = OS.get_executable_path()
	Global.basedir = path.get_base_dir()
	converterdir = Global.basedir + "/converter"
	configdir = Global.basedir + "/config"
	currentdir = Global.basedir
	previusdir = Global.basedir
	
	$ProcessLabel.text = "Verificar versión online"
	
	await $RequestConfig.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/App/Json/sumoprimero.json")
	$ProcessLabel.text = "Cargar configucarión local"
	await findlocalconfig()

	print("software info:")
	print(Global.softwareinfo)
	$ProcessLabel.text = "Verificar sistema de archivos"
	await checkfilesystem()
	await checkOtherFolders()
	$ProcessLabel.text = "Verificar conversores"
	await checkDonwnloadConverter()
	#await generateButtons()
	#print("Hacer las descargas")
	#print( downloads.size() )
	if downloads.size() > 0:
		print(downloads)
		doDownload(downloadindex)
	else:
		$ProcessLabel.text = "Activar botones"
		await activatebuttons()
	print("pantalla lista")
	$ProcessLabel.text = "Listo"


func checkfilesystem():
	print("primera carpeta " + str(Global.softwareinfo.carpetabase) + ".")
	var primeracarpeta = str(Global.softwareinfo.carpetabase)
	var dir = DirAccess.open(Global.basedir)
	if dir.dir_exists(primeracarpeta) :
		print("directorio existe")
	else:
		print("directorio no existe")
		dir.make_dir(primeracarpeta)
		print("primera iteración")
	await iteratefoldersandfiles(primeracarpeta,Global.softwareinfo.sistemarchivos, [] )
	
	generateButtons()
	print("done filessytem")

func iteratefoldersandfiles(folder,filesystem, road):
	print("iterar: "  + str(folder))
	var dir = DirAccess.open(Global.basedir + "/" + folder)
	var recorrido = road
	print("mi recorrido hasta ahora")
	print(recorrido)
	recorrido.append(0)
	var iterator = 0
	for elemento in filesystem:
		#print(elemento)
		print("elemento " +str(iterator) + " " + str(elemento.nombre.carpeta)) 
		recorrido[-1] = iterator
		print(recorrido)
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
					print("llamar iterador de archivos")
					var newrecorrido = recorrido
					print(newrecorrido)
					iteratefoldersandfiles(folder + "/" + nombrecarpeta,subfolder,newrecorrido)
					recorrido = [0,iterator]
			elif elemento.tipo == "archivo":
				print("Es un archivo")
				if dir.file_exists(elemento.nombre.carpeta + "." + elemento.extension):
					print("archivo existe")
				else:
					print("descargarlo")
					print(elemento.url)
					var download = {
					"name" : elemento.nombre.carpeta + "." + elemento.extension,
					"location" : Global.basedir + "/" +folder + "/" + elemento.nombre.carpeta + "." + elemento.extension,
					"url" : elemento.url,
					"place": recorrido
					}
					
					downloads.append(download)
					
				print("comparar locaciones")
				print( str( folder + "/"  + elemento.nombre.carpeta + "." + elemento.extension) )
				print( str( elemento.location ) )
				if str(elemento.location) != str(folder + "/" + elemento.nombre.carpeta + "." + elemento.extension):
					updatelocation(folder + "/" + elemento.nombre.carpeta + "." + elemento.extension,recorrido)
		iterator+= 1
	print("sali del for" )
	
	


func generateButtons():
	var dir = DirAccess.open(Global.basedir)
	for key in Global.softwareinfo.sistemarchivos:
			print(key)
			if "nombre" in key:
				print(key.nombre)
				var btndir = btncurso.instantiate()
				btndir.text = str(key.nombre.boton)
				btndir.disabled = true
				
				var selcur = {
					"nombre" : key.nombre,
					"location": Global.basedir + key.nombre.carpeta,
					"folder":  key.nombre.carpeta,
					"archivos" : key.subelementos
 				}
				
				btndir.connect("pressed", Callable(self, "openCurso").bind(selcur))
				$VBoxContainer.add_child(btndir)

func activatebuttons():
	var buttons = []
	buttons = $VBoxContainer.get_children()
	if numcambios > 0:
		savejson()
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
	print("ahora descargar " + str(downloadindex))
	downloadindex += 1
	await doDownload(downloadindex)
	
func doDownload(index):
	print("Hacer las descargas")
	if index < downloads.size():
		var download = downloads[index]
		downloadingfile = download.name
		print(download)
		$Downloader.set_download_file(download.location)
		print("descargando")
		$DownloadLabel.text = "Descargando... " + download.name
		await $Downloader.request(download.url)
		print("se ha descargado descargado " + download.name)
	else:
		print("Ya no hay mas descargas")
		await activatebuttons()

func checkDonwnloadConverter():
	print("chequear converter")
	var dir = DirAccess.open(Global.basedir)
	converterdir = str(Global.softwareinfo.converter.carpeta)
	if dir.dir_exists( converterdir ):
		print("existe la carpeta")
		if not dir.file_exists(converterdir + "/" +  Global.softwareinfo.converter.versiones.windows.nombre):
			var download = {
				"name" : "pdf2pngimgs.exe",
				"location" : Global.basedir + "/" + Global.softwareinfo.converter.carpeta + "/" + Global.softwareinfo.converter.versiones.windows.nombre,
				"url" : Global.softwareinfo.converter.versiones.windows.url,
				"place": "converter/"
			}
			downloads.append(download)
		else:
			print("existe converter para windows")
			
		if not dir.file_exists(converterdir + "/" +  Global.softwareinfo.converter.versiones.linux.nombre):
			var download = {
				"name" : "pdf2pngimgs",
				"location" : Global.basedir + "/" + Global.softwareinfo.converter.carpeta + "/" + Global.softwareinfo.converter.versiones.linux.nombre,
				"url" : Global.softwareinfo.converter.versiones.linux.url,
				"place": "converter/"
			}
			downloads.append(download)
		else:
			print("existe converter para linux")
	else:
		print("no existe crearla")
		dir.make_dir(converterdir)
		
		var download1= {
			"name" : "pdf2pngimgs.exe",
			"location" : Global.basedir + "/" + Global.softwareinfo.converter.carpeta + "/" + Global.softwareinfo.converter.versiones.windows.nombre,
			"url" : Global.softwareinfo.converter.versiones.windows.url,
			"place": "converter/"
		}
		var download2 = {
			"name" : "pdf2pngimgs",
			"location" : Global.basedir + "/" + Global.softwareinfo.converter.carpeta + "/" + Global.softwareinfo.converter.versiones.linux.nombre,
			"url" : Global.softwareinfo.converter.versiones.linux.url,
			"place": "converter/"
		}
		downloads.append(download1)
		downloads.append(download2)
		
func _process(delta):
	if $Downloader.get_body_size() > 0:
		var arr = float($Downloader.get_downloaded_bytes()/1024)
		var total = float($Downloader.get_body_size()/1024)
		$Avancelabel.text = downloadingfile + ": " + str(arr) + "/" + str(total) + "[Kb]"


func updatelocation(locationtoupdate,road):
	print("Update Location:")
	print(locationtoupdate)
	print(road)
	if road.size() == 3:
		numcambios += 1
		Global.softwareinfo.sistemarchivos[road[0]].subelementos[road[1]].subelementos[road[2]].location = locationtoupdate
		print( Global.softwareinfo.sistemarchivos[road[0]].subelementos[road[1]].subelementos[road[2]] )


func _on_downloader_2_request_completed(result, response_code, headers, body):
	print("download result:")
	print(result)
	

func checkOtherFolders():
	print("chequear segundo filesystm")
	var dir = DirAccess.open(Global.basedir)
	var assetsdir = str(Global.softwareinfo.assets.carpeta)
	
	if dir.dir_exists( assetsdir ):
		print("verificar carpeta de assets")
		for asset in Global.softwareinfo.assets.archivos:
			if not dir.file_exists( assetsdir + "/" + asset.nombre ):
				var download = {
					"name" : "pdf2pngimgs.exe",
					"location" : Global.basedir + "/" + Global.softwareinfo.assets.carpeta + "/" + asset.nombre,
					"url" : asset.url,
					"place": "assets/"
				}
				downloads.append(download)
			else:
				print("existe el asset actual")
	else:
		print("crear la carpeta de assets")
		dir.make_dir(assetsdir)
		for asset in Global.softwareinfo.assets.archivos:
			var download = {
				"name" : "pdf2pngimgs.exe",
				"location" : Global.basedir + "/" + str(Global.softwareinfo.assets.carpeta) + "/" + asset.nombre,
				"url" : asset.url,
				"place": "assets/"
			}
			downloads.append(download)
		
	if not dir.dir_exists( Global.softwareinfo.carpetagenerados ):
		#print("no existe crearla")
		dir.make_dir(Global.softwareinfo.carpetagenerados)
