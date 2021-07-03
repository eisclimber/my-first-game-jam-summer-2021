extends Control

signal double_clicked()


export (float) var double_click_time = 1
export (bool) var disabled = false setget set_disabled


func _on_GameButton_pressed():
	if $Timer.time_left > 0:
		$Timer.stop()
		emit_signal("double_clicked")
	else:
		$Timer.start(double_click_time)


func set_disabled(_disabled : bool) -> void:
	disabled = _disabled
	$HBoxContainer/GameButton.disabled = _disabled
	$Timer.stop()
