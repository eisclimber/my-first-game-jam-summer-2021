extends Control

func _ready():
	start_animation()

func start_animation():
	var screen = $Margin
	var tween = $Tween
	
	yield(get_tree().create_timer(1), "timeout")
	
	screen.rect_pivot_offset = screen.rect_size / 2
	screen.rect_scale = Vector2(0, 0)
	screen.show()
	
	tween.interpolate_property(
		screen, "rect_scale",
		Vector2(0, 0), Vector2(1, 1), 1,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT
	)
	tween.start()
	#yield(get_tree().create_timer(1), "timeout")

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
