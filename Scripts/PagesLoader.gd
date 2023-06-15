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
		updateindex(0)
	else:
		maxindex = 0

func setimage(index):
	print("set iamge index: " + str(index))
	var image = Image.new()
	var err = image.load(pages[index])
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	print(texture)
	$ScrollContainer/TextureRect.texture = texture
	
	$EtiquetaPagina.text = "Notas pagina " + str(index)

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
	
	setimage(actualindex)	


func _on_retroceder_pressed():
	updateindex(-1)

func _on_avanzar_pressed():
	updateindex(1)
