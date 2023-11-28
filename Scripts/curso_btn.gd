extends Control

var nivel = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setTexture(location):
	pass
	
func setButtonText(text):
	$Button/Label.text = text

func openNivel(level):
	print("Open nivel")
	Global.nivel = level
	print(Global.nivel)
	
	get_tree().change_scene_to_file("res://Escenas/Nivel.tscn")

func _on_button_pressed():
	openNivel(nivel)

func setPortada(location):
	print("set portada")
	print(location)
	var image = Image.load_from_file(location)
	var texture = ImageTexture.create_from_image(image)
	$TextureRect.texture = texture
	
