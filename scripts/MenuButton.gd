extends Button


func _on_MenuButton_pressed():
	$ButtonSound.pitch_scale = 0.8
	$ButtonSound.play()


func _on_MenuButton_mouse_entered():
	$ButtonSound.pitch_scale = 1	
	$ButtonSound.play()
