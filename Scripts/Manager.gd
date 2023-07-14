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
		Global.softwaeeinfo = JSON.parse_string( getlocalconfig() )
	else:
		var jsonpdf = FileAccess.get_file_as_string(json_path)
		if not jsonpdf.is_empty():
			Global.softwaeeinfo =  JSON.parse_string(jsonpdf)
		else: 
			print("Esta vacio")
			jsonpdf = FileAccess.open(json_path, FileAccess.WRITE)
			jsonpdf.store_line( getlocalconfig() )
			jsonpdf.close()
			Global.softwaeeinfo = JSON.parse_string( getlocalconfig() )
			
		print("Save data")
		print(Global.softwaeeinfo)
		
		localversion = Global.softwaeeinfo.version
		
func _on_http_request_request_completed(result, response_code, headers, body):
	var prejson = body.get_string_from_utf8()
	var obtainedjson = JSON.parse_string(prejson)
	
	print("Obtener Json:")
	print(obtainedjson)
	onlineversion = obtainedjson["version"]


func CompareVersions():
	findlocalconfig()
	$HTTPRequest.request("https://static.sumaysigue.uchile.cl/Sumo%20Primero/Json/sumoprimero.json")
	
	print("local: " + str(localversion) + " V/S " + " online: " + str(onlineversion))

func _ready():
	
	var path = OS.get_executable_path()
	print (path)
	basedir = path.get_base_dir() + "/cursos"
	converterdir = path.get_base_dir() + "/converter"
	configdir = path.get_base_dir() + "/config"
	currentdir = basedir
	previusdir = basedir
	
	CompareVersions()
	
	#iteratedirectorys(currentdir)
	
	#looadinteractivos()
	
	
	



