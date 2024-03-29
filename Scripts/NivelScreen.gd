extends Control

var PersonajeIcon = preload("res://Objetos/PersoIcon.tscn")
var tomoButton = preload("res://Objetos/TomoBtn.tscn")
var dir

var listaTomos = []

func _ready():
	print("Nivel")
	print(Global.nivel)
	
	$superiorButtons.setTitulo(Global.nivel.nombre)
	dir = DirAccess.open(Global.basedir +"/"+ Global.JsonGDD.folders.documentos +"/"+ Global.nivel.sigla)
	
	agregarMascota()
	llenarPersonajes()
	llenarTomos()
	
	if Global.online:
		print("hacer request analitic GDD")
		var evento=  {
			"name": "Nivel",
				"params": {
				  "curso": Global.nivel.sigla
				}
		  }
		Global.askanarenquest(Global.anaUrl+"/GDD/CURSO:"+Global.nivel.sigla,[],[evento]) #enviaranalitica 

func agregarMascota():
	var mascota = Global.JsonGDD.mascotas[str(Global.nivel.mascota_id)]
	print(mascota)
	$ContainerMascota/Texto.text = mascota.descripcion
	if dir.file_exists(mascota.nombre + ".png"):
		print("set imagen mascota")
		var image = Image.load_from_file(dir.get_current_dir() + "/" + mascota.nombre + ".png")
		var texture = ImageTexture.create_from_image(image)
		$ContainerMascota/TextureRect.texture = texture


func llenarPersonajes():
	var listapersonajes = Global.JsonGDD.personajes
	
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
	
	for tomonum in Global.nivel.tomos.keys():
		listaTomos.append(Global.nivel.tomos[tomonum])
	
	
	for tomo in listaTomos:
		var tomobtn = tomoButton.instantiate()
		tomobtn.setBtnTxt(tomo.nombre)
		tomobtn.tomo = tomo
		
		print(tomo)
		
		if dir.dir_exists(tomo.sigla):
			var subdir = DirAccess.open( dir.get_current_dir() + "/" + tomo.sigla )
			if subdir.file_exists( Global.nivel.sigla + "-" + tomo.sigla + "-portada." + tomo.extension_portada ):
				tomobtn.setImage( dir.get_current_dir() + "/" + tomo.sigla + "/" + Global.nivel.sigla + "-" + tomo.sigla + "-portada." + tomo.extension )
				
			tomobtn.setTomoLocation( dir.get_current_dir() + "/" + tomo.sigla + "/" + Global.nivel.sigla + "-" + tomo.sigla + "-GDD.pdf" )
		
		$TomosContainer.add_child(tomobtn)


func _on_texture_button_pressed():
	#Global.anaUrl+"/GDD/CURSO:"+Global.nivel.sigla
	get_tree().change_scene_to_file("res://Escenas/Editables.tscn")
