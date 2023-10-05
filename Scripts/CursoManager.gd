extends Control

var btncurso = preload("res://Objetos/BtnCursoDocs.tscn")
@export_node_path() var panelpath
var panel
var numberinput

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Selected Curso")
	print( Global.SelectedCurso )
	$Label.text = Global.SelectedCurso.nombre
	Global.FileReading.curso = Global.SelectedCurso.nombre #Global.SelectedCurso.nombre.boton
	generateButtons()
	panel = get_node(panelpath)


func generateButtons():
	print("selected cursos archivos:")
	print(Global.SelectedCurso.location)
	var dir = DirAccess.open(Global.SelectedCurso.location)
	print(dir)
	if dir:
		dir.list_dir_begin()
		var dirorfilename = dir.get_next()
		while dirorfilename != "":
			if dir.current_is_dir():
				print("Found directory: " + dirorfilename)
				var btndir = btncurso.instantiate()
				btndir.changeTitle( dirorfilename )
				
				var subdir = DirAccess.open( dir.get_current_dir() + "/" + dirorfilename )
				if subdir:
					subdir.list_dir_begin()
					var file_name = subdir.get_next()
					print(file_name)
					
					while file_name != "":
						if subdir.current_is_dir():
							print("directorio: " + file_name)
						else:
							print("archivo: " + file_name)
							var filearray = file_name.split(".")
							if filearray[-1].to_lower() == "pdf":
								print(file_name + " es un PDF")
								
								var buttontocreate = {
									"nombrearchivo" : file_name,
									"soloexterno": false,
									"capitulos": {},
									"version": 0
								}
								
								if dirorfilename.to_lower() == "textos del estudiante":
									buttontocreate.soloexterno = true
									
								var jsoninfo = {}
								
								if subdir.file_exists( filearray[0] + "_info.json"):
									var fileinfo = FileAccess.get_file_as_string( subdir.get_current_dir() + "/" +  filearray[0] + "_info.json" )
									print("File info: " + fileinfo)
									if not fileinfo.is_empty():
										jsoninfo = JSON.parse_string(fileinfo)
										buttontocreate.capitulos = jsoninfo.capitulos
										buttontocreate.location = jsoninfo.location
										buttontocreate.sublocation = jsoninfo.sublocation
										buttontocreate.nombre = jsoninfo.nombre
								
								if dirorfilename == "guia didactica del docente":
									print("encontre guia didactica del docente")
								btndir.addbutton(buttontocreate)
								
							#var btndir = btncurso.instantiate()
						file_name = subdir.get_next()
				$HBoxContainer.add_child(btndir)
				
			else:
				print("Found file: " + dirorfilename)
			dirorfilename = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")



func activatePanel(document):
	print("activate panel")
	print(document)
	
	panel.activate(document)


func _on_btn_volver_pressed():
	print("Volver inicio")
	get_tree().change_scene_to_file("res://Escenas/Main.tscn")
 
