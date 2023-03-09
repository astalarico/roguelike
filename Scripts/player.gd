extends CharacterBody2D

@onready var ray = $RayCast2D
signal update_world 

func _unhandled_input(event)->void:
	for direction in state.directions:
		if event.is_action_pressed(direction):
			move(direction)
			
			
func move( direction )->void:
	var vector_position = state.directions[direction] * state.GRID_CELL_SIZE
	#print("vector position" + str(self.position))
	ray.target_position = vector_position
	#print("PLAYER VECTOR POSITION FOR RAY CAST " + str(vector_position ))
	ray.force_raycast_update()

	if !ray.is_colliding():
		self.position += vector_position
		emit_signal("update_world" )
	
	else:
		var nodeObj = ray.get_collider();
		if( nodeObj.has_method('_interact')):
			nodeObj.call('_interact', direction)
			
		#print( ray.get_collision_point() )
		print( nodeObj.get('position') )
		

func _ready()->void:
	#emit_signal("update_world")
	
	pass
