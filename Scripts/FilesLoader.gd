extends Control

var elemento = preload("res://Objetos/Elemento.tscn")
var directorio = preload("res://Objetos/ElementButton.tscn")

var formatsallowed = ["doc","docx","ppt","pptx","xls","xls","odt","pdf","webm","mp4","mkv"]

func openfile(dir,filename):
	print("dir and name")
	print(dir)
	print(filename)
	OS.shell_open(str("file://", dir + "/" + filename ) )
	
func opendir(dir):
	print("dir")
	print(dir)
	OS.shell_open(str("file://",dir))

# Called when the node enters the scene tree for the first time.
func _ready():
	var path = OS.get_executable_path()
	print (path)
	var basepath = path.get_base_dir()
	print (basepath)
	
	var position = Vector2(0,0)
	var yplus = 32

	var dir = Directory.new()
	
	if dir.open(basepath) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				var btndir = Button.new()
				btndir.text = file_name
				btndir.connect("pressed",self,"opendir",[dir.get_current_dir ( )+"/"+ file_name])
				$ContainerCarpetas/VBoxContainer.add_child(btndir)
			else:
				#print("Found file: " + file_name)
				var filearray = file_name.split(".")
				if(formatsallowed.has(filearray[-1])):
					var btnel = Button.new()
					btnel.text = file_name
					btnel.connect("pressed",self,"openfile",[basepath, file_name])
					$ContainerArchivos/VBoxContainer.add_child(btnel)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
