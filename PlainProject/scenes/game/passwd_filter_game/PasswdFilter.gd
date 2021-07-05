extends Control

const Response = preload("res://scenes/game/passwd_filter_game/Response.tscn")
const ResponseL = preload("res://scenes/game/passwd_filter_game/ResponseL.tscn")
const storytext = preload("res://scenes/game/passwd_filter_game/storytext.tscn")
var max_scroll := 0

onready var hist = $Background/MarginContainer/Rows/GameInfo/Scroll/Hist
onready var scroll = $Background/MarginContainer/Rows/GameInfo/Scroll
onready var scrollbar = scroll.get_v_scrollbar()

func _ready() -> void:
	grab_focus()
	scrollbar.connect("changed", self, "handle_scrollbar_changed")
	max_scroll = scrollbar.max_value
	var starttext = ResponseL.instance()
	starttext.text = "Hello. Your computer was compromised and can only get unlocked if you find the correct answer to the following riddle! \n What is so fragile that saying its name breaks it?"
	add_response_to_game(starttext)
	

func _on_In_text_entered(new_text: String) -> void:
	if new_text.empty():
		return
	var response = Response.instance()
	if(new_text == "silence" || new_text == "Silence"):
		get_tree().quit()
	else:
		response.set_text(new_text, "wrong answer - try again")
	add_response_to_game(response)
	
	
func handle_scrollbar_changed():
	if max_scroll != scrollbar.max_value:
		max_scroll = scrollbar.max_value
		scroll.scroll_vertical = scrollbar.max_value

func add_response_to_game(response: Control):
	hist.add_child(response)
