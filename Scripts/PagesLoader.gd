extends CanvasLayer

var pages = []
var actualindex = 0
var maxindex = 1
var interactivos = []
var tipointeraccion = "nada"
var parametrointera = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var converterdir = Global.basedir + "/converter"
	var dir = DirAccess.open(converterdir)
	
	if dir:
		dir.list_dir_begin()
		var iteratedname = dir.get_next()
		while (iteratedname != ""):
			if not dir.current_is_dir():
				print("Found file: " + iteratedname)
				var filearray = iteratedname.split(".")
				if( filearray[-1] == "png" ):
					print(iteratedname)
					pages.append(converterdir + "/" + iteratedname)
			iteratedname = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	if(pages.size() > 0):
		maxindex = pages.size()
		Global.FileReading.numeropaginas = maxindex
		Global.FileReading.paginas = pages
	else:
		maxindex = 0
	
	print("current index " + str(Global.FileReading.currentindex) )
	
	print("File loaded")
	print(Global.FileReading)
	
	updateindex(Global.FileReading.currentindex)

func setimage(index):
	print("set iamge index: " + str(index))
	print(pages[index])
	#var image = Image.new()
	#var err = image.load(pages[index])
	
	var image = Image.load_from_file(pages[index])
	var texture = ImageTexture.create_from_image(image)
	print(texture)
	
	$ScrollContainer/TextureRect.texture = texture
	$Control/GraphEdit/GraphNode/TextureRect2.texture = texture

	$EtiquetaPagina.text = "Notas pagina " + str(index)
	if Global.FileReading.has('paginas'):
		if range( Global.FileReading.paginas.size() ).has(index):
			$NotasContainer.text = Global.FileReading.paginas[index].notas
		else:
			$NotasContainer.text = ""
	else:
		$NotasContainer.text = ""
	
func updateindex(num):
	print("actualindex " + str(actualindex) )
	actualindex += num

	if num == 1:
		$retroceder.disabled = false
		if actualindex > maxindex -2:
			actualindex = maxindex -1
			$avanzar.disabled = true
	elif num == -1:
		$avanzar.disabled = false
		if actualindex < 1:
			actualindex = 0
			$retroceder.disabled = true
	
	Global.FileReading.currentindex = actualindex
	
	var showbutton = false
	var textoasignar = "interactivo"

	'''
	if not interactivos.is_empty():
		for intera in interactivos["interactivos"]:
			if actualindex == intera["pagina"]:
				print("pagina con interactivos")
				textoasignar = intera["textoboton"]
				showbutton = true;
				tipointeraccion = intera["tipo"]
				parametrointera = intera["escenaoarchivo"]
	if showbutton: 
		$ButtonInteactivo.visible = true
		$ButtonInteactivo.text = textoasignar
	else:
		$ButtonInteactivo.visible = false
		$ButtonInteactivo.text = "interactivo"
	'''
	
	setimage(actualindex)

#func disconectallnodes():
#	pass


func _on_avanzar_pressed():
	updateindex(1)

func _on_retroceder_pressed():
	updateindex(-1)

func _on_ButtonMapa_pressed():
	get_tree().change_scene_to_file("res://mapas/Mapas.tscn")


func _on_NotasContainer_text_changed():
	print( "editaste el texto " + str(actualindex) )
	Global.FileReading.paginas[actualindex].notas = $NotasContainer.text 


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
	get_tree().change_scene_to_file("res://Escenas/Scene.tscn")


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
