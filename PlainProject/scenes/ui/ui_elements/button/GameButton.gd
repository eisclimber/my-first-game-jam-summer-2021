tool
extends Button
class_name GameButton

# Connnect signals on ready
func _ready():
	var _error1 = connect("button_up", self, "_on_GameButton_button_up")
	var _error2 = connect("button_down", self, "_on_GameButton_button_down")
	mouse_default_cursor_shape = CURSOR_POINTING_HAND


# Play click_down uppon mouse press
func _on_GameButton_button_down():
	AudioHandler.play_sound("sounds.menu_button_pressed")


# Play click_up uppon mouse release
func _on_GameButton_button_up():
	AudioHandler.play_sound("sounds.menu_button_released")
