extends Control

var tomosUnidad = []
var cursoindex = 0
var cursos = []

var unidadP_Btn = preload("res://Objetos/unidad_presentaciones.tscn")
var unidadE_Btn = preload("res://Objetos/unidad_evaluaciones.tscn")

var choice = "presentaciones"

var dir 

var preurl = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("Ready " + str(Global.selectedPestanaEditable))
	choice = Global.selectedPestanaEditable
	
	if choice == "presentaciones":
		$BtnPresencaciones.button_pressed = true
		$BtnEvaluaciones.button_pressed = false
	elif choice == "evaluaciones":
		$BtnEvaluaciones.button_pressed = true
		$BtnPresencaciones.button_pressed = false
		
	preurl = Global.anaUrl+"/EDIT"
	
	dir = DirAccess.open( Global.basedir + "/" + Global.JsonGDD.folders.documentos)
		
	for nivel in Global.JsonGDD.Niveles:
		print(nivel.nombre)
		
		var unidades = Global.JsonGDD.Unidad
		var colores = Global.JsonGDD.Color
	
		var conjutnounidades = {}
		var iteratorunidad = 0
		for tomo in nivel.tomos:
			for unidad in tomo.unidades:
				
				var unidaddict = {"presentaciones":[],"evaluaciones":[]}
				unidaddict.color = colores[ str(unidades[ str(unidad.unidad_id) ].color_id) ]
				
				var subdir = DirAccess.open( dir.get_current_dir() + "/" + nivel.sigla + "/" + tomo.sigla )
				var index = 0
				for press in unidad.presentaciones:
					if subdir.file_exists( nivel.sigla + "-" + tomo.sigla + "-" + press.sigla +"."+ press.extension ):
						var presentacion = {}
						presentacion.nombre = press.nombre
						presentacion.location = subdir.get_current_dir() + "/" +  nivel.sigla + "-" + tomo.sigla + "-" + press.sigla +"."+ press.extension
						unidaddict.presentaciones.append(presentacion)
					index += 1
					
				var index2 = 0
				for eval in unidad.evaluaciones:
					if subdir.file_exists(nivel.sigla + "-" + tomo.sigla + "-" + eval.sigla +"."+ eval.extension):
						var evaluacion = {}
						evaluacion.nombre = eval.nombre
						evaluacion.location = subdir.get_current_dir() + "/" +  nivel.sigla + "-" + tomo.sigla + "-" + eval.sigla +"."+ eval.extension
						unidaddict.evaluaciones.append(evaluacion) 
					index2 += 1
				iteratorunidad+= 1
				conjutnounidades[   unidades[str(unidad.unidad_id)].nombre  ] = unidaddict
			
		cursos.append(conjutnounidades)
	
	print("cursos")
	print(cursos)
	
	
	prepareDocuScreen()
	
	if Global.online:
		Global.askanarenquest(preurl + ":" + choice,[],"{}" ) #enviaranalitica 


func _on_btn_presencaciones_pressed():
	$BtnEvaluaciones.button_pressed = false
	choice = "presentaciones"
	cleanAndPrepare()


func _on_btn_evaluaciones_pressed():
	$BtnPresencaciones.button_pressed = false
	choice = "evaluaciones"
	cleanAndPrepare()


func _on_texture_button_pressed():
	$Panel/VBoxContainer/TextureButton2.button_pressed = false
	$Panel/VBoxContainer/TextureButton3.button_pressed = false
	$Panel/VBoxContainer/TextureButton4.button_pressed = false
	$Panel/VBoxContainer/TextureButton5.button_pressed = false
	$Panel/VBoxContainer/TextureButton6.button_pressed = false
	cursoindex = 0
	cleanAndPrepare()

func _on_texture_button_2_pressed():
	$Panel/VBoxContainer/TextureButton.button_pressed = false
	$Panel/VBoxContainer/TextureButton3.button_pressed = false
	$Panel/VBoxContainer/TextureButton4.button_pressed = false
	$Panel/VBoxContainer/TextureButton5.button_pressed = false
	$Panel/VBoxContainer/TextureButton6.button_pressed = false
	cursoindex = 1
	cleanAndPrepare()

