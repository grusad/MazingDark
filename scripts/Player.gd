extends KinematicBody

onready var walking_audio_stream = $Walking;

var vel = Vector3()
const MAX_WALK_SPEED = 5
const MAX_SPRINT_SPEED = 10
const JUMP_SPEED = 18
const ACCEL= 4.5

signal dead

var CAM_SHAKE = 0.01

var dir = Vector3()
var is_walking = false
var is_dying = false

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05

var collected_orbs = 0

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	
	if is_dying:
		CAM_SHAKE += delta * 0.02
		$Rotation_Helper/Camera.v_offset = rand_range(-1, 1) * CAM_SHAKE
		$Rotation_Helper/Camera.h_offset = rand_range(-1, 1) * CAM_SHAKE
		return
	
	process_input(delta)
	process_movement(delta)
	
	translation.y = 1

func process_input(delta):
	
	

    # ----------------------------------
    # Walking
	
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	
	
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	
	
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x = 1
	
	
	
		
	if input_movement_vector.x != 0 or input_movement_vector.y != 0:
		is_walking = true
	else:
		is_walking = false
		
		
		
	input_movement_vector = input_movement_vector.normalized()
	dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
	dir += cam_xform.basis.x.normalized() * input_movement_vector.x
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			

func process_movement(delta):
	
	
	var TARGET_SPEED = MAX_WALK_SPEED
	
	
	dir.y = 0
	dir = dir.normalized()
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= TARGET_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	
	
	
	if is_walking and !walking_audio_stream.playing:
		walking_audio_stream.play()

	if !is_walking and walking_audio_stream.playing:
		walking_audio_stream.stop()
	
	
	
	
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and event.is_pressed():
		$UI/GameMenu.show()
		get_tree().paused = true
		print("paused")
		
	
	if is_dying:
		return
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
		


func _on_HitBox_area_entered(area):
	if area.is_in_group("orb"):
		collected_orbs += 1
		$UI/Control/OrbLabel.text = "Orbs " + str(collected_orbs) + "/5"
		area.collect()
		

func kill():
	#get_tree().reload_current_scene()
	is_dying = true
	walking_audio_stream.stop()
	$Breathing.stop()
	emit_signal("dead")

