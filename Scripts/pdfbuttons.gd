extends Control


func _on_TextureButton_pressed():
	visible = false;


func _process(delta):
	$LoadingSpr.rotate(0.1 * delta)


func activateLoading():
	print("LOADING...")
	$LoadingSpr.visible = true
