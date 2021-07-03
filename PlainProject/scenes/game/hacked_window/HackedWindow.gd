extends CmdWindow
class_name HackedWindow

signal code_entered(_correct_code)

export (bool) var has_code = true setget set_has_code
export (String) var code = ""

onready var line_edit = $Margin/ContentVBox/ContentControl/ContentMargin/HBoxContainer/CodeLineEdit

func _ready() -> void:
	line_edit.max_length = CodeKnoxLogic.NUM_DIGITS
	if has_code:
		print("HackedWindow.gd: has_code was set initally with code \"%s\"." % code)


func _on_ConfirmCodeButton_pressed() -> void:
	var correct_code = (line_edit.text == code)
#	print("HackedWindow.gd: Code entered. It was %s." % correct_code)
	emit_signal("code_entered", correct_code)


func _on_CodeKnoxEnchrypt_new_code_knox(_code: PoolIntArray) -> void:
	var new_code = ""
	for digit in _code:
		new_code += str(digit)
	
	code = new_code
	
	set_has_code(true)


func set_has_code(_has_code : bool) -> void:
	has_code = _has_code



