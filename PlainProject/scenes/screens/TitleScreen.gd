extends Control




func _on_PlayButton_pressed():
	var _error = get_tree().change_scene(ScenePaths.GAME_SCENE)


func _on_OptionsButton_pressed():
	var _error = get_tree().change_scene(ScenePaths.OPTIONS_SCENE)


func _on_CreditsButton_pressed():
	var _error = get_tree().change_scene(ScenePaths.CREDITS_SCENE)


func _on_ExitButton_pressed():
	get_tree().quit()
