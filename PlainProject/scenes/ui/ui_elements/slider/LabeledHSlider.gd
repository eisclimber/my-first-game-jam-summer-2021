tool
extends HSlider
class_name LabeledHSlider

# Text displayed before the sliders value
export (String) var prefix = "" setget set_prefix
# Text displayed after the sliders value
export (String) var postfix = "" setget set_postfix
# Use translation or not
export (bool) var localization_enabled = true setget set_localization_enabled

# Updates the displayed value
func _on_LabeledHSlider_value_changed(_value) -> void:
	if has_node("ValueLabel"):
		if localization_enabled:
			$ValueLabel.text = tr(prefix) + str(_value) + tr(postfix)
		else:
			$ValueLabel.text = prefix + str(_value) + postfix


# Sets the prefix and also updates the label 
func set_prefix(_prefix) -> void:
	prefix = _prefix
	_on_LabeledHSlider_value_changed(value)


# Sets the postfix and also updates the label 
func set_postfix(_postfix) -> void:
	postfix = _postfix
	_on_LabeledHSlider_value_changed(value)


# Enables localization/translation
func set_localization_enabled(_localization_enabled : bool) -> void:
	localization_enabled = _localization_enabled
	_on_LabeledHSlider_value_changed(value)


# Since the slider has no pressed signal we use gui_input
func _on_LabeledHSlider_gui_input(_event : InputEvent) -> void:
	# Check for left mouse button input not from within the editor
	if (_event is InputEventMouseButton and _event.button_index == BUTTON_LEFT) \
	 and !Engine.is_editor_hint():
		if _event.pressed:
			# Play click_down uppon mouse press
			AudioHandler.play_sound("sounds.menu_button_pressed")
		else:
			# Play click_up uppon mouse release
			AudioHandler.play_sound("sounds.menu_button_released")
