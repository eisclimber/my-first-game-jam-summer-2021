extends Node
class_name CodeKnoxLogic

const NUM_DIGITS = 10
const NUM_WINDOWS = 3
const START_KEYS = ['A', 'H', 'M', 'F', 'S', 'P', 'V', 'Q', 'J', 'O', 'B', 'G']


func _ready() -> void:
	randomize()


func generate_code(_start_window : String, _start_key : String) -> Array:
	var code = []
	var window = _start_window
	var key = _start_key
	while (code.size() < NUM_DIGITS):
		var info = get_window_key_info(window, key)
		code.append_array(info["digits"])
		window = info["next_window"]
		key = info["next_key"]
	
	code.resize(NUM_DIGITS)
	return code



func get_window_key_info(_window_idx : String, _key : String) -> Dictionary:
#	print(_window_idx, "  ", _key, "   ", INFOS.has(_window_idx), "   ", INFOS[_window_idx].has(_key))
	if INFOS.has(_window_idx) and INFOS[_window_idx].has(_key):
		return INFOS[_window_idx][_key]
	return {}


func get_random_code_info() -> Dictionary:
	var rand_window = 1 + randi() % (NUM_WINDOWS - 1)
	var possible_keys = INFOS[str(rand_window)].keys()
	var rand_key_idx = randi() % possible_keys.size()
	
	return {"window": str(rand_window), "key": possible_keys[rand_key_idx]}



const INFOS = {
	"1" : {
		"A" : {
			"next_window" : "2",
			"next_key" : "Q",
			"digits" : [2, 7, 8]
		},
		"H" : {
			"next_window" : "2",
			"next_key" : "V",
			"digits" : [7, 1]
		},
		"M" : {
			"next_window" : "3",
			"next_key" : "F",
			"digits" : [9, 5, 0, 0, 3]
		},
		"F": {
			"next_window" : "2",
			"next_key" : "M",
			"digits" : [3, 0, 0, 5, 9]
		},
		"S": {
			"next_window" : "3",
			"next_key" : "P",
			"digits" : [2]
		},
		"P" : {
			"next_window" : "3",
			"next_key" : "S",
			"digits" : [2]
		},
		"V" : {
			"next_window" : "3",
			"next_key" : "H",
			"digits" : [1, 7]
		},
		"Q" : {
			"next_window" : "2",
			"next_key" : "A",
			"digits" : [8, 7, 2]
		}
	},
	"2" : {
		"A" : {
			"next_window" : "3",
			"next_key" : "J",
			"digits" : [2]
		},
		"J" : {
			"next_window" : "1",
			"next_key" : "A",
			"digits" : [2]
		},
		"M" : {
			"next_window" : "1",
			"next_key" : "Q",
			"digits" : [6, 3]
		},
		"O": {
			"next_window" : "3",
			"next_key" : "B",
			"digits" : [7, 8, 9]
		},
		"B": {
			"next_window" : "3",
			"next_key" : "O",
			"digits" : [9, 8, 7]
		},
		"X" : {
			"next_window" : "1",
			"next_key" : "V",
			"digits" : [5, 1, 0]
		},
		"V" : {
			"next_window" : "3",
			"next_key" : "X",
			"digits" : [0, 1, 5]
		},
		"Q" : {
			"next_window" : "1",
			"next_key" : "M",
			"digits" : [3, 6]
		},
		"G" : {
			"next_window" : "2",
			"next_key" : "G",
			"digits" : [6]
		}
	},
	"3" : {
		"J" : {
			"next_window" : "1",
			"next_key" : "S",
			"digits" : [4, 4, 9]
		},
		"H" : {
			"next_window" : "2",
			"next_key" : "X",
			"digits" : [0, 7]
		},
		"O" : {
			"next_window" : "1",
			"next_key" : "F",
			"digits" : [2, 8, 1]
		},
		"F": {
			"next_window" : "2",
			"next_key" : "O",
			"digits" : [1, 8, 2]
		},
		"S": {
			"next_window" : "2",
			"next_key" : "J",
			"digits" : [9, 4, 4]
		},
		"P" : {
			"next_window" : "2",
			"next_key" : "B",
			"digits" : [3, 5]
		},
		"B" : {
			"next_window" : "1",
			"next_key" : "P",
			"digits" : [5, 3]
		},
		"X" : {
			"next_window" : "1",
			"next_key" : "H",
			"digits" : [7, 0]
		}
	}
}
