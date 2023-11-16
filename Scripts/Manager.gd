extends Control

@onready var listoffolders = []
@onready var listoffiles = []
@export var discartednames= [".",".."]
@export var formatsallowed = ["doc","docx","ppt","pptx","xls","xls","odt","pdf","webm","mp4","mkv","png","jpg","jpeg"]

signal updatebutton

var history = [] #Historial de accionesaunq
var configdir = ""
var converterdir = ""
var currentdir = ""
var previusdir = ""
var filetoopen = ""
var nombreinteract = "interactivos"
var otherfolders = ["assets","generated"]
var online = false
var inicio = true

var localversion = 0
var onlineversion = 0

var btncurso = preload("res://Objetos/BtnCurso.tscn")

var downloads = []
var updates = []
var updatelist = []
var downloadingfile = ""
var downloadindex = 0
var numcambios = 0

var sistemasoperativos = ["windows","linux"]

var buttonsready = false
var botones = []

func _ready(): #Inicio del programa
	var path = OS.get_executable_path() #Ubicación del programa ejecutandose, si mismo (idelamente dentro del pendrive)
	Global.basedir = path.get_base_dir() #Carpeta base 
	converterdir = Global.basedir + "/converter" #Ubicacioṕn de los conversores de archivos
	configdir = Global.basedir + "/config" #Ubicacion del archivo de configuración
	currentdir = Global.basedir
	previusdir = Global.basedir
	
	print("Inicio")
	
	$ProcessLabel.text = "Verificar versión online"
	
	#Obtener Json de la versión mas reciente 
	#LLamado a la descarga (buscar "resulatado llamado descarga")
	await $RequestConfig.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/App/Json/sumoprimero.json")#paso1


func verificareiniciar(): #Iniciar tras tener json (ya sea online o offline)
	print("software info:")
	print(Global.softwareinfo)
	$ProcessLabel.text = "Verificar sistema de archivos"
	await checkfilesystem() #paso3

	if downloads.size() > 0: #paso7
		print(downloads)
		doDownload(downloadindex) 
	else:
		$ProcessLabel.text = "Activar botones"
		await activatebuttons() #paso8
	print("pantalla lista")
	$ProcessLabel.text = "Listo"
	#print(listoffiles)
	#print(updates)
	print(botones)


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
		print("configuración local finalizada")
		verificareiniciar() #paso2 llamar si no hay ineternet

#resulatado llamado descarga
func _on_request_config_request_completed(result, response_code, headers, body):
	var prejson = body.get_string_from_utf8()
	var obtainedjson = JSON.parse_string(prejson)
	
	online = false
	
	print("Obtener Json:")
	#print(obtainedjson)
	if str(obtainedjson) != "<null>":
		onlineversion = obtainedjson["version"]
		#print("listo web")
		online = true
		#print( "Versión web " + str(onlineversion) )
		
		Global.softwareOnline = obtainedjson
		Global.softwareinfo = obtainedjson
		#print(Global.softwareOnline)
	else:
		print("No hay internetus")
		online = false
		
		var dir = DirAccess.open(Global.basedir +"/config")
		print(dir)
		if dir.file_exists( "config.json" ):
			print("existe el json")
			var config = FileAccess.get_file_as_string( dir.get_current_dir() + "/config.json")
			if not config.is_empty():
				Global.softwareinfo = JSON.parse_string(config)
				
	#print("software info:")
	#print(Global.softwareinfo)
	#Global.softwareOnline = obtainedjson
	$InternetStatus.setInternetIcon(online)
		
		
	if inicio: 
		inicio = false
		#print("Inicio")
		if online == false:
			$ProcessLabel.text = "Cargar configucarión local"
			await findlocalconfig() #paso1b
		else: 
			await verificareiniciar() #paso2 llamado si hay internet
		$CheckOnline.start()
	else:
		$CheckOnline.start()


