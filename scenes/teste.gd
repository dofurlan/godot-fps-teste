extends Node3D
 
@onready var start = $start
@onready var finnish = $finnish

func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE):
	point(pos1,0.05,color)
	
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	
	get_tree().get_root().add_child.call_deferred(mesh_instance)

	return

func point(pos: Vector3, radius = 0.05, color = Color.WHITE_SMOKE):
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos

	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
	sphere_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child.call_deferred(mesh_instance)
	return 

func _ready():
	
	line(start.position,finnish.position,Color.REBECCA_PURPLE)
	
	print(h_cost(start.position,finnish.position))

	
	var path:Array[Vector3] = a_star_path(start.position,finnish.position)
	
	for index in range(path.size()-2):
		line(path[index],path[index+1],Color.GREEN)

		
func a_star_path(pos_start:Vector3,pos_finnish:Vector3) -> Array[Vector3]:
	var node_start:path_node = path_node.new(pos_start)
	node_start.g_cost = g_cost(pos_start,node_start.world_position)
	node_start.h_cost = h_cost(node_start.world_position,pos_finnish)
	
	var open:Array[path_node] = [node_start]
	var closed:Array[path_node] = []
	var path:Array[Vector3] = []
	var last_node:path_node = node_start
	
	while(open.size() > 0):
		var node_current:path_node = open[0]
		print_verbose('Começando em %f02' % node_current.f_cost() )
		for node in open:
			if node.f_cost() <= node_current.f_cost():
				if node.h_cost < node_current.h_cost:
					print_verbose('Mudando h_cost de %f02 para %f02 para %02f' % [node_current.h_cost, node.h_cost , node.f_cost()])
					node_current = node

		print_verbose('Escolhido (%s, %s) com %s f_cost' % [node_current.world_position.x,node_current.world_position.z , node_current.f_cost])
		open.erase(node_current)
		closed.append(node_current)
		
		point(node_current.world_position,0.05,Color.CHOCOLATE)
		
		if abs((node_current.world_position - pos_finnish).length()) <= node_current.node_size:
			print_verbose('Custo final %02f' % node_current.parent.f_cost())
			last_node = node_current
			break
		
		for neighbour in node_current.get_neighbours():
			if neighbour.in_array(closed) or !neighbour.walkable:
				continue
				
			var movementCost = node_current.g_cost + g_cost(node_current.world_position,neighbour.world_position)
			var in_open = neighbour.in_array(open)
			
			if !in_open or movementCost < neighbour.g_cost:
				neighbour.g_cost = movementCost
				neighbour.h_cost = h_cost(neighbour.world_position,pos_finnish)
				neighbour.parent = node_current
	
				if !in_open:
					open.append(neighbour)
				
	while(last_node.world_position != pos_start):
		print('Posição (%s, %s) f_cost %2f e %s' % [last_node.world_position.x, last_node.world_position.z, last_node.f_cost(), last_node.walkable])
		path.append(last_node.world_position)
		last_node = last_node.parent

	return path
	
func g_cost(pos1:Vector3,pos2:Vector3):
	#var distX = abs(pos2.x-pos1.x)
	#var distZ = abs(pos2.z-pos1.z)
	#
	#if distX > distZ:
		#return 14 * distZ + 10 * (distX - distZ)
	#
	#return 14 * distX + 10 * (distZ - distX)
	
	return (pos2-pos1).length()
		
func h_cost(pos1:Vector3,pos2:Vector3):
	return g_cost(pos1,pos2)


