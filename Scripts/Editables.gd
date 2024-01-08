extends Control
var listaunidades = []

var unidadP_Btn = preload("res://Objetos/unidad_presentaciones.tscn")
var unidadE_Btn = preload("res://Objetos/unidad_evaluaciones.tscn")

var dir 

# Called when the node enters the scene tree for the first time.
func _ready():
	var unidades = Global.JsonGDD.unidades
	var colores = Global.JsonGDD.colores
	#print(global.tomo)
	
	$superiorButtons.setLabelCurso(Global.nivel.nombre)
	print("tomos")
	for tomonum in Global.nivel.tomos.keys():
		var tomo = Global.nivel.tomos[tomonum]
		print("tomo:")
		print(tomo)
		for unidadnum in tomo.unidades.keys():
			var unitoadd = tomo.unidades[unidadnum]
			unitoadd.color = colores[(unidades[str(unidadnum)]).color]
			unitoadd.tomo = tomo.sigla
			listaunidades.append(unitoadd)
	
	print("unidades")
	for unidad in listaunidades:
		print(unidad.nombre)
		print(unidad)

	dir = DirAccess.open( Global.basedir + "/" + Global.JsonGDD.folders.documentos + "/" + Global.nivel.sigla )

	hacerllenados()
	if Global.online:
		var evento =  {
			"name": "Editables del nivel",
				"params": {
				  "nivel": Global.nivel.sigla
				}
		  }

		print("hacer request analitic GDD")
		await Global.sendevent([evento]) #enviaranalitica
		#await Global.askanarenquest(Global.anaUrl+"/GDD/CURSO:"+Global.nivel.sigla+"/EDIT",[],[]) #enviaranalitica 
	
func hacerllenados():
	await llenarPresentaciones()
	await llenarEvaluaciones()
	$Panel/ItemsEval.visible = false

func _on_btn_presencaciones_pressed():
	$BtnEvaluaciones.button_pressed = false
	$Panel/Presentaciones.visible = true
	$Panel/ItemsEval.visible = false


func _on_btn_evaluaciones_pressed():
	$BtnPresencaciones.button_pressed = false
	$Panel/Presentaciones.visible = false
	$Panel/ItemsEval.visible = true


func llenarPresentaciones():	
	print("presentaciones")
	for unidad in listaunidades:
		var unidad_PBtn = unidadP_Btn.instantiate()
		unidad_PBtn.setNameAndColor(unidad.nombre,unidad.color.hex)
		
		print("unidad:")
		print(unidad)
		
		if dir.dir_exists(unidad.tomo):
			var subdir = DirAccess.open( dir.get_current_dir() + "/" + unidad.tomo )
			var iterator = 1
			print("uni")
			print(unidad)
			
			var presentaciones = []
			for prennum in unidad.presentaciones.keys():
				presentaciones.append(unidad.presentaciones[str(prennum)])
			
			for pres in presentaciones:
				if subdir.file_exists(Global.nivel.sigla +"-"+unidad.tomo+"-"+pres.sigla +"."+ pres.extension):
					print("econttrada")
					unidad_PBtn.setFileLocation(iterator, subdir.get_current_dir() + "/" + Global.nivel.sigla +"-"+unidad.tomo+"-"+pres.sigla +"."+ pres.extension ,pres.nombre)
				iterator += 1
		
		$Panel/Presentaciones/GridContainer.add_child(unidad_PBtn)


func llenarEvaluaciones():	
	print("evaluaciones")
	for unidad in listaunidades:
		var unidad_EBtn = unidadE_Btn.instantiate()
		unidad_EBtn.setNameAndColor(unidad.nombre,unidad.color.hex)
		
		print("unidad:")
		print(unidad)
		
		
		
		if dir.dir_exists(unidad.tomo):
			var subdir = DirAccess.open( dir.get_current_dir() + "/" + unidad.tomo )
			var iterator = 1
			
			var evaluaciones = []
			for evalnum in unidad.evaluaciones.keys():
				evaluaciones.append(unidad.evaluaciones[str(evalnum)])
			
			for eval in evaluaciones:
				if subdir.file_exists(Global.nivel.sigla +"-"+unidad.tomo+"-"+eval.sigla +"."+ eval.extension):
					print("econttrada")
					unidad_EBtn.setFileLocation(iterator, subdir.get_current_dir() + "/" + Global.nivel.sigla +"-"+unidad.tomo+"-"+ eval.sigla +"."+ eval.extension ,eval.nombre)
				iterator += 1
		
		$Panel/ItemsEval/GridContainer.add_child(unidad_EBtn)
