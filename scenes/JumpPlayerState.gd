class_name JumpPlayerState
extends state

var player:CharacterBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func enter():
	player = get_parent().owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	
	if !player.is_on_floor() and player.velocity.y < 0:
		transition.emit('FallPlayerState')
		return
	
