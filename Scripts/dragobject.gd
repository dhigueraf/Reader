extends Control

@export var valuetext = "xmm"
@export var valuenumber = 0
@export var texto = ""

var draggable = false
var is_inside_dropbale = false
var dropref = null
var initialPos = position
var offset = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	$txt_cuadriculadas.text = texto


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			print("cliqueado")
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("click"):
			print("cliqueando")
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			print("soltar")
			Global.is_dragging = false
			global_position = initialPos
			#var tween = get_tree().create_tween()

func getvalue():
	return(valuetext + "_" + valuenumber)

func _on_input_cuadriculada_7_value_changed(value):
	valuenumber = value


func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		#$DragableIcon


func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		draggable = false
		#$DragableIcon


func _on_area_2d_area_entered(area):
	print(area.name)


func _on_area_2d_area_exited(area):
	pass # Replace with function body.
