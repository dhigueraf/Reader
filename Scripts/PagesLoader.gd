extends CanvasLayer

var pages = []
var actualindex = 0
var maxindex = 1
var interactivos = []

func _ready():
	var path = OS.get_executable_path()
	var converterdir = path.get_base_dir() + "/converter"
	var dir = DirAccess.open(converterdir)
	
	if dir:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
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
		Global.FileToRead.numeropaginas = maxindex
	else:
		maxindex = 0
	
	print("current index " + str(Global.FileToRead.currentindex) )
	
	print("File loaded")
	print(Global.FileToRead)
	
	var json_path = Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json"
	#var jsonpdf = FileAccess.open(json_path, )
	if not FileAccess.file_exists(json_path):
		print("No existe")
		var jsonpdf = FileAccess.open(json_path, FileAccess.WRITE)
		jsonpdf.store_line(JSON.new().stringify(generate_json(maxindex)))
		jsonpdf.close()
	else:
		var jsonpdf = FileAccess.get_file_as_string(json_path)
		
		if not jsonpdf.is_empty():
			var test_json_conv = JSON.parse_string(jsonpdf)
			Global.FileReading = test_json_conv
		else: 
			Global.FileReading = generate_json(maxindex)
		print("Save data")
		#print(Global.FileReading)
		
	print("Interactivos")
	for inter in Global.interactivos:
		print(inter["nombre"])
		if inter["nombre"] == Global.FileToRead["nombrecompleto"]:
			interactivos = inter
	print(interactivos)
	
	updateindex(Global.FileToRead.currentindex)


func generate_json(num):
	print("Crear json de " + str(num) + " paginas")
	var emptyjson = {
		paginas = [],
		nombre = Global.FileToRead.nombrecompleto,
		numerodepaginas = num
	}
	var iterator = 0
	while iterator < num :
		var pagtoadd = {
			id = iterator,
			notas = "",
			mapaideas = {
				connections = [],
				nodes = []
			}
		}
		emptyjson.paginas.append(pagtoadd)
		iterator+= 1
	print(emptyjson)
	return emptyjson


func save():
	var path_file = Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json"
	var jsontosave = FileAccess.open(path_file, FileAccess.WRITE)
	jsontosave.store_line( JSON.new().stringify( Global.FileReading ) )
	jsontosave.close()

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
	
	Global.FileToRead.currentindex = actualindex
	
	var showbutton = false
	var textoasignar = "interactivo"

	
	for intera in interactivos["interactivos"]:
		if actualindex == intera["pagina"]:
			print("pagina con interactivos")
			textoasignar = intera["textoboton"]
			showbutton = true;
			if intera["tipo"] == "nodo":
				$ButtonInteactivo.connect("pressed", Callable(self, "interactnode").bind(intera["escenaoarchivo"]))
			elif intera["tipo"] == "ppt":
				$ButtonInteactivo.connect("pressed", Callable(self, "interactexternal").bind(Global.FileToRead.nombrelocation))
		
	if showbutton: 
		$ButtonInteactivo.visible = true
		$ButtonInteactivo.text = textoasignar
	else:
		$ButtonInteactivo.visible = false
		$ButtonInteactivo.text = "interactivo"
	
	setimage(actualindex)

func disconect


func _on_avanzar_pressed():
	updateindex(1)


func _on_ButtonSave_pressed():
	print("Guardar")
	save()

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
