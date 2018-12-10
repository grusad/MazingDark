extends Node

onready var monster = $Monster
onready var map = $GridMap
onready var player = $Player



func _ready():
	monster.set_map(map)
	monster.set_target(player)
	
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
	
	