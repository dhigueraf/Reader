extends Control

var locations = ["","",""]
var color = "627986ff"

# Called when the node enters the scene tree for the first time.

func setNameAndColor(nombre,elcolor):
	$UnidadTitulo.text = nombre
	color = elcolor
	$UnidadTitulo.modulate = Color(color)


func setFileLocation(index,location,nombre):
	locations[index] = location
	if index == 1:
		$PPt1/Label.text = nombre
		$PPt1/Cricle/CircleInterior.modulate = Color(color)
	elif index == 2:
		$PPt2/Label.text = nombre
		$PPt2/Cricle/CircleInterior.modulate = Color(color)


func _on_p_pt_1_pressed():
	print("abrir " + locations[1])
	OS.shell_open(locations[1])


func _on_p_pt_2_pressed():
	print("abrir " + locations[2])
	OS.shell_open(locations[2])
