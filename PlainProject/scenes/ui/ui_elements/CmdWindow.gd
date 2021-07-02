tool
extends PanelContainer
class_name CmdWindow

export (String) var title = "" setget set_title
export (String, MULTILINE) var text_content = "" setget set_text_content


func set_title(_title : String) -> void:
	title = _title
	$Margin/ContentVBox/TitleHBox/TitleMargin/TitleLabel.text = _title


func set_text_content(_text_content : String) -> void:
	text_content = _text_content
	$Margin/ContentVBox/ContentControl/ContentMargin/ContentLabel.text = _text_content


func _on_CloseButton_pressed():
	hide()
