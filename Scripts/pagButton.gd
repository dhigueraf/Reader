extends Control

var textonom = ""
var numpa = 0

func setNombre(textonombre):
	$Nombre.text = textonombre + "..."
	textonom = textonombre
	
func setPagina(numpag):
	numpa = numpag
	$Button.text = "Pagina " + str(numpag) 


func _on_button_pressed():
	print("abrir pagina: " + textonom + " [" + str(numpa)  + "]")
	print(Global.FileToRead)
	
	await Global.DeletePreviousImages()
	await Global.GenerarImagenes(Global.FileToRead.location,numpa)
	print("Cambiar de escena")
	get_tree().change_scene_to_file("res://Escenas/Visualizador.tscn")