func setinitialvariables():
	var path = OS.get_executable_path()
	Global.basedir = path.get_base_dir()
	converterdir = Global.basedir + "/converter"
	configdir = Global.basedir + "/config"
	currentdir = Global.basedir
	previusdir = Global.basedir


func checkfilesystem(): #Chequear sistema de archivos desde el json al del PC
	print("primera carpeta " + str(Global.softwareinfo.carpetabase) + ".")
	var primeracarpeta = str(Global.softwareinfo.carpetabase) #nombre de la carpeta base
	var dir = DirAccess.open(Global.basedir) #ubicacion del ejecutable
	if dir.dir_exists(primeracarpeta) : #Checkeo si existe la carpeta base
		print("directorio existe")
	else: #No existe la creo
		print("directorio no existe")
		dir.make_dir(primeracarpeta)
		print("primera iteración")
	#Ahora que existe la carpeta  recorro el sistema de archivos 
	#Se le envia el nombre de la carpeta y la estructura de capetas como diccionario
	await iteratefoldercursos(primeracarpeta,Global.softwareinfo.sistemarchivos)#paso4
	#Generar botones de cursos
	generateButtons()
	print("done filessytem")
	await checkAssets() #paso5

func iteratefoldercursos(folder,filesystem): #Recorrer sistema de archivos comparando con el json
	print("Iterar folder " + folder)
	var dir = DirAccess.open(Global.basedir + "/" + folder) #Abrir carpeta solicicitada
	var iterator = 0
	for elemento in filesystem: #recorrer elemetos dentro del directorio
		print("elemento " + str(iterator) + " " + str(elemento.nombre.carpeta)) 
		if "tipo" in elemento:
			if elemento.tipo == "carpeta": #el elemento es una carpeta
				var boton = {
					"nombre": elemento.nombre.boton,
					"updates": false,
					"location": dir.get_current_dir() + "/"+ elemento.nombre.carpeta,
					"sublocation": elemento.nombre.carpeta,
					"folder": elemento.nombre.carpeta,
					"archivos": []
				}
				
				print("buscar carpeta "+ elemento.nombre.carpeta)
				if dir.dir_exists(elemento.nombre.carpeta) : #Verifico que existe la carpeta
					print("directorio existe")
					print(dir.get_current_dir() + "/" + elemento.nombre.carpeta)
				else: #No, existe la creo
					print("directorio no existe")
					dir.make_dir(elemento.nombre.carpeta)
					print("creada carpeta " + str(elemento.nombre.carpeta))
				
				#Ahora que existe la carpeta  recorro el sistema de archivos 
				#Se le envia el nombre de la carpeta y la estructura de capetas como diccionario
				var elementoarchivos = iteratesubfolders( folder + "/" + elemento.nombre.carpeta , elemento.subelementos ) #recorrer subcarpeta
				boton.archivos = elementoarchivos #

				botones.append(boton)


