tool
extends LinkButton
class_name HotlinkButton

export(String) var link = ""

# Connnect signals on ready
func _ready():
	var _error1 = connect("button_up", self, "_on_HotlinkButton_button_up")
	var _error2 = connect("button_down", self, "_on_HotlinkButton_button_down")
	var _error3 = connect("pressed", self, "_on_HotlinkButton_pressed")
	mouse_default_cursor_shape = CURSOR_POINTING_HAND


# Open the hotlink uppon pressing
func _on_HotlinkButton_pressed():
	if link != "":
		var _error = OS.shell_open(link)


# Play click_down uppon mouse press
func _on_HotlinkButton_button_down():
	AudioHandler.play_sound("menu_button_pressed")


# Play click_up uppon mouse release
func _on_HotlinkButton_button_up():
	AudioHandler.play_sound("menu_button_released")
