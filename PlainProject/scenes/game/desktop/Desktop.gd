extends Control


func _ready():
	$GrayOverlay.hide()
	$AnimationPlayer.play("popup_windows")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_OsButton_pressed():
	$GrayOverlay.show()
	$BackToMenuDialog.popup_centered()


func _on_BackToMenuDialog_confirmed():
	var _error = get_tree().change_scene(ScenePaths.MAIN_MENU)


func _on_BackToMenuDialog_popup_hide():
	$GrayOverlay.hide()
