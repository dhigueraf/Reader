extends Control

var PersonajeIcon = preload("res://Objetos/PersoIcon.tscn")
var tomoButton = preload("res://Objetos/TomoBtn.tscn")
var dir

func _ready():
	print("Nivel")
	print(Global.nivel)
	
	$TextureRect/Label.text = Global.nivel.nombre
	dir = DirAccess.open(Global.basedir +"/"+ Global.JsonGDD.folders.documentos +"/"+ Global.nivel.sigla)
	
	agregarMascota()
	llenarPersonajes()
	llenarTomos()

func agregarMascota():
	var mascota = Global.JsonGDD.Mascota[str(Global.nivel.mascota_id)]
	print(mascota)
	$ContainerMascota/Texto.text = mascota.descripcion
	if dir.file_exists(mascota.nombre + ".png"):
		print("set imagen mascota")
		var image = Image.load_from_file(dir.get_current_dir() + "/" + mascota.nombre + ".png")
		var texture = ImageTexture.create_from_image(image)
		$ContainerMascota/TextureRect.texture = texture


func llenarPersonajes():
	var listapersonajes = Global.JsonGDD.Personaje
	
	print("lista de personajes")
	print(Global.basedir +"/"+ Global.JsonGDD.folders.documentos +"/"+ Global.nivel.sigla)
	
	
	for persoid in Global.nivel.personajes_ids:
		
		var perso = listapersonajes[str(persoid)]
		
		var persoIcon = PersonajeIcon.instantiate()
		var nombrearray = perso.nombre.split("_")
		
		
		persoIcon.setNombre(nombrearray[0])
		if dir.file_exists(perso.nombre + ".png"):
			persoIcon.setIcon(dir.get_current_dir() + "/" + perso.nombre + ".png")
			
		$ContainerEstudiantes/HBoxContainer.add_child(persoIcon)

func llenarTomos():
	var tomos =  Global.nivel.tomos
	
	for tomo in tomos:
		var tomobtn = tomoButton.instantiate()
		tomobtn.setBtnTxt(tomo.nombre)
		tomobtn.tomo = tomo
		
		if dir.dir_exists(tomo.sigla):
			var subdir = DirAccess.open( dir.get_current_dir() + "/" + tomo.sigla )
			if subdir.file_exists( Global.nivel.sigla + "-" + tomo.sigla + "-portada." + tomo.extension ):
				tomobtn.setImage( dir.get_current_dir() + "/" + tomo.sigla + "/" + Global.nivel.sigla + "-" + tomo.sigla + "-portada." + tomo.extension )
				
			tomobtn.setTomoLocation( dir.get_current_dir() + "/" + tomo.sigla + "/" + Global.nivel.sigla + "-" + tomo.sigla + "-GDD.pdf" )
		
		$TomosContainer.add_child(tomobtn)


func _on_texture_button_pressed():

	get_tree().change_scene_to_file("res://Escenas/Editables.tscn")
