extends Node3D

@export var TEMPO_MAXIMO_TIMEOUT:float = 5.0

var inimigo:PackedScene = load("res://scenes/enemy.tscn")

var limite_X:int
var limite_Y:int
var limite_Z:int

func _ready():
	var meshSize = $floor.mesh.size
	
	limite_X = meshSize.x / 2 - 3
	limite_Z = meshSize.z / 2 - 3
	
	limite_Y =  meshSize.y 
		
func _on_mobtimer_timeout():
	var time = Time.get_time_dict_from_system()
	var novo_timeout:float = randf_range(0.0,TEMPO_MAXIMO_TIMEOUT)
	
	var newInimigo = inimigo.instantiate()
	newInimigo.target = $player
	
	var nodes = get_children()
	
	while(true):
		var pos_X:int = randi_range(-limite_X,limite_X)
		var pos_Z:int = randi_range(-limite_Z,limite_Z)
		
		var posicaoInimigo:Vector3 = Vector3(pos_X,limite_Y,pos_Z)
		newInimigo.position = posicaoInimigo
		
		var nodesColisao:Array = []
		for node in nodes:
			for child_node in node.get_children():
				if not 'mesh' in child_node:
					continue
				
				if not child_node.mesh.has_method('get_transformed_aabb'):
					continue

				if child_node.mesh.get_transformed_aabb().intersects(newInimigo.mesh.get_transformed_aabb()):
					nodesColisao.append(child_node)
					break
				else:
					print('Again')
		
			if nodesColisao.size() > 0:
				break
		
		if nodesColisao.size() == 0:
			print('%02d:%02d - Spawn at %dx%d - em %fs' % [time.minute, time.second, pos_X, pos_Z, novo_timeout])
			break
		
		print('Tentar de novo')
		
	add_child(newInimigo)
	
	$"mob-timer".wait_time =  novo_timeout
