extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setNombre(nombrie):
	$Label.text = nombrie


func setIcon(location):
	print("cargar  ocpmp personaje")
	print(location)
	var image = Image.load_from_file(location)
	var texture = ImageTexture.create_from_image(image)
	$Student.texture = texture
