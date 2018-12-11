extends ColorRect

onready var anim_player = $AnimationPlayer

signal fade_finished

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished", anim_name)
	
func fade_in():
	anim_player.play("fade_in")

func fade_out():
	anim_player.play("fade_out")
