extends Control

var nointernet = false
var llamadoelmodal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("Home JSON:")
	print(Global.JsonGDD)
	
	Global.SelectedCurso = {}
	Global.nivel = {}
	Global.anafolders = []
	
	$Button/Label.modulate =  Color("#627986")
	
	await $JsonRequest.request(Global.jsonUrl) #chequear internet


func _on_button_pressed():
	print("btn pressed")
	$Button/Label.modulate = Color("#ffffff")
	if Global.online:
		print("hacer request analitic GDD")
		Global.askanarenquest(Global.anaUrl +'/GDD"',[],'{}') #enviaranalitica
	get_tree().change_scene_to_file("res://Escenas/ListaGDD.tscn")


func _on_button_2_pressed():
	Global.selectedPestanaEditable="presentaciones"
	if Global.online:
		print("hacer request analitic btnpresentacione")
		Global.askanarenquest(Global.anaUrl +'/EDIT"',[],'{"btn":"pres"}') #enviaranalitica
	get_tree().change_scene_to_file("res://Escenas/Editables2.tscn")


func _on_button_3_pressed():
	Global.selectedPestanaEditable="evaluaciones"
	if Global.online:
		print("hacer request analitic btnpresentacione")
		Global.askanarenquest(Global.anaUrl +'/EDIT"',[],'{"btn":"eva"}') #enviaranalitica
	get_tree().change_scene_to_file("res://Escenas/Editables2.tscn")


func _on_button_mouse_entered():
	$Button/Label.modulate = Color("#ffffff")


func _on_button_mouse_exited():
	$Button/Label.modulate =  Color("#627986")


func _on_http_request_request_completed(result, response_code, headers, body):
	#print("requested")
	var prejson = body.get_string_from_utf8()
	var obtainedjson = JSON.parse_string(prejson)
	
	#print("Obtener Json:")
	#print(obtainedjson)
	if str(obtainedjson) != "<null>":
		#print("listo web")
		$InternetStatus.setInternetIcon(true)
		Global.online = true
		if(nointernet and not llamadoelmodal):
			#print("llamar al modal")
			nointernet = false
			llamadoelmodal = true
			$ModalNet.visible = true
	else:
		print("No hay internetus")
		Global.online = false
		nointernet = true
		$InternetStatus.setInternetIcon(false)
	
	$CheckInternetAgain.start()


func _on_check_internet_again_timeout():
	#print("revisar denuevo")
	await $JsonRequest.request(Global.jsonUrl) #chequear internet

