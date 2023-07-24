extends Node


var basedir = ""

var softwareinfo = {
	"nombre": "Sumo Primero software",
	"version": 0,
	"carpetabase": "cursos",
	"sistemarchivos": []
}

var SelectedCurso = {
	"nombre" : {
		"carpeta":"Carpeta",
		"boton":"Botón"
	},
	"location" : "",
	"archivos" : ""
}

var FileToRead = {
}

var FileReading = {
	paginas = [],
	currentindex = 0,
	numeropaginas = 0
}

var interactivos = {
}

func _ready():
	print("Global Ready")
