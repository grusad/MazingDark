extends KinematicBody

onready var sight_ray = $SightRay
onready var attack_ray = $AttackRay

var grid_map;
var player;

const MOVE_SPEED = 1.5
const SPRINT_SPEED = 3
var sprint = false

var cur_path = []
var cur_goal = null

func _ready():
	sight_ray.add_exception(self)
	#set_physics_process(false)
	

func _process(delta):
	if sight_ray.is_colliding() and sight_ray.get_collider().is_in_group("player"):
		sprint = true
	else:
		sprint = false
	
	if attack_ray.is_colliding() and attack_ray.get_collider().is_in_group("player"):
		attack_ray.get_collider().kill()
		print("here")

	

func _physics_process(delta):
	
	if player:
		look_at(player.translation, Vector3(0, 1, 0))
	
	cur_path = get_path()
	if cur_path.size() <= 0:
		return
	
	var g = grid_map.map_to_world(cur_path[0].x, cur_path[0].y, cur_path[0].z)
	var offset = g - translation
	if offset.length_squared() < 0.1:
		cur_path.pop_front()
	offset = offset.normalized()
	
	var cur_speed = MOVE_SPEED
	
	if sprint:
		cur_speed = SPRINT_SPEED
	move_and_collide(offset * cur_speed * delta)
	translation.y = 1

func get_path():
	var goal = grid_map.world_to_map(player.translation)
	if cur_goal != null and cur_goal == goal:
		return cur_path
	cur_goal = goal
	var cur = grid_map.world_to_map(translation)
	var path = backtrace(calc_path(goal, cur, 0, null))
	visited = {}
	queue = []
	return path

var visited = {}
var queue = []
func calc_path(goal_coord, cur_coord, depth, parent):
	if cur_coord == goal_coord:
		visited[str(cur_coord)] = parent
		return cur_coord
	if visited.has(str(cur_coord)):
		return null
	if depth > 500:
		print("depth")
		return null
	if grid_map.get_cell_item(cur_coord.x, cur_coord.y, cur_coord.z) >= 0:
		return null
	#print(cur_coord)
	depth += 1
	visited[str(cur_coord)] = parent
	queue.push_back([cur_coord + Vector3(1, 0, 0), cur_coord])
	queue.push_back([cur_coord + Vector3(-1, 0, 0), cur_coord])
	queue.push_back([cur_coord + Vector3(0, 0, -1), cur_coord])
	queue.push_back([cur_coord + Vector3(0, 0, 1), cur_coord])
	while queue.size() > 0:
		var cur = queue.pop_front()
		var res = calc_path(goal_coord, cur[0], depth, cur[1])
		if res != null:
			return res

func backtrace(coord):
	var path = []
	var cur_coord = coord
	while(visited.has(str(cur_coord)) and visited[str(cur_coord)] != null):
		if cur_coord != null:
			path.push_front(cur_coord)
		cur_coord = visited[str(cur_coord)]
	return path
	

func set_target(target):
	self.player = target
	
func set_map(grid_map):
	self.grid_map = grid_map