extends Control

onready var listoffolders = []
onready var listoffiles = []
export var discartednames= [".",".."]
export var formatsallowed = ["doc","docx","ppt","pptx","xls","xls","odt","pdf","webm","mp4","mkv","png","jpg","jpeg"]
var basedir =""
var currentdir = ""
var previusdir = ""

func opendir(dir):
	previusdir = currentdir
	currentdir = dir
	
	cleanContainers()
	iteratedirectorys(currentdir)

func openfile(dir,filename):
	print("dir and name")
	print(dir)
	print(filename)
	OS.shell_open(str("file://", dir + "/" + filename ) )


func _ready():
	var path = OS.get_executable_path()
	print (path)
	basedir = path.get_base_dir() + "/cursos"
	currentdir = basedir
	previusdir = basedir
	
	iteratedirectorys(currentdir)

func iteratedirectorys(directory):
	print("directorio: "+ directory)
	var dir = Directory.new()
	
	if dir.open(directory) == OK:
		dir.list_dir_begin()
		var iteratedname = dir.get_next()
		while (iteratedname != ""):
			if dir.current_is_dir():
				print("Found directory: " + iteratedname)
				if not (discartednames.has(iteratedname)):
					listoffolders.append(iteratedname)
			else:
				print("Found file: " + iteratedname)
				var filearray = iteratedname.split(".")
				if(formatsallowed.has(filearray[-1])):
					listoffiles.append(iteratedname)
			iteratedname = dir.get_next()
		generateListOfFolderButtons()
		generateListOfFilesButtons()
	else:
		print("An error occurred when trying to access the path.")
		
	

func generateListOfFolderButtons():
	print(listoffolders)
	if (listoffolders.size() > 0):
		for folder in listoffolders:
			var btndir = Button.new()
			btndir.text = folder
			btndir.connect("pressed",self,"opendir",[currentdir+"/"+ folder])
			$ContainerCarpetas/VBoxContainer.add_child(btndir)

func generateListOfFilesButtons():
	print(listoffiles)
	if (listoffiles.size() > 0):
		for file in listoffiles:
			var btndir = Button.new()
			btndir.text = file
			btndir.connect("pressed",self,"openfile",[currentdir,file])
			$ContainerArchivos/VBoxContainer.add_child(btndir)

func cleanContainers():
	listoffolders = []
	listoffiles = []
	
	var folderchilds =  $ContainerCarpetas/VBoxContainer.get_children()
	for foldchi in folderchilds:
		$ContainerCarpetas/VBoxContainer.remove_child(foldchi)
		#foldchi.queque_free()
		
	var fileschilds =  $ContainerArchivos/VBoxContainer.get_children()
	for filchi in fileschilds:
		$ContainerArchivos/VBoxContainer.remove_child(filchi)
		#filchi .queque_free()
	
	print("limpiar")
	


func _on_TextureButton_pressed():
	currentdir = previusdir;
	
	cleanContainers()
	iteratedirectorys(currentdir)