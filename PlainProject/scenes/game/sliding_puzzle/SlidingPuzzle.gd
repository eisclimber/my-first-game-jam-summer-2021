extends Node2D

signal completed()

const OVERLAY_COLOR = 'bbffbb'


export (int) var tiles_per_dimension = 4
export (Vector2) var tile_size = Vector2.ONE * 64


var tiles = [[]]
var empty_pos = Vector2()


func _ready():
	randomize()
	setup_tiles()


func setup_tiles() -> void:
	var n = get_child_count()
	for i in range(n):
		var order_pos = idx_to_tile_pos(i)
		get_child(i).setup(order_pos, tile_size)
		var _error = get_child(i).connect("should_be_moved", self, "_on_PuzzleTile_should_be_moved")
	
	# Fisher jates shuffle (prevent ordered tiles)
	while(!tiles_in_order()):
		for i in range(n):
			var new_idx = randi() % n
			move_child(get_child(i), new_idx)
			get_child(i).curr_pos = idx_to_tile_pos(new_idx)
	
	# Bottom right should be empty
	get_child(n - 1).set_is_empty(true)
	change_empty_pos_to(idx_to_tile_pos(n - 1))


func change_empty_pos_to(_to : Vector2) -> void:
	empty_pos = _to
	
	var valid_offsets = [empty_pos + Vector2.LEFT, empty_pos + Vector2.RIGHT, \
		empty_pos + Vector2.UP, empty_pos + Vector2.DOWN] 
	
	for i in get_child_count():
		var tile = get_child(i)
		tile.set_can_be_moved(tile.curr_pos in valid_offsets)


func tiles_in_order() -> bool:
	for y in tiles.size():
		for x in tiles[y].size():
			if !tiles[y][x].is_order_tile_pos(Vector2(x, y)):
				return false
	return true


func _on_PuzzleTile_should_be_moved(_tile : Node) -> void:
	if _tile:
		var new_empty_pos = _tile.curr_pos
		_tile.move_to_tile(empty_pos, tile_size, false)
		change_empty_pos_to(new_empty_pos)


func idx_to_tile_pos(_idx : int) -> Vector2:
	return Vector2(_idx % tiles_per_dimension, int(_idx / tiles_per_dimension) % tiles_per_dimension)


func tile_pos_to_idx(_tile_pos : Vector2) -> int:
	return _tile_pos.y * tiles_per_dimension + _tile_pos.x


func get_dimensions() -> Vector2:
	return tile_size * tiles_per_dimension
