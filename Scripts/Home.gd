extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#await $HTTPRequest.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/App/Json/sumoprimero.json") #obtener online
	obtainoffline()
	
	print("JSON:")
	print(Global.JsonGDD)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Escenas/ListaGDD.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Escenas/ListaGDD.tscn")


func _on_http_request_request_completed(result, response_code, headers, body):
	var prejson = body.get_string_from_utf8()
	var obtainedjson = JSON.parse_string(prejson)
	
	Global.online = false
	
	print("Obtener Json:")
	#print(obtainedjson)
	if str(obtainedjson) != "<null>":
		#print("listo web")
		Global.online = true
		Global.JsonGDD = obtainedjson
		$InternetStatus.setInternetIcon(true)
	else:
		print("No hay internetus")
		Global.online = false
		$InternetStatus.setInternetIcon(false)
		obtainoffline()
				
	print("JSON:")
	print(Global.JsonGDD)


func obtainoffline():
	#print(Global.basedir)
	var dir = DirAccess.open(Global.basedir +"/config")
	#print(dir)
	if dir.file_exists( "GDD.json" ):
		print("existe el json")
		var config = FileAccess.get_file_as_string( dir.get_current_dir() + "/GDD.json")
		if not config.is_empty():
			Global.JsonGDD = JSON.parse_string(config)
