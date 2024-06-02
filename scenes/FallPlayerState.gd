class_name FallPlayerState
extends state

var player:CharacterBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func enter():
	player = get_parent().owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	
	if !player.is_on_floor():
		return
	
	if player.velocity.length() == 0.0:
		transition.emit('IdlePlayerState')
		return
	
	if player.velocity.length() > 0.0:
		transition.emit('WalkingPlayerState')
		return

	
