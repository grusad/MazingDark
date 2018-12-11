extends Spatial

func _ready():

	
	for button in $CanvasLayer/Control/Menu/CenterRow/Buttons.get_children():
		button.connect("mouse_entered", self, "on_button_mouse_entetered")

	
	
	
func on_button_mouse_entetered():
	$ButtonSound.play()
		