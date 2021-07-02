extends WindowDialog

export (bool) var has_code = false setget set_has_code
export (PoolIntArray) var code = []


#func _ready() -> void:
#	set_has_code(false)


func _on_CodeKnoxEnchrypt_new_code_knox(_code: PoolIntArray) -> void:
	print("WindowDialog.gd: ", _code)
	set_has_code(true)


func set_has_code(_has_code : bool) -> void:
	has_code = _has_code

