extends Area

onready var particle = $MeshInstance/Particles
onready var obtaines_sound = $ObtainedSound
onready var animation_player = $AnimationPlayer

var obtained_sound_done = false
var obtained_animation_done = false

var being_collected = false

func _ready():
	particle.emitting = true

func _process(delta):
	
	if obtained_sound_done and obtained_animation_done:
		queue_free()

func collect():
	if being_collected:
		return
	being_collected = true
	obtaines_sound.play()
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_finished")
	animation_player.play("obtained")
	


func _on_ObtainedSound_finished():
	obtained_sound_done = true
	
func _on_AnimationPlayer_finished(name):
	if name == "obtained":	
		obtained_animation_done = true
