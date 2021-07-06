tool
extends Control

signal double_clicked()


export (Texture) var icon = null setget set_icon
export (String, MULTILINE) var program_name = "" setget set_program_name
export (float) var double_click_time = 1
export (bool) var disabled = false setget set_disabled



func _on_GameButton_pressed():
	if $Timer.time_left > 0:
		$Timer.stop()
		emit_signal("double_clicked")
	else:
		$Timer.start(double_click_time)


func set_icon(_icon : Texture) -> void:
	icon = _icon
	if has_node("HBoxContainer/GameButton"):
		$HBoxContainer/GameButton.icon = _icon


func set_program_name(_program_name : String) -> void:
	program_name = _program_name
	if has_node("HBoxContainer/Label"):
		$HBoxContainer/Label.text = _program_name



func set_disabled(_disabled : bool) -> void:
	disabled = _disabled
	if has_node("HBoxContainer/GameButton"):
		$HBoxContainer/GameButton.disabled = _disabled
	if has_node("Timer"):
		$Timer.stop()
