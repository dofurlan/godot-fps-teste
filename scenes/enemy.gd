extends CharacterBody3D

var target:Node3D
@export var speed:int = 2

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if position.y <= -100:
		print('Cai')
		queue_free()
		return
	
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = Vector3(target.position.x, 0, target.position.z) - position
	direction = direction.normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func hit():
	print('morri')
	queue_free()
