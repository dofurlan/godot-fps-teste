class_name IdlePlayerState
extends state

var player:CharacterBody3D
var animationPlayer:AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func enter():
	player = get_parent().owner
	for child in player.get_children():
		if child is AnimationPlayer:
			animationPlayer = child
			break
			
	animationPlayer.pause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		transition.emit('JumpPlayerState')
		return
	
	if player.velocity.length() > 0.0 and player.is_on_floor():
		transition.emit('WalkingPlayerState')
		return
	
