extends VBoxContainer


func _ready() -> void:
	$FullscreenHBox/FullscreenCheckButton.pressed = Settings.is_fullscreen()
	$HardmodeHBox/HardmodeCheckButton.pressed = Settings.is_hard_input_enabled()


# Enable/Disable fullscreen
func _on_FullscreenCheckButton_toggled(_button_pressed : bool) -> void:
	Settings.set_fullscreen(_button_pressed)


# Enable/Disable hard input
func _on_HardmodeToggle_toggled(_button_pressed : bool) -> void:
	Settings.set_hard_input_enabled(_button_pressed)
