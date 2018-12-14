extends Node


onready var monster = $Monster
onready var map = $GridMap
onready var player = $Player
onready var fader = $CanvasLayer/Fade


func _ready():
	
	fader.fade_in()
	
	monster.set_map(map)
	monster.set_target(player)
	
	player.connect("dead", self, "on_player_dead")
	monster.connect("done_killing", self, "on_monster_done_killing")
	
	var cells = map.get_used_cells();
	
	if cells.empty():
		return
	
	var topLeft = cells[0];
	var botRight = cells[cells.size() - 1];
	
	
	var width = topLeft.x + botRight.x
	var depth = topLeft.z + botRight.z
	
	for x in range(width):
		for z in range(depth):
			if map.get_cell_item(x, 0, z) < 0:
				map.set_cell_item(x, -2, z, 1)
	
	

func on_player_dead():
	fader.fade_out()
	
func on_monster_done_killing():
	get_tree().change_scene("res://scenes/ui/DeadScene.tscn")