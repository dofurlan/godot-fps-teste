extends CharacterBody3D

var projectile_scene:PackedScene

@export var SPEED:float = 10
@export var JUMP_VELOCITY:float = 5

@export var MOUSE_SENSITIVITY : float = 0.5
@export var CAMERA_LOWER_LIMIT := deg_to_rad(-90.0)
@export var CAMERA_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D

@export var ACCELERATION:float = 0.1
@export var DECELERATION:float = 0.4

var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _update_camera(delta):
	
	# Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, CAMERA_LOWER_LIMIT, CAMERA_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0

	_rotation_input = 0.0
	_tilt_input = 0.0
	
func _shortcut_input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("projectile_1"):
		projectile_scene = load("res://scenes/projectile.tscn")
	elif event.is_action_pressed("projectile_2"):
		projectile_scene = load("res://scenes/projectile2.tscn")
	
func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		
	if event.is_action_pressed("shoot") and projectile_scene != null:
		var projectile = projectile_scene.instantiate()
		projectile._spawn_position = $"camera-node/Camera3D/shooting-anchor".global_position
		projectile._spawn_rotation = $"camera-node/Camera3D/shooting-anchor".global_rotation
		
		get_parent().add_child(projectile)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	_update_camera(delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED,ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * SPEED,ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

		#var vel = Vector2(velocity.x,velocity.z)
		#var temp = move_toward(Vector2(velocity.x,velocity.z).length(), 0, DECELERATION)
		#velocity.x = vel.normalized().x * temp
		#velocity.z = vel.normalized().y * temp

	move_and_slide()

