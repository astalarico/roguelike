extends CharacterBody2D

@onready var ray = $RayCast2D
signal update_world 
var move_to
var player_path : PackedVector2Array = []

func _unhandled_input(event)->void:
	var mouse_pos = get_viewport().get_mouse_position()
	var tile_pos = state.world.local_to_map(mouse_pos)
	var tile_cell_at_mouse_pos = state.world.get_cell_tile_data(0, tile_pos)

	if event is InputEventMouseButton and ! event.pressed:
	
		print( event )
		#print("Mouse Click/Unclick at: ", event.position)
		print("player path", player_path)
		player_path = player_path.slice(1)
		if player_path.size():
			for point in player_path:
				await get_tree().create_timer(.15).timeout	
				self.position = point
				emit_signal("update_world")
				print("move enemy too", point)
		
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		#print( Vector2i(event.position ) / 16)

		
		state.world.clear_layer(1)
		if( state.astar_grid.is_in_boundsv( Vector2i(event.position ) / 16) ):
			player_path   = state.astar_grid.get_point_path( Vector2i(self.get('position').x , self.get('position').y) / state.GRID_CELL_SIZE, Vector2i(event.position ) / 16)
			if player_path.size():
				move_to = player_path[player_path.size() - 1 ] 
				
			for point in player_path:
				var next_move        = point / 16;
				var move_difference  = ( Vector2(next_move) - self.position / 16  ) * 16
				#print(next_move)
				var tile_cell = state.world.get_cell_tile_data(1, next_move)
				state.world.set_cell(1,next_move,0,Vector2(36,12))
	
				
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
		#print( nodeObj.get('position') )
		

func _ready()->void:
	#emit_signal("update_world")
	
	pass
