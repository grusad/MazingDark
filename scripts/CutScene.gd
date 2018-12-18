extends Control

export (float) var length = 5
export (PackedScene) var next_scene = null


func _ready():


	$Fade.fade_in()
	
	
	$Fade.connect("fade_finished", self, "on_fade_finished")
	

func on_fade_finished(current_animation):
	if current_animation == "fade_in":
		$Timer.wait_time = length
		$Timer.connect("timeout", self, "on_timer_timeout")
		$Timer.one_shot = true
		$Timer.start()
	else:
		if name == "WinScene":
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
			get_tree().change_scene("res://scenes/ui/TitleScreen.tscn")
			return
		get_tree().change_scene_to(next_scene)
	
	
	
func on_timer_timeout():
	$Fade.fade_out()


