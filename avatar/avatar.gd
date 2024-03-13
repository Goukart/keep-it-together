class_name Avatar
extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
const SENSITIVITY = 0.003

const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var list = $Head/List

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	list.visible = false
	list.translate(Vector3(0, -2, 0))

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(60))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("sprint") and is_on_floor():
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# ToDo: seems not very efficient to check it all the time?
	if Input.is_action_pressed("showList"):
		if list.visible == false:
			list.visible = true
			list.translate(Vector3(0, 2, 0))
	elif Input.is_action_just_released("showList"):
		list.visible = false
		list.translate(Vector3(0, -2, 0))

	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		var motion_vector = velocity
		motion_vector.x = direction.x * speed
		motion_vector.z = direction.z * speed
		if direction:
			velocity.z = direction.z * speed
			velocity.x = direction.x * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
