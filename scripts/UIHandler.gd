extends Node

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var game_menu = get_parent().get_node("GameMenu")
		game_menu.visible = !game_menu.visible
		get_tree().paused = !get_tree().paused