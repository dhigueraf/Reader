extends Node

var softwaeeinfo = {
	"nombre": "Sumo Primero software",
	"version": 0,
	"carpetabase": "cursos",
	"sistemarchivos": [
		{
			"tipo": "carpeta",
			"nombre":{
				"carpeta": "primerobasico",
				"boton": "Primero Básico"
			},
			"subelementos":[
				{
					"tipo": "carpeta",
					"nombre": {
						"carpeta": "textosdelestudiante",
						"boton": "Textos del Estudiante"
					},
					"subelementos":[
						{
							"tipo":"archivo",
							"nombre": {
								"carpeta": "tomo1",
								"boton": "Tomo 1"
							},
							"extension":"pdf",
							"version": 0,
							"url" : "https://static.sumaysigue.uchile.cl/Sumo%20Primero/4%C2%B0%20B%C3%A1sico/CA/CA4_tomo1.pdf",
							"location": "primerobasico/textosdelestudiante/"
						},
						{
							"tipo":"archivo",
							"nombre": {
								"carpeta": "tomo2",
								"boton": "Tomo 2"
							},
							"extension":"pdf",
							"version": 0,
							"url" : "https://static.sumaysigue.uchile.cl/Sumo%20Primero/4%C2%B0%20B%C3%A1sico/CA/CA4_tomo1.pdf",
							"location": "primerobasico/textosdelestudiante/"
						}
					]
				},
				{
					"tipo": "carpeta",
					"nombre": {
						"carpeta": "guiadidacticadeldocente",
						"boton": "Guía Didáctica del Docente"
					},
					"subelementos":[
						{
							"tipo":"archivo",
							"nombre": {
								"carpeta": "tomo1",
								"boton": "Tomo 1"
							},
							"extension":"pdf",
							"version": 0,
							"url" : "https://static.sumaysigue.uchile.cl/Sumo%20Primero/4%C2%B0%20B%C3%A1sico/CA/CA4_tomo1.pdf",
							"location": "primerobasico/guiadidacticadeldocente/"
						},
						{
							"tipo":"archivo",
							"nombre": {
								"carpeta": "tomo2",
								"boton": "Tomo 2"
							},
							"extension":"pdf",
							"version": 0,
							"url" : "https://static.sumaysigue.uchile.cl/Sumo%20Primero/4%C2%B0%20B%C3%A1sico/CA/CA4_tomo1.pdf",
							"location": "primerobasico/guiadidacticadeldocente/"
						}
					]
				}
			]
		},
		{
			"tipo": "carpeta",
			"nombre":"Segundo Básico",
			"subelementos":[]
		},
		{
			"tipo": "carpeta",
			"nombre":"Tercero Básico",
			"subelementos":[]
		}
	]
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
