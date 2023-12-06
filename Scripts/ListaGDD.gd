extends Control
var listaNiveles = []
var btnNivel = preload("res://Objetos/curso_btn.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("lista de Cursos")
	
	$superiorButtons.setTitulo("Guía Digital del Docente")
	
	listaNiveles = Global.JsonGDD.Niveles
	
	print(listaNiveles)
	#print(Global.JsonGDD)
	
	createNivelButtons()


func createNivelButtons():
	print("Crear la lista de botones")
	
	for nivel in listaNiveles:
		print(nivel.nombre)
		print(nivel.sigla)
		
		var btnniv = btnNivel.instantiate()
		btnniv.setButtonText(nivel.nombre)
		btnniv.nivel = nivel
		
		var dir = DirAccess.open(Global.basedir + "/" + Global.JsonGDD.folders.documentos + "/" + nivel.sigla)
		print(dir)
		if dir.file_exists(nivel.sigla+"_portada.png"):
			print("existe imagen de portada")
			btnniv.setPortada(dir.get_current_dir()+"/"+nivel.sigla+"_portada.png")
		
		$HBoxContainer.add_child(btnniv)


func _process(delta):
	pass
