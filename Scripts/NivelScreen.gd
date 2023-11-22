extends Control

var PersonajeIcon = preload("res://Objetos/PersoIcon.tscn")

func _ready():
	print("Nivel")
	print(Global.nivel)
	
	var mascota = Global.JsonGDD.Mascota[str(Global.nivel.mascota_id)]
	
	print(mascota)

	$ContainerMascota/Texto.text = mascota.descripcion
	#$ContainerMascota/TextureRect
	
	var listapersonajes = Global.JsonGDD.Personaje
	
	for perso in Global.nivel.personajes_ids:
		print(perso)
	

func _process(delta):
	pass
