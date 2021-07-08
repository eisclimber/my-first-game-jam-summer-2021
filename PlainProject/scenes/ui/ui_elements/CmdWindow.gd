tool
extends PanelContainer
class_name CmdWindow

signal move_to_front_requested(_window)

export (String) var title = "" setget set_title
export (String, MULTILINE) var text_content = "" setget set_text_content

onready var tween = $Tween


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
	var currPos = self.rect_position;
	var animTime = 0.25
	# movement anim
	tween.interpolate_property(
		self, "rect_position",
		# jusy go upwards and right in 0.5s
		currPos, currPos + Vector2(0, -20), animTime,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	# alpha anim
	tween.interpolate_property(
		self, "modulate:a",
		# jusy go upwards and right in 0.5s
		1, 0, animTime,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.start()
	# wait until it ends...
	yield(get_tree().create_timer(animTime), "timeout")
	
	hide()
	# return to old state after anim
	self.rect_position = currPos
	self.modulate.a = 1
