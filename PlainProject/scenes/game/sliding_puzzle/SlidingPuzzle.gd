extends Node2D

signal completed()

const OVERLAY_COLOR = 'bbffbb'


export (int) var tiles_per_dimension = 4
export (Vector2) var tile_size = Vector2.ONE * 64


var tiles = [[]]
var empty_pos = Vector2()
var num_tiles = 16


func _ready():
	randomize()
	num_tiles = $Tiles.get_child_count()
	setup_tiles()


func setup_tiles() -> void:
	$CompletedSprite.hide()
	
	for i in range(num_tiles):
		var order_pos = idx_to_tile_pos(i)
		var tile = $Tiles.get_child(i)
		tile.setup(order_pos, tile_size)
		var _error = tile.connect("should_be_moved", self, "_on_PuzzleTile_should_be_moved")
	
	# Shuffle the tiles
	shuffle_tiles()
	
	# Bottom right should be empty
	var new_empty_pos = idx_to_tile_pos(num_tiles - 1)
	for tile in $Tiles.get_children():
		if tile.curr_pos == new_empty_pos:
			tile.set_is_empty(true)
			change_empty_pos_to(new_empty_pos, false)


func shuffle_tiles() -> void:
	# Fisher yates shuffle (prevent ordered tiles)
	while(are_tiles_in_order()):
		for source_idx in range(num_tiles):
			var source_tile = $Tiles.get_child(source_idx)
			
			var target_idx = randi() % num_tiles
			var target_tile = $Tiles.get_child(target_idx)
			var temp_pos = source_tile.curr_pos
			
			source_tile.move_to_tile(target_tile.curr_pos, tile_size, true)
			target_tile.move_to_tile(temp_pos, tile_size, true)


func change_empty_pos_to(_to : Vector2, _emit_completed : bool = true) -> void:
	empty_pos = _to
	
	var valid_offsets = [empty_pos + Vector2.LEFT, empty_pos + Vector2.RIGHT, \
		empty_pos + Vector2.UP, empty_pos + Vector2.DOWN] 
	
	for i in range(num_tiles):
		var tile = $Tiles.get_child(i)
		tile.set_can_be_moved(tile.curr_pos in valid_offsets)
	
	if are_tiles_in_order() and _emit_completed:
		complete_puzzle()


func complete_puzzle():
	for i in range(num_tiles):
		$Tiles.get_child(i).disable_tile_on_complete()
	$CompletedSprite.show()
	emit_signal("completed")


func are_tiles_in_order() -> bool:
	for i in range(num_tiles):
		if !$Tiles.get_child(i).is_in_order():
			return false
	return true


# Allows input event behind a mouse filter
func move_tile_at_position(_pos : Vector2):
	var click_tile_pos = (_pos / tile_size).floor()
	for tile in $Tiles.get_children():
		if tile.curr_pos == click_tile_pos:
			tile.move_if_allowed()



func _on_PuzzleTile_should_be_moved(_tile : Node) -> void:
	if _tile:
		var new_empty_pos = _tile.curr_pos
		_tile.move_to_tile(empty_pos, tile_size, false)
		change_empty_pos_to(new_empty_pos)


func idx_to_tile_pos(_idx : int) -> Vector2:
	return Vector2(_idx % tiles_per_dimension, int(_idx / tiles_per_dimension) % tiles_per_dimension)


func tile_pos_to_idx(_tile_pos : Vector2) -> int:
	return int(_tile_pos.y) * tiles_per_dimension + int(_tile_pos.x)


func center() -> void:
	position = -tile_size * (tiles_per_dimension / 2.0) * scale


func get_rect_size() -> Vector2:
	return tile_size * tiles_per_dimension * scale
