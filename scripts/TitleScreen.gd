extends Spatial

export (PackedScene) var level_scene

onready var fade = $CanvasLayer/ColorRect/Fade
onready var anim_player = $AnimationPlayer



func _ready():
	fade.fade_in()

func _on_Start_pressed():
	
	fade.fade_out()
	fade.connect("fade_finished", self, "on_fade_finished")
	anim_player.play("fade_out")

func _on_Exit_pressed():
	get_tree().quit()
	
func on_fade_finished(anim_name):
	get_tree().change_scene_to(level_scene)