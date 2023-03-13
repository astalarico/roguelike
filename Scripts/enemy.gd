extends CharacterBody2D

var navigation_server = NavigationServer2D
@onready var ray = $RayCast2D

func _ready():
	state.player.update_world.connect(update)
	
func update():
	await get_tree().process_frame
	state.path_line.clear_points()
	var player_position  = state.player.get('position')
	var player_vector    = Vector2i(player_position.x, player_position.y) / state.GRID_CELL_SIZE
	@warning_ignore("narrowing_conversion")
	var current_position = Vector2i(self.position.x, self.position.y) / state.GRID_CELL_SIZE
	var path_to_player   = state.astar_grid.get_point_path( current_position , player_vector)
	
	for point in path_to_player:
		state.path_line.add_point( point  )
		
	var next_move        = path_to_player[1];
	var move_difference  = Vector2(next_move) - self.position
	ray.target_position = move_difference
	ray.force_raycast_update()
	
	if( ! ray.is_colliding() ):
		self.position += Vector2(move_difference);
	else:
		print(Vector2i(ray.get_collision_point()) / state.GRID_CELL_SIZE)
