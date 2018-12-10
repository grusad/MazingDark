extends Area

onready var particle = $MeshInstance/Particles
onready var obtaines_sound = $ObtainedSound
onready var animation_player = $AnimationPlayer

var obtained_sound_done = false
var obtained_animation_done = false

func _process(delta):
	
	print("sound done:", obtained_sound_done)
	print("animation done:", obtained_animation_done)
	
	if obtained_sound_done and obtained_animation_done:
		queue_free()

func collect():
	obtaines_sound.play()
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_finished")
	animation_player.play("obtained")
	


func _on_ObtainedSound_finished():
	obtained_sound_done = true
	
func _on_AnimationPlayer_finished(name):
	if name == "obtained":	
		obtained_animation_done = true
