extends Control

var loadingvalue = 0;
var textActivity = ""
var downloadlist = []
var downloadIndex = 0

var barradownload = 100

func _ready():
	
	print("request")
	textActivity = "descargar json"
	await CheckConfig() #paso1
	#get_tree().change_scene_to_file("res://Escenas/Home.tscn")


func _process(delta):
	$loadingbar.value = loadingvalue
	$activityDoing.text = textActivity


func CheckConfig():
	#print(Global.basedir)
	print("load offline")
	var dir = DirAccess.open(Global.basedir)
	
	if dir.dir_exists("config"): #Revisar si existe directorio de configuración
		dir = DirAccess.open(Global.basedir + "/config")
		if dir.file_exists( "GDD.json" ): #Revisar si existe json de GDD
			print("existe el json")
			var config = FileAccess.get_file_as_string( dir.get_current_dir() + "/GDD.json")
			print(str(config))
			if not config.is_empty() and '<null>' not in str(config): #Si no esta vacio lo ocupo
				print("no esta vacio")
				Global.JsonGDD = JSON.parse_string(config)
			else: #Si esta vacio lo lleno con el genercio y lo guardo
				print("esta vacio")
				var internaljson = preload("res://assets/GDD.json")
				var jsonpdf = FileAccess.open( dir.get_current_dir() + "/GDD.json", FileAccess.WRITE )
				jsonpdf.store_line( str(internaljson.data) ) 
				jsonpdf.close()
				print(internaljson)
				Global.JsonGDD = internaljson.data
		else:
			print("no existe")
			var internaljson = preload("res://assets/GDD.json")
			#print(internaljson)
			Global.JsonGDD = internaljson.data
			var jsonpdf = FileAccess.open( dir.get_current_dir() + "/GDD.json", FileAccess.WRITE )
			jsonpdf.store_line( str(internaljson.data) ) 
			jsonpdf.close()
	else:
		print("crear directorio")
		dir.make_dir("config")
		var internaljson = preload("res://assets/GDD.json")
		#print(internaljson)
		Global.JsonGDD = internaljson.data
		var jsonpdf = FileAccess.open( dir.get_current_dir() + "/config/GDD.json", FileAccess.WRITE )
		jsonpdf.store_line( str(internaljson.data) ) 
		jsonpdf.close()

	#Verificar el online
	loadingvalue = 5
	#ahora buscar version online
	await $JsonRequest.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/App/Json/GDD.json") #paso2


func _on_json_request_request_completed(result, response_code, headers, body):
	print("requested")
	var prejson = body.get_string_from_utf8()
	var obtainedjson = JSON.parse_string(prejson)
	
	Global.online = false
	
	print("Obtener Json:")
	print(obtainedjson)
	if str(obtainedjson) != "<null>":
		print("listo web")
		textActivity = "descargada web"
		Global.online = true
		Global.JsonGDD = obtainedjson
		loadingvalue = 10
		$InternetStatus.setInternetIcon(true)
		checkFilesystem()
	else:
		print("No hay internetus")
		textActivity = "cargada localmente"
		Global.online = false
		loadingvalue = 100
		$InternetStatus.setInternetIcon(false)
		$EndTime.start()
		
	#print("JSON:")
	#print(Global.JsonGDD)



func checkFilesystem():
	textActivity = "chequear sistema de archivos..."
	print(textActivity)
	#print(Global.JsonGDD.Niveles)
	
	var dir = DirAccess.open(Global.basedir)
	
	if dir.dir_exists(Global.JsonGDD.folders.documentos):
		print("existe folder de documentos")
	else:
		dir.make_dir(Global.JsonGDD.folders.documentos)
		
	dir = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos)
		
	var niveles = Global.JsonGDD.Niveles
	print("iterar niveles")
	for nivel in niveles:
		print(nivel)
		if dir.dir_exists(nivel.sigla):
			pass
		else:
			dir.make_dir(nivel.sigla)
			
		var infojson = {"version":0}
		if dir.file_exists( nivel.sigla + "/" + "_info.json" ):
			var infotext =  FileAccess.get_file_as_string( dir.get_current_dir() + "/" + nivel.sigla + "/" + "_info.json" )
			infojson =  JSON.parse_string(infotext)
			print(str(infojson))
			if not infojson.is_empty() and '<null>' not in str(infojson): #Si no esta vacio lo ocupo
				var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" + nivel.sigla + "/" + "_info.json", FileAccess.WRITE )
				jsonpdf.store_line( str(infojson) ) 
				jsonpdf.close()
		else:
			var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" + nivel.sigla + "/" + "_info.json", FileAccess.WRITE )
			jsonpdf.store_line( str(infojson) ) 
			jsonpdf.close()
			
		if infojson.version < nivel.version:
			print("local version: " + str(infojson.version) + " Web: " +  str(nivel.version))
			if "foto" in nivel:
				var download = {
					"nombre": nivel.sigla + "_portada" + ".png",
					"url" : nivel.foto,
					"location" :  dir.get_current_dir() + "/" + nivel.sigla + "/" + nivel.sigla + "_portada" + ".png"
				}
				downloadlist.append(download)
				
			for persoid in nivel.personajes_ids:
				var perso = Global.JsonGDD.Personaje[str(persoid)]
				print(perso)
				var downloadperso = {
					"nombre" : perso.nombre,
					"url" : perso.foto,
					"location" : dir.get_current_dir() + "/" + nivel.sigla + "/" + perso.nombre + ".png"
				}
				downloadlist.append(downloadperso)
				

			var mascota = Global.JsonGDD.Mascota[str(nivel.mascota_id)]
			print(mascota)
			var downloadmas = {
				"nombre" : mascota.nombre,
				"url" : mascota.foto,
				"location" : dir.get_current_dir() + "/" + nivel.sigla + "/" + mascota.nombre + ".png"
			}
			downloadlist.append(downloadmas)
			
			infojson.version = nivel.version
			var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" + nivel.sigla + "/" + "_info.json", FileAccess.WRITE )
			jsonpdf.store_line( str(infojson) ) 
			jsonpdf.close()
				
		await iiteratenivel(nivel.sigla,nivel.tomos)
		
	print("listo")
	print(downloadlist)
	startDownloadList()


