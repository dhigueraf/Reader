extends CanvasLayer

var pages = []
var actualindex = 0
var maxindex = 1

func _ready():
	var path = OS.get_executable_path()
	var converterdir = path.get_base_dir() + "/converter"
	var dir = Directory.new()
	
	if dir.open(converterdir) == OK:
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
		Global.FileToRead.numeropaginas = maxindex
	else:
		maxindex = 0
	
	print("current index " + str(Global.FileToRead.currentindex) )
	
	print("File loaded")
	print(Global.FileToRead)
	
		
	var jsonpdf = File.new()
	if not jsonpdf.file_exists(Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json"):
		print("No existe")
		jsonpdf.open(Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json", File.WRITE)
		jsonpdf.store_line( to_json( generate_json(maxindex) ) )
		jsonpdf.close()
		
	jsonpdf.open(Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json", File.READ)
	if jsonpdf.get_as_text() != "" :
		Global.FileReading = parse_json(jsonpdf.get_as_text())
	else: 
		Global.FileReading = generate_json(maxindex)
	print("Save data")
	#print(Global.FileReading)
	
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
	var jsontosave = File.new()
	jsontosave.open(Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json", File.WRITE)
	jsontosave.store_line( to_json( Global.FileReading ) )
	jsontosave.close()

func setimage(index):
	print("set iamge index: " + str(index))
	print(pages[index])
	var image = Image.new()
	var err = image.load(pages[index])
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	print(texture)
	
	$ScrollContainer/TextureRect.texture = texture
	
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
	setimage(actualindex)


func _on_retroceder_pressed():
	updateindex(-1)

func _on_avanzar_pressed():
	updateindex(1)


func _on_ButtonSave_pressed():
	print("Guardar")
	save()

func _on_ButtonMapa_pressed():
	get_tree().change_scene("res://mapas/Mapas.tscn")


func _on_NotasContainer_text_changed():
	print( "editaste el texto " + str(actualindex) )
	Global.FileReading.paginas[actualindex].notas = $NotasContainer.text 


func _on_Button_pressed():
	pass # Replace with function body.


func _on_ButtonPlus_pressed():
	pass # Replace with function body.


func _on_ButtonMinus_pressed():
	pass # Replace with function body.
