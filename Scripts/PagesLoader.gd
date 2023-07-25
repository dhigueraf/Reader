extends CanvasLayer

var pages = []
var actualindex = 0
var maxindex = 1
var interactivos = []
var tipointeraccion = "nada"
var parametrointera = ""

@onready var dir = DirAccess.open( Global.basedir + "/converter")
# Called when the node enters the scene tree for the first time.
func _ready():

	var pagiterator = 0
		

	maxindex = Global.FileReading.numeropaginas
	#Global.FileReading.numeropaginas = maxindex
	#Global.FileReading.paginas = pages

	print("current index " + str(Global.FileReading.currentindex) )
	
	print("File loaded")
	print(Global.FileReading)
	
	if Global.FileReading.currentindex > 0:
		$avanzar.disabled = false
		$retroceder.disabled = false
	if Global.FileReading.currentindex >= Global.FileReading.numeropaginas-1:
		$avanzar.disabled = true
		$retroceder.disabled = false
	updateindex(Global.FileReading.currentindex)

func setimage(index):
	print("set iamge index: " + str(index))
	
	if dir.file_exists("pagina_" + str(index) + ".png"):
	
		var image = Image.load_from_file(Global.basedir + "/converter/" + "pagina_" + str(index) + ".png")
		var texture = ImageTexture.create_from_image(image)
		print(texture)
		
		$ScrollContainer/TextureRect.texture = texture
		$Control/GraphEdit/GraphNode/TextureRect2.texture = texture
	
	else:
		print("no existe la imagen")
		await Global.GenerarImagenes(Global.FileToRead.location,index)
		
		print("ahora cargarla")
		var image = Image.load_from_file(Global.basedir + "/converter/" + "pagina_" + str(index) + ".png")
		var texture = ImageTexture.create_from_image(image)
		print(texture)
		
		$ScrollContainer/TextureRect.texture = texture
		$Control/GraphEdit/GraphNode/TextureRect2.texture = texture

	if index == 0:
		$EtiquetaPagina.text = "Portada"
	else:
		$EtiquetaPagina.text = "Pagina " + str(index)
	
func updateindex(num):
	print("actualindex " + str(actualindex) )
	actualindex += num
	
	if num == 0:
		$avanzar.disabled = false
		actualindex = 0
		$retroceder.disabled = true
	elif num == 1:
		$retroceder.disabled = false
		if actualindex > maxindex -2:
			actualindex = maxindex -1
			$avanzar.disabled = true
	elif num == -1 or num == 0:
		$avanzar.disabled = false
		if actualindex < 1:
			actualindex = 0
			$retroceder.disabled = true
			
			
	Global.FileReading.currentindex = actualindex
	
	var showbutton = false
	var textoasignar = "interactivo"

	
	setimage(actualindex)

#func disconectallnodes():
#	pass


func _on_avanzar_pressed():
	updateindex(1)

func _on_retroceder_pressed():
	updateindex(-1)

func _on_ButtonMapa_pressed():
	get_tree().change_scene_to_file("res://mapas/Mapas.tscn")

func _on_Button_pressed():
	pass # Replace with function body.


func _on_ButtonPlus_pressed():
	pass # Replace with function body.


func _on_ButtonMinus_pressed():
	pass # Replace with function body.


func _on_GraphNode_dragged(from, to):
	print(from, to)


func _on_button_return_pressed():
	print("Volver inicio")
	get_tree().change_scene_to_file("res://Escenas/Main.tscn")


func interactnode(nodedir):
	get_tree().change_scene_to_file(nodedir)
	
func interactexternal(filedir):
	OS.shell_open(filedir)


func _on_button_inteactivo_pressed():
	print("Interactivo")
	
	if tipointeraccion == "nodo":
		interactnode(parametrointera)
	elif tipointeraccion == "ppt":
		interactexternal(parametrointera)
