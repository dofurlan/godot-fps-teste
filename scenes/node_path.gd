extends Node

class_name path_node

var parent:path_node

var node_size:float = 0.5

var g_cost:float = 0
var h_cost:float = 0

var world_position:Vector3
var walkable:bool

func _init(position):
	world_position = position
	
	var area_3d = Area3D.new()
	

	area_3d.position = world_position  # Set the position
	area_3d.scale = (Vector3(10, 10, 10) * node_size)  # Set the scale
	area_3d.monitoring = true
	area_3d.monitorable = true

	area_3d.set_collision_layer_value(1,true)
	area_3d.set_collision_layer_value(2,true)
	area_3d.set_collision_layer_value(3,true)
	area_3d.set_collision_layer_value(4,true)
	
	area_3d.set_collision_mask_value(1,true)
	area_3d.set_collision_mask_value(2,true)
	area_3d.set_collision_mask_value(3,true)
	area_3d.set_collision_mask_value(4,true)
	
	walkable = !(area_3d.has_overlapping_bodies() or area_3d.has_overlapping_areas())

	
func f_cost():
	return g_cost + h_cost


func get_neighbours() -> Array[path_node]:
	var neighbours:Array[path_node] = []
	var y:int = 0
	for x:int in range(-1,2,1):
		#for y:int in range(-1,2,1):
			for z:int in range(-1,2,1):
				if x == 0 and y == 0 and z == 0:
					continue
				neighbours.append(path_node.new(world_position + Vector3(x*node_size,y*node_size,z*node_size)))
	
	return neighbours


func in_array(node_array:Array[path_node]) -> bool:
	for node in node_array:
		if node.world_position == world_position:
			return true
	
	return false
	
	

	
