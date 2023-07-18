extends Control

var btncurso = preload("res://Objetos/BtnCurso.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	print( Global.SelectedCurso)
	$Label.text = Global.SelectedCurso.nombre.boton
	generateButtons()


func generateButtons():
	print("selected cursos archivos:")
	print(Global.SelectedCurso.archivos)
	var dir = DirAccess.open(Global.SelectedCurso.location)
	print("dir acces")
	print(dir)
	for key in Global.SelectedCurso.archivos:
			print(key)
			if "nombre" in key:
				print(key.nombre)
				var btndir = btncurso.instantiate()
				btndir.text = str(key.nombre.boton)
				btndir.disabled = true
				
				var selcur = {
					"nombre" : key.nombre,
					"archivos" : key.subelementos
 				}
				
				btndir.connect("pressed", Callable(self, "openCurso").bind(selcur))
				$HBoxContainer.add_child(btndir)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
