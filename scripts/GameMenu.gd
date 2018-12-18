extends Control


export (PackedScene) var menu_scene = null

func open():
	visible = true
	get_tree().paused = true
	
func close():
	visible = false
	get_tree().paused = false

func _on_Resume_pressed():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	close()