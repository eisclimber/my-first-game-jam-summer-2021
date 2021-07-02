extends CmdWindow

export (Texture) var coin_texture = null
export (Vector2) var coin_preview_size = Vector2.ONE * 64
export (Vector2) var content_border_size = Vector2.ONE * 60
export (bool) var yields_coin = false

onready var slinding_puzzle = $Margin/ContentVBox/ContentControl/ContentMargin/CenterContainer/CenterControl/SlidingPuzzle


func _ready():
	slinding_puzzle.center()
	
	var content_rect_size = slinding_puzzle.get_rect_size() + content_border_size
	rect_min_size = content_rect_size
	rect_size = content_rect_size


func _on_SlidingPuzzle_completed() -> void:
	yields_coin = true
	mouse_filter = MOUSE_FILTER_STOP


func get_drag_data(_position : Vector2):
	if yields_coin:
		var preview = Control.new()
		var texture_rect = TextureRect.new()
		
		preview.add_child(texture_rect)
		
		texture_rect.texture = coin_texture
		texture_rect.rect_size = coin_preview_size
		texture_rect.rect_min_size = coin_preview_size
		texture_rect.rect_position = -0.5 * coin_preview_size
		
		set_drag_preview(preview)
		
		return {"yields_coin": yields_coin}