func iiteratenivel(sigla,tomos):
	print("iterar nivel " + sigla )
	var dir = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos + "/" + sigla )
	for tomo in tomos:
		if dir.dir_exists(tomo.sigla):
			pass
		else:
			dir.make_dir(tomo.sigla)
			
		var infojson = {"version":0}
		if dir.file_exists( tomo.sigla + "/" + "_info.json" ):
			var infotext =  FileAccess.get_file_as_string( dir.get_current_dir() + "/" + tomo.sigla + "/" + "_info.json" )
			infojson =  JSON.parse_string(infotext)
			print(str(infojson))
			if not infojson.is_empty() and '<null>' not in str(infojson): #Si no esta vacio lo ocupo
				var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" + tomo.sigla + "/" + "_info.json", FileAccess.WRITE )
				jsonpdf.store_line( str(infojson) ) 
				jsonpdf.close()
		else:
			var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" + tomo.sigla + "/" + "_info.json", FileAccess.WRITE )
			jsonpdf.store_line( str(infojson) ) 
			jsonpdf.close()
		
		print("iterar unidades")
		
		if infojson.version < tomo.version:
			
			var dir2 = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos + "/" + sigla + "/" + tomo.sigla )
			for unidad in tomo.unidades:
				#Descargar GDD
				var downloadgdd = {
					"url" : unidad.url,
					"nombre": sigla + "-" + tomo.sigla + "-" + unidad.sigla + "." + unidad.extension,
					"location" : dir2.get_current_dir() + "/" + sigla + "-" + tomo.sigla + "-" + unidad.sigla + "." + unidad.extension
				}
				downloadlist.append(downloadgdd)
				
				for presentacion in unidad.presentaciones:
					var downloadppt = {
						"url" : presentacion.url,
						"nombre": sigla + "-" + tomo.sigla + "-" + presentacion.sigla + "." + presentacion.extension,
						"location" : dir2.get_current_dir() + "/" + sigla + "-" + tomo.sigla + "-" + presentacion.sigla + "." + presentacion.extension
					}
					downloadlist.append(downloadppt)
				for evaluacion in unidad.evaluaciones:
					var downloadeva = {
						"url" : evaluacion.url,
						"nombre": sigla + "-" + tomo.sigla + "-" + evaluacion.sigla + "." + evaluacion.extension,
						"location" : dir2.get_current_dir() + "/" + sigla + "-" + tomo.sigla + "-" + evaluacion.sigla + "." + evaluacion.extension
					}
					downloadlist.append(downloadeva)
			
			infojson.version = tomo.version
		var jsonpdf = FileAccess.open( dir.get_current_dir() + "/" + tomo.sigla + "/" + "_info.json", FileAccess.WRITE )
		jsonpdf.store_line( str(infojson) ) 
		jsonpdf.close()


func startDownloadList():
	textActivity = "Iniciando las descargas..."
	downloadIndex = 0
	loadingvalue = 20
	if downloadlist.size() > 0:
		barradownload = ( 100 - loadingvalue )/ downloadlist.size()
		
		var download = downloadlist[downloadIndex]
		
		$DownloadRequest.set_download_file(download.location)
		print("descargando")
		print(download)
		textActivity = "Descargando... " + download.nombre
		await $DownloadRequest.request(download.url)
	else:
		loadingvalue = 100
		$EndTime.start()

func doDownload(index):
	var download = downloadlist[index]
	
	$DownloadRequest.set_download_file(download.location)
	print("descargando")
	textActivity = "Descargando... " + download.nombre
	await $DownloadRequest.request(download.url)

func end():
	get_tree().change_scene_to_file("res://Escenas/Home.tscn")


func _on_download_request_request_completed(result, response_code, headers, body):
	print(result)
	if downloadIndex < downloadlist.size() -1:
		print("ahora descargar " + str(downloadIndex))
		downloadIndex += 1
		loadingvalue += barradownload
		doDownload(downloadIndex)
	else:
		loadingvalue = 100
		$EndTime.start()


func _on_end_time_timeout():
	end()