func _on_texture_button_3_pressed():
	$Panel/VBoxContainer/TextureButton.button_pressed = false
	$Panel/VBoxContainer/TextureButton2.button_pressed = false
	$Panel/VBoxContainer/TextureButton4.button_pressed = false
	$Panel/VBoxContainer/TextureButton5.button_pressed = false
	$Panel/VBoxContainer/TextureButton6.button_pressed = false
	cursoindex = 2
	cleanAndPrepare()

func _on_texture_button_4_pressed():
	$Panel/VBoxContainer/TextureButton.button_pressed = false
	$Panel/VBoxContainer/TextureButton2.button_pressed = false
	$Panel/VBoxContainer/TextureButton3.button_pressed = false
	$Panel/VBoxContainer/TextureButton5.button_pressed = false
	$Panel/VBoxContainer/TextureButton6.button_pressed = false
	cursoindex = 3
	cleanAndPrepare()

func _on_texture_button_5_pressed():
	$Panel/VBoxContainer/TextureButton.button_pressed = false
	$Panel/VBoxContainer/TextureButton2.button_pressed = false
	$Panel/VBoxContainer/TextureButton3.button_pressed = false
	$Panel/VBoxContainer/TextureButton4.button_pressed = false
	$Panel/VBoxContainer/TextureButton6.button_pressed = false
	cursoindex = 4
	cleanAndPrepare()

func _on_texture_button_6_pressed():
	$Panel/VBoxContainer/TextureButton.button_pressed = false
	$Panel/VBoxContainer/TextureButton2.button_pressed = false
	$Panel/VBoxContainer/TextureButton3.button_pressed = false
	$Panel/VBoxContainer/TextureButton4.button_pressed = false
	$Panel/VBoxContainer/TextureButton5.button_pressed = false
	cursoindex = 5
	cleanAndPrepare()

func cleanAndPrepare():
	print("clean and prepare " + choice)
	$Panel/Presentaciones.visible = true
	$Panel/ItemsEval.visible = true
	
	var allpresen = $Panel/Presentaciones/GridContainer.get_children()
	var alleval = $Panel/ItemsEval/GridContainer.get_children()
		
	for prestodel in allpresen:
		prestodel.queue_free()
		
	for evaltodel in alleval:
		evaltodel.queue_free()
	
	prepareDocuScreen()
	
func prepareDocuScreen():
	print("armar")

	print( cursos[ cursoindex ] )
	print("ahora")
	for unidadkey in cursos[ cursoindex ].keys():
		var unidadamondar = cursos[cursoindex][unidadkey]
		var nombre = unidadkey
		var color = unidadamondar.color
		
		if choice == "presentaciones":
			var unidad_PBtn = unidadP_Btn.instantiate()
			unidad_PBtn.setNameAndColor(nombre,color.hexadecimal)
			
			var iterator = 1
			for pres in unidadamondar.presentaciones:
				unidad_PBtn.setFileLocation(iterator,pres.location,pres.nombre )
				iterator += 1
				
			$Panel/Presentaciones/GridContainer.add_child(unidad_PBtn)


		elif choice == "evaluaciones":
			var unidad_EBtn = unidadE_Btn.instantiate()
			unidad_EBtn.setNameAndColor(nombre,color.hexadecimal)
			
			
			var iterator = 1
			for eval in unidadamondar.evaluaciones:
				unidad_EBtn.setFileLocation(iterator, eval.location ,eval.nombre)
				iterator += 1
			
			$Panel/ItemsEval/GridContainer.add_child(unidad_EBtn)
			
	print("finalmente Choice " + str(choice))
	setVisibility()

func setVisibility():
	if choice == "presentaciones":
		$Panel/Presentaciones.visible = true
		$Panel/ItemsEval.visible = false
	elif choice == "evaluaciones":
		$Panel/Presentaciones.visible = false
		$Panel/ItemsEval.visible = true
