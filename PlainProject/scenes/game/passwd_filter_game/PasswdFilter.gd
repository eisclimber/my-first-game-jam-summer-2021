tool
extends Control
class_name PasswordFilterWindow

signal all_answers_correct()
signal wrong_answer()


const QUESTIONS = {
	"questions" : [
		{
			"question" : "What is so fragile that saying its name breaks it?",
			"answer" : "silence"
		}
	]
}

export (bool) var reset_on_wrong_answer = true
export (bool) var clear_on_wrong_answer = true

export (int) var current_question = 0 setget set_current_question



onready var line_edit = $Margin/ContentVBox/ContentControl/ContentMargin/Rows/inputHBox/InputEdit
onready var output_label = $Margin/ContentVBox/ContentControl/ContentMargin/Rows/ConsoleOutput


func _ready():
	output_label.bbcode_text = "Hello. Your computer was compromised and can only get unlocked if you find the correct answer to the following riddle! \n \n"
	set_current_question(0)



func set_current_question(_current_question : int) -> void:
	current_question = clamp(_current_question, 0, QUESTIONS["questions"].size() - 1)
	
	output_label.bbcode_text += "[color=yellow]" + QUESTIONS["questions"][current_question]["question"]  + "[/color]\n"



func check_answer(_answer : String):
	line_edit.text = ""
	if is_answer_correct(_answer):
		
		output_label.bbcode_text += "[color=green][Correct Answer][/color] \n"
		if current_question == QUESTIONS["questions"].size() - 1:
			emit_signal("all_answers_correct")
		else:
			set_current_question(current_question + 1)
	else:
		if clear_on_wrong_answer:
			output_label.bbcode_text = ""
		output_label.bbcode_text += "[color=red][Wrong Answer][/color] \n"
		
		if reset_on_wrong_answer:
			set_current_question(0)


func is_answer_correct(_answer : String) -> bool:
	var correct_answer = QUESTIONS["questions"][current_question]["answer"].to_lower()
	return _answer == correct_answer



func _on_ConfirmButton_pressed():
	if line_edit:
		check_answer(line_edit.text)


func _on_InputEdit_text_entered(_new_text):
	check_answer(_new_text)