func iteratesubfolders(folder,filesystem): #Recorrer carpetas comparando con el json
	print("Iterar sub folder " + folder)
	print(Global.basedir + "/" + folder) 
	var iterator 
	var archivos = []
	var dir = DirAccess.open(Global.basedir + "/" + folder) #Abrir carpeta solicicitada
	print(dir)
	for elemento in filesystem: #recorrer elemetos dentro del directorio
		if "tipo" in elemento:
			if elemento.tipo == "carpeta":
				#es una carpeta, si no exite la creo, 
				if dir.dir_exists(elemento.nombre.carpeta) :
					print("directorio existe")
				else:
					print("directorio no existe")
					dir.make_dir(elemento.nombre.carpeta)
				#Recorro la carpeta
				var subarchivos = iteratesubfolders( folder + "/" + elemento.nombre.carpeta , elemento.subelementos )
				archivos += subarchivos
			elif elemento.tipo == "archivo":
				#Es un archivo
				var archivo ={
					"nombre" : elemento.nombre.boton,
					"existe" : false,
					"versionweb" : elemento.version,
					"versionlocal" : -1,
					"accion": "OK",
					"url": elemento.url,
					"filename": elemento.nombre.carpeta,
					"folder": dir.get_current_dir() + "/",
					"location": dir.get_current_dir() + "/" + elemento.nombre.carpeta + "." + elemento.extension,
					"sublocation": folder + "/" + elemento.nombre.carpeta + "." + elemento.extension,
					"capitulos": {}
				}
				
				if "capitulos" in elemento:
					archivo.capitulos = elemento.capitulos
				
				if dir.file_exists( elemento.nombre.carpeta+"."+elemento.extension ):#Verificar si el archivo existe
					print("archivo existe")
					archivo.existe = true
					if dir.file_exists(elemento.nombre.carpeta+"_info.json"): #Si existe deberia tener un archivo de información
						print("info existe")
						#la infromación existe, obetenerla como diccionario
						var fileinfo = FileAccess.get_file_as_string( dir.get_current_dir() + "/" + elemento.nombre.carpeta + "_info" + ".json" )
						print("File info: " + fileinfo)
						if not fileinfo.is_empty(): #No esta vacio, obtener la versión
							var jsoninfo = JSON.parse_string(fileinfo)
							if "version" in jsoninfo:
								archivo.versionlocal = jsoninfo.version
						if archivo.versionweb > archivo.versionlocal: #La información esta vacia se asume que hay que actualizar
							archivo.accion = "actualizar"
				else:
					if not dir.file_exists(elemento.nombre.carpeta+"_info.json"): #El archivo no existe hay que descargarlo
						print("")
					archivo.accion = "descargar"
				archivos.append(archivo)
	return archivos


func checkAssets(): #Busqueda De Assets
	print("chequear segundo filesystm")
	var dir = DirAccess.open(Global.basedir)
	var assetsdir = str(Global.softwareinfo.assets.carpeta)
	
	if dir.dir_exists( assetsdir ):
		print("verificar carpeta de assets")
		for asset in Global.softwareinfo.assets.archivos:
			var assetinfojson = { "version":0 }
			if not dir.file_exists( assetsdir + "/" + asset.nombre + "." + asset.extension):
				var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" +  assetsdir + "/" + asset.nombre + "_info" + ".json", FileAccess.WRITE )
				jsonpdf.store_line( '{ "version": 0 }' ) #'{ "version": 0 }'
				jsonpdf.close()
				
				var download = {
					"name" :  asset.nombre,
					"location" : Global.basedir + "/" + Global.softwareinfo.assets.carpeta + "/" + asset.nombre + "." + asset.extension,
					"sublocation": Global.softwareinfo.assets.carpeta + "/" + asset.nombre + "." + asset.extension,
					"url" : asset.url,
					"place": "assets/",
					"onlineversion": asset.version,
					"localversion":0,
				}
				downloads.append(download)
			else:
				print("existe el asset actual")
				if dir.file_exists( assetsdir + "/" + asset.nombre + "_info" + ".json" ):
					print("existe el json")
					var fileinfo = FileAccess.get_file_as_string( dir.get_current_dir() + "/" +  assetsdir + "/" + asset.nombre + "_info" + ".json")
					if not fileinfo.is_empty():
						assetinfojson = JSON.parse_string(fileinfo)
				else:
					var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" +  assetsdir + "/" + asset.nombre + "_info" + ".json", FileAccess.WRITE )
					jsonpdf.store_line( '{ "version": 0 }' ) #'{ "version": 0 }'
					jsonpdf.close()
					
				print("Comparar versiones")
				print(asset.version)
				print(assetinfojson.version)
				if assetinfojson.version < asset.version : #Actualizar asset
					print("actualizar "  + asset.nombre )
					var udpate = {
						"name" :  asset.nombre,
						"location" : Global.basedir + "/" + Global.softwareinfo.assets.carpeta + "/" + asset.nombre + "." + asset.extension,
						"sublocation": Global.softwareinfo.assets.carpeta + "/" + asset.nombre + "." + asset.extension,
						"url" : asset.url,
						"place": "assets/",
						"onlineversion": asset.version,
						"localversion": assetinfojson.version,
						"aviable": true,
					}
					
					downloads.append(udpate)
	else:
		print("crear la carpeta de assets")
		dir.make_dir(assetsdir)
		for asset in Global.softwareinfo.assets.archivos:
			var download = {
				"name" :  asset.nombre,
				"location" : Global.basedir + "/" + Global.softwareinfo.assets.carpeta + "/" + asset.nombre,
				"sublocation" : Global.softwareinfo.assets.carpeta + "/" + asset.nombre,
				"url" : asset.url,
				"place": "assets/",
				"onlineversion": 0,
				"localversion":0
			}
			downloads.append(download)
			var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" +  assetsdir + "/" + asset.nombre + "_info" + ".json", FileAccess.WRITE )
			jsonpdf.store_line( '{ "version": 0 }' ) #'{ "version": 0 }'
			jsonpdf.close()
		
	if not dir.dir_exists( Global.softwareinfo.carpetagenerados ):
		#print("no existe crearla")
		dir.make_dir(Global.softwareinfo.carpetagenerados)
		
	$ProcessLabel.text = "Verificar conversores"
	await checkDonwnloadConverter()#paso6


