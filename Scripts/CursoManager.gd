extends Control

var btncurso = preload("res://Objetos/BtnCursoDocs.tscn")
@export_node_path() var panelpath
var panel

# Called when the node enters the scene tree for the first time.
func _ready():
	print( Global.SelectedCurso)
	$Label.text = Global.SelectedCurso.nombre.boton
	generateButtons()
	panel = get_node(panelpath)


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
				btndir.changeTitle( str(key.nombre.boton) )
				
				var selcur = {
					"nombre" : key.nombre,
					"archivos" : key.subelementos
 				}
				
				for subele in key.subelementos:
					btndir.addbutton(subele)
				#btndir.connect("pressed", Callable(self, "activatePanel").bind())
				$HBoxContainer.add_child(btndir)

func activatePanel(document):
	print("activate panel")
	panel.activate(document)
