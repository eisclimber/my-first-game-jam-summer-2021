tool
extends CmdWindow
class_name SlidingPuzzleWindow

const COIN_GENERATED_TEXT = "Coin generated."

export (Texture) var coin_texture = null
export (Vector2) var coin_preview_size = Vector2.ONE * 64
export (Vector2) var content_border_size = Vector2.ONE * 60
export (bool) var yields_coin = false


onready var sliding_puzzle = $Margin/ContentVBox/ContentControl/ContentMargin/CenterContainer/CenterControl/SlidingPuzzle


func _ready():
	sliding_puzzle.center()
	
	var content_rect_size = sliding_puzzle.get_rect_size() + content_border_size
	rect_min_size = content_rect_size
	rect_size = content_rect_size


func _gui_input(_event : InputEvent) -> void:
	if _event is InputEventMouseButton and _event.button_index == BUTTON_LEFT and _event.pressed:
		# Only allow puzzle input if in front
		if is_in_front():
			var relative_click_pos = _event.global_position - sliding_puzzle.global_position
			sliding_puzzle.move_tile_at_position(relative_click_pos)
		else:
			# If not in front, request movement
			emit_signal("move_to_front_requested", self)


func _on_SlidingPuzzle_completed() -> void:
	yields_coin = true
	set_text_content(COIN_GENERATED_TEXT)


func is_in_front() -> bool:
	if has_node(".."):
		var siblings = get_parent().get_children()
		var n = get_parent().get_child_count()
		return (self == siblings[n - 1])
	return true


func get_drag_data(_position : Vector2):
	if yields_coin or OS.is_debug_build():
		if OS.is_debug_build():
			print("SlidingPuzzleWindow.gd: [DEBUG] Getting drag data for debugging.")
		
		var preview = Control.new()
		var texture_rect = TextureRect.new()
		
		preview.add_child(texture_rect)
		
		texture_rect.texture = coin_texture
		texture_rect.rect_size = coin_preview_size
		texture_rect.rect_min_size = coin_preview_size
		texture_rect.rect_position = -0.5 * coin_preview_size
		
		set_drag_preview(preview)
		
		return {"yields_coin": yields_coin or OS.is_debug_build()}


func _on_CodeKnoxEnchrypt_new_code_knox(_code : PoolIntArray) -> void:
	yields_coin = false
