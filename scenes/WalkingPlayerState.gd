class_name WalkingPlayerState
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
			
	animationPlayer.play('Walking')
	
func update(delta):
	
	 #Handle jump.
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		transition.emit('JumpPlayerState')
		return
	
	if player.velocity.length() == 0.0:
		#print(player.velocity) 
		transition.emit('IdlePlayerState')
		return
		
	set_animation_speed(player.velocity.length())	
	
	
func set_animation_speed(speed:float):
	var alpha = remap(speed,0.0,player.SPEED,0.0,1.0)
	animationPlayer.speed_scale = lerp(0.0,2.2,alpha)
