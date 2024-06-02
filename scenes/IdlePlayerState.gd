class_name IdlePlayerState
extends state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player:CharacterBody3D = get_parent().owner
	
	if player.velocity.length() > 0 and player.is_on_floor():
		transition.emit('WalkingPlayerState')
	
