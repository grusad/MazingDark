extends ColorRect

onready var anim_player = $AnimationPlayer

export (float) var playback_speed = 1

signal fade_finished

func _ready():
	anim_player.playback_speed = playback_speed

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished", anim_name)
	
func fade_in():
	anim_player.play("fade_in")

func fade_out():
	anim_player.play("fade_out")
