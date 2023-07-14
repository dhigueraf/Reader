extends Node

var softwareinfo = {
	"nombre": "Sumo Primero software",
	"version": 0,
	"carpetabase": "cursos",
	"sistemarchivos": []
}

var FileToRead = {
	nombre = "",
	nombrecompleto = "",
	location = "",
	nombrelocation ="",
	extension = ".",
	numeropaginas = 0,
	currentindex = 0
}

var FileReading = {}

var interactivos = {
	
}

func _ready():
	print("Global Ready")
