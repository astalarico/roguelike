extends Node

const GRID_CELL_SIZE = 16
var directions = {
	'ui_up' : Vector2.UP,
	'ui_down' : Vector2.DOWN,
	'ui_right' : Vector2.RIGHT,
	'ui_left' : Vector2.LEFT
}

@onready var player = get_tree().get_root().get_node('Game/Player')
@onready var world = get_tree().get_root().get_node('Game/SpaceShip')
@onready var path_line = get_tree().get_root().get_node('Game/SpaceShip/Line2D')

var astar_grid = AStarGrid2D.new()
var world_tiles
var world_rect

# Called when the node enters the scene tree for the first time.
func _ready():
	path_line.width = 1.0
	world_tiles = world.get_used_cells(0)
	world_rect = world.get_used_rect()
	astar_grid.size = Vector2i(world_rect.size)
	astar_grid.default_compute_heuristic = 1
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = 1
	astar_grid.update()
		
	for tile in world_tiles:
		var surrounding_cells = world.get_surrounding_cells( tile )
		var tile_data = world.get_cell_tile_data( 0, tile )
		var has_collision = tile_data.get_collision_polygons_count( 0 )

		if has_collision :
			astar_grid.set_point_solid( tile)
