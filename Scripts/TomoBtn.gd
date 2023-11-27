extends Control

var tomo = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setBtnTxt(texto):
	$TextureButton/Label.text = texto


func _on_texture_button_pressed():
	print("Abrir un PDF")
	print(tomo)
	
	var dir = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos)
	print(dir)
	
	if dir.dir_exists( assetsdir ):
