extends CmdWindow
class_name HackedWindow

signal code_entered(_correct_code)

export (bool) var has_code = false setget set_has_code
export (String) var code = ""

onready var line_edit = $Margin/ContentVBox/ContentControl/ContentMargin/NotPayedHBox/CodeLineEdit

func _ready() -> void:
	line_edit.max_length = code.length()
	if has_code:
		print("HackedWindow.gd: has_code was set initally with code \"%s\"." % code)


func _on_ConfirmCodeButton_pressed() -> void:
	var correct_code = (line_edit.text == code)
	if OS.is_debug_build():
		print("HackedWindow.gd: [DEBUG] New Code received. It was %s." % correct_code)
	
	$Margin/ContentVBox/ContentControl/ContentMargin/ContentLabel.visible = !correct_code
	$Margin/ContentVBox/ContentControl/ContentMargin/NotPayedHBox.visible = !correct_code
	$Margin/ContentVBox/ContentControl/ContentMargin/PayedLabel.visible = correct_code
	
	emit_signal("code_entered", correct_code)


func _on_CodeKnoxEnchrypt_new_code_knox(_code : PoolIntArray) -> void:
	var new_code = ""
	for digit in _code:
		new_code += str(digit)
	
	code = new_code
	
	line_edit.max_length = code.length()
	
	print("HackedWindow.gd: [DEBUG] Code is ", code)
	
	set_has_code(true)


func set_has_code(_has_code : bool) -> void:
	has_code = _has_code
	



func _on_CodeLineEdit_text_entered(_new_text : String) -> void:
	var correct_code = (_new_text == code)
	print("HackedWindow.gd: Code entered. It was %s." % correct_code)
	
	$Margin/ContentVBox/ContentControl/ContentMargin/ContentLabel.visible = !correct_code
	$Margin/ContentVBox/ContentControl/ContentMargin/NotPayedHBox.visible = !correct_code
	$Margin/ContentVBox/ContentControl/ContentMargin/PayedLabel.visible = correct_code
	
	emit_signal("code_entered", correct_code)
