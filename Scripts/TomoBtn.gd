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
	print(tomo.sigla)
	
	OS.shell_open("C:/Users/lorde/Desktop/godoto test/documentos/1B/T1/1B-T1-GDD.pdf")
	#"C:\Users\lorde\Desktop\godoto test\documentos\1B\T1\1B-T1-GDD.pdf"
	#var dir = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos)
	#print(dir)
	
