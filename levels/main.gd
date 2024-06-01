extends Node3D

@export var TEMPO_MAXIMO_TIMEOUT:float = 5

var inimigo:PackedScene = load("res://scenes/enemy.tscn")

var limite_X:int
var limite_Y:int
var limite_Z:int

func _ready():
	var meshSize = $NavigationRegion3D/floor.mesh.size
	
	limite_X = meshSize.x / 2 - 3
	limite_Z = meshSize.z / 2 - 3
	
	limite_Y =  meshSize.y 
		
func _on_mobtimer_timeout():
	var novo_timeout:float = randf_range(0.0,TEMPO_MAXIMO_TIMEOUT)
	
	var newInimigo = inimigo.instantiate()
	newInimigo.target = $player
	
	var nodes = get_children()
	var tentativa:int = 1
	while(true):
		var pos_X:int = randi_range(-limite_X,limite_X)
		var pos_Z:int = randi_range(-limite_Z,limite_Z)
		
		var posicaoInimigo:Vector3 = Vector3(pos_X,limite_Y,pos_Z)
		
		if !colidiu(nodes,posicaoInimigo):
			break
		
		if tentativa >= 3:
			print("Desistir")
			break
			
		tentativa += 1
		print('Tentar de novo: %s' % tentativa)
	
	$"mob-timer".wait_time =  novo_timeout

func colidiu(nodes:Array[Node],posicaoInimigo:Vector3) -> bool:

	var newInimigo = inimigo.instantiate()
	newInimigo.target = $player
	newInimigo.position = posicaoInimigo
	add_child(newInimigo)
	var newInimigo_mesh:MeshInstance3D = newInimigo.get_child(1)
	var newInimigo_aabb:AABB = newInimigo_mesh.get_aabb()

	for node in nodes:
		for child_node in node.get_children():
			if not 'mesh' in child_node:
				continue
			
			if not child_node.mesh.has_method('get_aabb'):
				continue
			
			#if child_node.name == 'floor':
				#continue
			
			#var child_node_aabb: AABB = (newInimigo.global_transform.affine_inverse() * child_node.global_transform).xform(child_node.mesh.get_aabb())
			var child_node_aabb: AABB = child_node.mesh.get_aabb()

			if ((child_node.global_transform.affine_inverse() * newInimigo.global_transform)*newInimigo_aabb).intersects(child_node_aabb):
				newInimigo.queue_free()
				return true

	return false
