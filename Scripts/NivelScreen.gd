extends Control

var PersonajeIcon = preload("res://Objetos/PersoIcon.tscn")
var tomoButton = preload("res://Objetos/TomoBtn.tscn")

func _ready():
	print("Nivel")
	print(Global.nivel)
	
	$TextureRect/Label.text = Global.nivel.nombre
	
	agregarMascota()
	llenarPersonajes()
	llenarTomos()

func agregarMascota():
	var mascota = Global.JsonGDD.Mascota[str(Global.nivel.mascota_id)]
	print(mascota)
	$ContainerMascota/Texto.text = mascota.descripcion
	#$ContainerMascota/TextureRect

func llenarPersonajes():
	var listapersonajes = Global.JsonGDD.Personaje
	
	for persoid in Global.nivel.personajes_ids:
		
		var perso = listapersonajes[str(persoid)]
		
		var persoIcon = PersonajeIcon.instantiate()
		var nombrearray = perso.nombre.split("_")
		persoIcon.setNombre(nombrearray[0])
		$ContainerEstudiantes/HBoxContainer.add_child(persoIcon)

func llenarTomos():
	var tomos =  Global.nivel.tomos
	
	for tomo in tomos:
		var tomobtn = tomoButton.instantiate()
		tomobtn.setBtnTxt(tomo.nombre)
		tomobtn.tomo = tomo
		$TomosContainer.add_child(tomobtn)


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Escenas/Editables.tscn")
