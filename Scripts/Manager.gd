extends Control

onready var listoffolders = []
onready var listoffiles = []
export var discartednames= [".",".."]
export var formatsallowed = ["doc","docx","ppt","pptx","xls","xls","odt","pdf","webm","mp4","mkv","png","jpg","jpeg"]
var history = []
var basedir =""
var converterdir = ""
var currentdir = ""
var previusdir = ""
var filetoopen = ""

onready var http : HTTPRequest = $HTTPRequest

const PROJECT_ID := "prueba-front-746df"
const FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID

func get_documentorcollection(path: String) -> void:
	var url := FIRESTORE_URL + path
	http.request(url)
	


func _ready():
	var path = OS.get_executable_path()
	#print (path)
	basedir = path.get_base_dir() + "/cursos"
	converterdir = path.get_base_dir() + "/converter"
	currentdir = basedir
	previusdir = basedir
	
	iteratedirectorys(currentdir)
	$pdfbuttons.visible = false
	
	get_documentorcollection("colecciondeprueba")
	#var colprueba =  Firebase.get_document_or_collection("colecciondeprueba",http)
	#print(colprueba)
	#print(http)
	
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	if body and JSON.parse(body.get_string_from_ascii()).result:
		var request_result := JSON.parse(body.get_string_from_ascii()).result as Dictionary
		print(request_result)
		#var res = firebase_firestore_parse(request_result)


func opendir(dir):
	previusdir = currentdir
	currentdir = dir
	history.append(previusdir)
	cleanContainers()
	iteratedirectorys(currentdir)
	
	

func openfile(filedir):
	$FileRute.text = str(filedir)
	OS.shell_open(filedir)


func iteratedirectorys(directory):
	print("directorio: "+ directory)
	var dir = Directory.new()
	
	if dir.open(directory) == OK:
		dir.list_dir_begin()
		var iteratedname = dir.get_next()
		while (iteratedname != ""):
			if dir.current_is_dir():
				#print("Found directory: " + iteratedname)
				if not (discartednames.has(iteratedname)):
					listoffolders.append(iteratedname)
			else:
				#print("Found file: " + iteratedname)
				var filearray = iteratedname.split(".")
				if(formatsallowed.has(filearray[-1])):
					listoffiles.append(iteratedname)
			iteratedname = dir.get_next()
		generateListOfFolderButtons()
		generateListOfFilesButtons()
	else:
		print("An error occurred when trying to access the path.")
		
	

func generateListOfFolderButtons():
	#print(listoffolders)
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
			var filearray = file.split(".")
			if( filearray[-1] == "pdf" ):
				btndir.connect("pressed",self,"pdfButtons",[currentdir+"/"+file,file])
			else:
				btndir.connect("pressed",self,"openfile",[currentdir+"/"+file])
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
	
	#print("limpiar")
	

func makehistory(tope):
	var iterator = 0
	var array= [] 
	while( iterator  <  tope ):
		array.append(history[iterator])
		iterator += 1
	return array


func _on_BtnBack_pressed():
	print("Histori")
	print(history)
	
	if(history.size()  > 0):
		print("ir atras")
		currentdir = history[-1]
		history = makehistory(history.size() - 1)
		print(history)
		cleanContainers()
		iteratedirectorys(currentdir)


func pdfButtons(filedir,filename):
	print("PDF buttons")
	$pdfbuttons.visible = true
	Global.FileToRead.location = currentdir
	var filenamearray = filename.split(".") 
	Global.FileToRead.nombre = filenamearray[0]
	Global.FileToRead.extension = filenamearray[-1]
	Global.FileToRead.nombrecompleto = filename
	Global.FileToRead.nombrelocation = filedir
	Global.FileToRead.currentintex = 0
	print(Global.FileToRead)
	filetoopen = filedir
	

func _on_BtnHome_pressed():
	currentdir = basedir;
	
	history = []
	
	cleanContainers()
	iteratedirectorys(currentdir)


func _on_BtnExterno_pressed():
	openfile(filetoopen)


func _on_BtnNotas_pressed():
	$pdfbuttons.activateLoading()
	prepararanotas()
	
	
func prepararanotas():
	var dir = Directory.new()
	print("eliminar imagenes anteriores")
	if dir.open(converterdir) == OK:
		dir.list_dir_begin()
		var iteratedname = dir.get_next()
		while (iteratedname != ""):
			if not dir.current_is_dir():
				print("Found file: " + iteratedname)
				var filearray = iteratedname.split(".")
				if( filearray[-1] == "png" ):
					print(iteratedname)
					dir.remove(converterdir + "/" + iteratedname)
			iteratedname = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	
	print("generar pdf images")
	
	var filetoopenarray = filetoopen.split(".")
	
	if filetoopenarray[-1] == "pdf":
		print("es convertible")
		var sistemaoperativo = OS.get_name()
		print(sistemaoperativo)
		var ejecutable = converterdir + "/pdf2pngimgs.exe"
		if sistemaoperativo.to_lower() == "windows":
			print("windows")
			ejecutable = converterdir + "/pdf2pngimgs.exe"
		elif sistemaoperativo.to_lower() == "x11" || sistemaoperativo.to_lower() == "linux":
			print("linux")
			ejecutable = converterdir + "/pdf2pngimg"
		
		var output = []
		OS.execute(ejecutable, [filetoopen], true, output)
		print("Ouput: ")
		for text in output:
			print(text)
		print("Fin Ejecución")
	
	print("Cambiar de escena")
	get_tree().change_scene("res://Escenas/notas.tscn")
