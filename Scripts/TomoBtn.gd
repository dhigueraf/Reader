extends Control

var tomo = null
var tomolocation = "C:/Users/lorde/Desktop/godoto test/documentos/1B/T1/1B-T1-GDD.pdf"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setBtnTxt(texto):
	$Button.text = texto


func _on_texture_button_pressed():
	print("Abrir un PDF")
	#print(tomo)
	#print(tomo.sigla)
	OS.shell_open(tomolocation)
	if Global.online:
		print("hacer request analitic GDD")
		Global.askanarenquest(Global.anaUrl+"/GDD/CURSO/Openfile/",[],'{"curso":"'+tomo.sigla+'","file":"'+tomo.sigla+'"}') #enviaranalitica 


func setTomoLocation(location):
	tomolocation = location


func setImage(location):
	print(location)
	var image = Image.load_from_file(location)
	var texture = ImageTexture.create_from_image(image)
	$TextureRect.texture = texture