func checkDonwnloadConverter():
	print("chequear converter")
	var dir = DirAccess.open(Global.basedir)
	converterdir = str(Global.softwareinfo.converter.carpeta)
	var sistemasop
	if dir.dir_exists( converterdir ):
		print("existe la carpeta")
		for ejecutable in Global.softwareinfo.converter.ejecutables:
			for OpSi in sistemasoperativos:
				var converterinfojson = {"version":0}
				if not dir.file_exists(converterdir + "/" +  ejecutable.versiones[OpSi].nombre):
					var ejecutosi = ejecutable.versiones[OpSi]
					var download = {
						"name" :  ejecutosi.nombre,
						"location" : Global.basedir + "/" + str( Global.softwareinfo.converter.carpeta ) + "/" + ejecutosi.nombre,
						"sublocation" : str( Global.softwareinfo.converter.carpeta ) + "/" + ejecutosi.nombre,
						"url" : ejecutosi.url,
						"place": "assets/",
						"onlineversion": ejecutable.versiones[OpSi].version,
						"localversion":0
					}
					
					if dir.file_exists( converterdir + "/" + ejecutable.versiones[OpSi].nombre + "_info" + ".json" ):
						print("existe el json")
						var converterinfo = FileAccess.get_file_as_string( dir.get_current_dir() + "/" +  converterdir + "/" + ejecutable.versiones[OpSi].nombre + "_info" + ".json")
						if not converterinfo.is_empty():
							converterinfojson = JSON.parse_string(converterinfo)
					else:
						var jsonconverterinfo = FileAccess.open( dir.get_current_dir() + "/" +  converterdir + "/" + ejecutable.versiones[OpSi].nombre + "_info" + ".json", FileAccess.WRITE )
						jsonconverterinfo.store_line( '{ "version": 0 }' ) #'{ "version": 0 }'
						jsonconverterinfo.close()
					
					downloads.append(download)
				else:
					if dir.file_exists( converterdir + "/" + ejecutable.versiones[OpSi].nombre + "_info" + ".json" ):
						print("existe el json")
						var converterinfo = FileAccess.get_file_as_string( dir.get_current_dir() + "/" +  converterdir + "/" + ejecutable.versiones[OpSi].nombre + "_info" + ".json")
						if not converterinfo.is_empty():
							converterinfojson = JSON.parse_string(converterinfo)
					else:
						var jsonconverterinfo = FileAccess.open( dir.get_current_dir() + "/" +  converterdir + "/" + ejecutable.versiones[OpSi].nombre + "_info" + ".json", FileAccess.WRITE )
						jsonconverterinfo.store_line( '{ "version": 0 }' ) #'{ "version": 0 }'
						jsonconverterinfo.close()
						
					if converterinfojson.version < ejecutable.versiones[OpSi].version:
						var ejecutosi = ejecutable.versiones[OpSi]
						var update = {
							"name" :  ejecutosi.nombre,
							"location" : Global.basedir + "/" + str( Global.softwareinfo.converter.carpeta ) + "/" + ejecutosi.nombre,
							"sublocation" : str( Global.softwareinfo.converter.carpeta ) + "/" + ejecutosi.nombre,
							"url" : ejecutosi.url,
							"place": "assets/",
							"onlineversion": ejecutable.versiones[OpSi].version,
							"localversion": converterinfojson.version
						}
						
						updates.append(update)
	else:
		print("no existe crearla")
		dir.make_dir(converterdir)
		
		for ejecutable in Global.softwareinfo.converter.ejecutables:
			for OpSi in sistemasoperativos:
				var ejecutosi = ejecutable.versiones[OpSi]
				var download = {
					"name" :  ejecutosi.nombre,
					"location" : Global.basedir + "/" + str( Global.softwareinfo.converter.carpeta ) + "/" + ejecutosi.nombre,
					"sublocation" : str( Global.softwareinfo.converter.carpeta ) + "/" + ejecutosi.nombre,
					"url" : ejecutosi.url,
					"place": "assets/"
				}
				
				downloads.append(download)


