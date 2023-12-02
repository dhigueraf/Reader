extends Control

var locations = ["","","","","",""]
var color = "627986ff"

# Called when the node enters the scene tree for the first time.

func setNameAndColor(nombre,elcolor):
	$UnidadTitulo.text = nombre
	color = elcolor
	$UnidadTitulo.modulate = Color(color)


func setFileLocation(index,location,nombre):
	locations[index] = location
	if index == 1:
		$Doc1/Label.text = nombre
		$Doc1/Cricle/CircleInterior.modulate = Color(color)
	elif index == 2:
		$Doc2/Label.text = nombre
		$Doc2/Cricle/CircleInterior.modulate = Color(color)
	elif index == 3:
		$Doc3/Label.text = nombre
		$Doc3/Cricle/CircleInterior.modulate = Color(color)
	elif index == 4:
		$Doc4/Label.text = nombre
		$Doc4/Cricle/CircleInterior.modulate = Color(color)
	elif index == 5:
		$Doc5/Label.text = nombre
		$Doc5/Cricle/CircleInterior.modulate = Color(color)





func _on_doc_1_pressed():
	print("abrir " + locations[1])
	OS.shell_open(locations[1])


func _on_doc_2_pressed():
	print("abrir " + locations[2])
	OS.shell_open(locations[2])


func _on_doc_3_pressed():
	print("abrir " + locations[3])
	OS.shell_open(locations[3])


func _on_doc_4_pressed():
	print("abrir " + locations[4])
	OS.shell_open(locations[4])


func _on_doc_5_pressed():
	print("abrir " + locations[5])
	OS.shell_open(locations[5])

