extends CanvasLayer

var pages = []
var actualindex = 0

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
		
		
	var image = Image.new()
	if(pages.size() > 0):
		var err = image.load(pages[actualindex])
		var texture = ImageTexture.new()
		texture.create_from_image(image, 0)
		print(texture)
		$ScrollContainer/TextureRect.texture = texture

