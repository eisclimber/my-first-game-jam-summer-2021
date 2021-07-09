extends Control

func _ready():
	set_menu_buttons_disabled(true)
	start_animation()


func start_animation():
	var screen = $AspectRatio/Margin
	var tween = $Tween
	
	yield(get_tree().create_timer(1), "timeout")
	screen.rect_pivot_offset = screen.rect_size / 2
	screen.rect_scale = Vector2(0, 0)
	
	tween.interpolate_property(
		screen, "rect_scale",
		Vector2(0, 0), Vector2(1, 1), 2,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	
	tween.interpolate_property(
		screen, "visible",
		false, true, 0,
		Tween.TRANS_ELASTIC, Tween.EASE_IN,
		0.35
	)
	
	tween.start()


func set_menu_buttons_disabled(_disabled : bool) -> void:
	for child in $AspectRatio/Margin/ButtonsVBox.get_children():
		if child is Button:
			child.disabled = _disabled



func _on_PlayButton_pressed():
	var _error = get_tree().change_scene(ScenePaths.INTRO_SCENE)


func _on_OptionsButton_pressed():
	var _error = get_tree().change_scene(ScenePaths.OPTIONS_SCENE)


func _on_CreditsButton_pressed():
	var _error = get_tree().change_scene(ScenePaths.CREDITS_SCENE)


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_DisclaimerButton_pressed():
	$GrayOverlay.show()
	$DisclaimerDialog.popup_centered()


func _on_AcceptDialog_popup_hide():
	$GrayOverlay.hide()


func _on_Tween_tween_all_completed() -> void:
	set_menu_buttons_disabled(false)
