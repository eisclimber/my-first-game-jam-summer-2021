extends Area2D
class_name PuzzleTile

signal should_be_moved(tile)

const OVERLAY_COLOR = '99ff99'

export (bool) var can_be_moved = false setget set_can_be_moved
export (bool) var is_empty = false
export (float) var move_speed = 0.3

var order_pos : Vector2 = Vector2()
var curr_pos : Vector2 = Vector2()


func setup(_order_pos : Vector2, _tile_size : Vector2) -> void:
	# Set position
	position = _order_pos * _tile_size + _tile_size / 2
	order_pos = _order_pos
	curr_pos = _order_pos
	
	# Rescale texture
	if $Sprite.texture:
		var texture_size = $Sprite.texture.get_size()
		$Sprite.scale = $Sprite.scale / texture_size * _tile_size
	
	# Set Collision size
	$Collision.shape.extents = _tile_size / 2


func _input_event(_viewport: Object, _event : InputEvent, _shape_idx : int) -> void:
	if !Engine.is_editor_hint() and can_be_moved and _event is InputEventMouseButton \
			and _event.pressed and _event.button_index == BUTTON_LEFT:
		emit_signal("should_be_moved", self)


func move_to_tile(_tile_pos : Vector2, _tile_size : Vector2, _instant : bool = false) -> void:
	curr_pos = _tile_pos
	var target_pos = _tile_pos * _tile_size + _tile_size / 2
	
	if !_instant:
		$Tween.interpolate_property(self, "position", position, target_pos, move_speed)
		$Tween.start()
	else:
		position = target_pos


func set_can_be_moved(_can_be_moved : bool) -> void:
	can_be_moved = _can_be_moved
	$Collision.disabled = !_can_be_moved
	if can_be_moved:
		modulate = Color(OVERLAY_COLOR)
	else:
		modulate = Color.white


func is_order_tile_pos(_tile_pos : Vector2) -> bool:
	return order_pos == _tile_pos


func set_is_empty(_is_empty : bool) -> void:
	is_empty = _is_empty
	# Hide if it is the goal and disable collision
	$Collision.disabled = _is_empty
	visible = !_is_empty
