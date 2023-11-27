extends Control

var loadingvalue = 0;
var textActivity = ""

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
	await $HTTPRequest.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/App/Json/GDD.json") #paso2


func _on_http_request_request_completed(result, response_code, headers, body):
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
		$InternetStatus.setInternetIcon(true)
	else:
		print("No hay internetus")
		textActivity = "cargada localmente"
		Global.online = false
		$InternetStatus.setInternetIcon(false)
		
	print("JSON:")
	print(Global.JsonGDD)
	
	loadingvalue = 10
	await checkFilesystem()


func checkFilesystem():
	textActivity = "chequear sistema de archivos..."
	print(textActivity)
	#print(Global.JsonGDD.Niveles)
	
	var dir = DirAccess.open(Global.basedir)
	
	if dir.dir_exists(Global.JsonGDD.folders.documentos):
		print("existe folder de documentos")
		
		dir = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos)
		
		var niveles = Global.JsonGDD.Niveles
		print("iterar niveles")
		for nivel in niveles:
			print(nivel)
			if dir.dir_exists(nivel.sigla):
				pass
			else:
				dir.make_dir(nivel.sigla)
			iiteratenivel(nivel.sigla,nivel.tomos)
	else:
		dir.make_dir(Global.JsonGDD.folders.documentos)


func iiteratenivel(sigla,tomos):
	var dir = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos + "/" + sigla )
	for tomo in tomos:
		if dir.dir_exists(tomo.sigla):
			pass
		else:
			dir.make_dir(tomo.sigla)
			
		var dir2 = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos + "/" + sigla + "/" + tomo.sigla )

