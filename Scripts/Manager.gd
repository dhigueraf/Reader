extends Control

@onready var listoffolders = []
@onready var listoffiles = []
@export var discartednames= [".",".."]
@export var formatsallowed = ["doc","docx","ppt","pptx","xls","xls","odt","pdf","webm","mp4","mkv","png","jpg","jpeg"]

var history = []
var basedir =""
var configdir = ""
var converterdir = ""
var currentdir = ""
var previusdir = ""
var filetoopen = ""
var nombreinteract = "interactivos"

var localversion = 0
var onlineversion = 0

func getlocalconfig():
	var defaultjsonlocation = "res://json/sumoprimero.json"
	var json_as_text = FileAccess.get_file_as_string(defaultjsonlocation)
	#print(json_as_text)
	return json_as_text

func findlocalconfig():
	var json_path = configdir + "/config.json"
	#ar jsonpdf = FileAccess.open(json_path, )
	if not FileAccess.file_exists(json_path):
		print("No existe")
		var jsonpdf = FileAccess.open(json_path, FileAccess.WRITE)
		jsonpdf.store_line( getlocalconfig() )
		jsonpdf.close()
		Global.softwareinfo = JSON.parse_string( getlocalconfig() )
	else:
		var jsonpdf = FileAccess.get_file_as_string(json_path)
		if not jsonpdf.is_empty():
			Global.softwareinfo =  JSON.parse_string(jsonpdf)
		else: 
			print("Esta vacio")
			jsonpdf = FileAccess.open(json_path, FileAccess.WRITE)
			jsonpdf.store_line( getlocalconfig() )
			jsonpdf.close()
			Global.softwareinfo = JSON.parse_string( getlocalconfig() )
			
		print("Save data")
		print(Global.softwareinfo)
		
		localversion = Global.softwareinfo.version
		
func _on_http_request_request_completed(result, response_code, headers, body):
	var prejson = body.get_string_from_utf8()
	var obtainedjson = JSON.parse_string(prejson)
	
	print("Obtener Json:")
	#print(obtainedjson)
	if str(obtainedjson) != "<null>":
		onlineversion = obtainedjson["version"]
		print("listo web")
	else:
		print("No hay internetus")




func _ready():

	var path = OS.get_executable_path()
	basedir = path.get_base_dir()
	converterdir = basedir + "/converter"
	configdir = basedir + "/config"
	currentdir = basedir
	previusdir = basedir
	
	$HTTPRequest.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/Json/sumoprimero.json")
	findlocalconfig()

	#print("software info:")
	#print(Global.softwareinfo)
	
	checkfilesystem()


func checkfilesystem():
	print("primera carpeta " + str(Global.softwareinfo.carpetabase) + ".")
	
	var dir = DirAccess.open(basedir)
	if dir.dir_exists(Global.softwareinfo.carpetabase) :
		print("directorio existe")
		
		for key in Global.softwareinfo.sistemarchivos:
			print(key)
			if "nombre" in key:
				print(key.nombre)
				var btndir = Button.new()
				btndir.text = str(key.nombre.boton)
				#var filearray = file.split(".")
				#if( filearray[-1] == "pdf" ):
				#	btndir.connect("pressed", Callable(self, "pdfButtons").bind(currentdir+"/"+file,file))
				#else:
				#	btndir.connect("pressed", Callable(self, "openfile").bind(currentdir+"/"+file))
				$VBoxContainer.add_child(btndir)
		
		
	else:
		print("directorio no existe")
		dir.make_dir(Global.softwareinfo.carpetabase)

