tool
extends PanelContainer
class_name CmdWindow

signal move_to_front_requested(_window)

export (String) var title = "" setget set_title
export (String, MULTILINE) var text_content = "" setget set_text_content


func _gui_input(_event : InputEvent) -> void:
	if _event is InputEventMouseButton and _event.button_index == BUTTON_LEFT and _event.pressed:
		emit_signal("move_to_front_requested", self)


func set_title(_title : String) -> void:
	title = _title
	$Margin/ContentVBox/TitleHBox/TitleMargin/TitleLabel.text = _title


func set_text_content(_text_content : String) -> void:
	text_content = _text_content
	$Margin/ContentVBox/ContentControl/ContentMargin/ContentLabel.text = _text_content


func _on_CloseButton_pressed():
	hide()
