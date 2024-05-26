extends CharacterBody3D

@export var _spawn_position:Vector3
@export var _spawn_speed:float = 50
@export var _spawn_rotation:Vector3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	position = _spawn_position
	rotation = _spawn_rotation
	velocity = -transform.basis.z .normalized() * _spawn_speed

func _physics_process(delta):
	velocity.y -= gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collision_node =  collision.get_collider()
		var collision_node_groups =  collision_node.get_groups()
		
		if 'enemy' in collision_node_groups:
			print('inimigo')
			collision_node.hit()
			queue_free()
		else:
			print('boing')
			velocity = velocity.bounce(collision.get_normal())


func _on_timer_timeout():
	queue_free()
