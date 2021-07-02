tool
extends CmdWindow
class_name CodeKnoxEnchrypt

signal new_code_knox(code)

const HAS_NOT_PAYED_TEXT = "Order Summary: \n \n 1x VirtUnlock-Code \n" \
	+ "1x VirtualDampHandShake \n \n Accepted payment methods: \n StaySmall, YMCC, SmithCoin."

const HAS_PAYED_TEXT_FORMAT = "Confiming the purchase of a VirtUnlock-Code. \n \n" \
	+ "The %d-digit code was encrypted using CodeKnox. \n \n" \
	+ "Your personal starting code is: %s%s"


export (bool) var has_payed = false setget set_has_payed

onready var content_label = $Margin/ContentVBox/ContentControl/ContentMargin/ContentLabel


func drop_data(_position : Vector2, _data) -> void:
	if _data is Dictionary and _data.has("yields_coin") and _data["yields_coin"]:
		set_has_payed(_data["yields_coin"])


func can_drop_data(_position : Vector2, _data) -> bool:
	return _data is Dictionary and _data.has("yields_coin") and _data["yields_coin"]


func set_has_payed(_has_payed : bool) -> void:
	has_payed = _has_payed
	
	if has_payed:
		generate_new_code()
	else:
		content_label.text = HAS_NOT_PAYED_TEXT


func generate_new_code() -> void:
	var code_info = $CodeKnoxLogic.get_random_code_info()
	var code = $CodeKnoxLogic.generate_code(code_info["window"], code_info["key"])
	
	var new_text = HAS_PAYED_TEXT_FORMAT % [CodeKnoxLogic.NUM_DIGITS, code_info["window"], code_info["key"]]
	content_label.text = new_text
	
#	print("CodeKnoxEnchrypt.gd: New code generated %s" % str(code))
	emit_signal("new_code_knox", code)
