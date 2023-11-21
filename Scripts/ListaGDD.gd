extends Control
var listaNiveles = []
var btnNivel = preload("res://Objetos/curso_btn.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("lista de Cursos")
	
	listaNiveles = Global.JsonGDD.Niveles
	
	print(listaNiveles)
	#print(Global.JsonGDD)
	createNivelButtons()
	
func createNivelButtons():
	print("Crear la lista de botones")
	
	for nivel in listaNiveles:
		print(nivel.nombre)
		
		var btnniv = btnNivel.instantiate()
		btnniv.setButtonText(nivel.nombre)
		$HBoxContainer.add_child(btnniv)
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