func generateButtons():
	print("----------------------Crear botones----------------------")
	var dir = DirAccess.open(Global.basedir)
	for key in botones:
			#print(key)
			if "nombre" in key:
				#print(key.nombre)
				var btndir = btncurso.instantiate()
				btndir.text = str(key.nombre)
				btndir.disabled = true
				
				var selcur = {
					"nombre" : key.nombre,
					"location": key.location,
					"sublocation": key.sublocation,
					"folder":  key.folder,
					"archivos" : key.archivos,
					"actualizar": checkupdates(key.archivos)
 				}
				#print(selcur)
				
				#btndir.setVersion(5)
				
				if selcur.actualizar:
					print("activar botón")
					btndir.curso = selcur
					btndir.managerbutton = updatebutton
					#btndir.acivardetalles()
					btndir.activateUButton(false)
				
				btndir.connect( "pressed", Callable(self, "openCurso").bind(selcur) )
				$VBoxContainer.add_child(btndir)


func checkupdates(archivos):
	print("Check updates")
	for ar in archivos:
		if ar.accion != "OK":
			print("hay que actualizar")
			return true
	return false


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
	print("presionaste: " + curso.nombre)
	#print(curso)
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
		
		var namearray = download.location.split(".")
		var jsoninfo = FileAccess.open( namearray[0] + "_info" + ".json", FileAccess.WRITE )
		print(namearray[0])
		var dicinfo = {
			"version" : download.onlineversion,
			"location": download.location,
			"sublocation": download.sublocation,
			"url" : download.url,
			"nombre": download.name
		}
		
		if "capitulos" in download:
			dicinfo["capitulos"] = download.capitulos
		
		jsoninfo.store_line( str(dicinfo) )
		jsoninfo.close()
	else:
		if not buttonsready:
			print("Ya no hay mas descargas")
			downloads = []
			buttonsready = true
			await activatebuttons() #paso8


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


func _on_check_online_timeout():
	print("Verificar conexión")
	$RequestConfig.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/App/Json/sumoprimero.json")


func _on_updatebutton(curso):
	print("update pressed")
	#print(curso)
	downloadindex = 0
	for updt in curso.archivos:
		print(updt)
		var download = {
			"name" :  updt.filename,
			"location" : updt.location,
			"sublocation": updt.sublocation,
			"url" : updt.url,
			"place": updt.folder,
			"onlineversion": updt.versionweb,
		}
		
		if "capitulos" in updt:
			download["capitulos"] = updt.capitulos
		
		if updt.accion == "actualizar":
			downloads.append(download)
		elif updt.accion == "descargar":
			downloads.append(download)
	
	print("update list:")
	print(updatelist)
	print("download list:")
	print(downloads)
	
	doDownload(downloadindex)
