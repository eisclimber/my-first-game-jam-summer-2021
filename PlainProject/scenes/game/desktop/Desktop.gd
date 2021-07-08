tool
extends Control
class_name Desktop

onready var window_area = $HBox/WindowArea
export (bool) var force_friend_txt_reopen = true

func _ready() -> void:
	if !Engine.is_editor_hint():
		$GrayOverlay.hide()
		$AnimationPlayer.play("intro")


## Intro Install

func _on_InstallerShortcut_double_clicked() -> void:
	force_friend_txt_reopen = false
	$AnimationPlayer.stop()
	$HBox/WindowArea/FriendTXT.hide()
	$HBox/TaskBar/Margin/TaskHBox/IntroHBox/InstallerButton.show()
	$HBox/WindowArea/InstallationIntro.popup_centered()


func _on_InstallationIntro_installation_complete() -> void:
	$AnimationPlayer.play("popup_windows")


# Main Game done
func _on_GameShortcut_double_clicked() -> void:
	$HBox/WindowArea/PasswordFilter.show()



## Code entered

func _on_HackedWindow_code_entered(_correct_code : bool) -> void:
	if _correct_code:
		close_popups_after_valid_code()
	else:
		$GrayOverlay.show()
		$WrongCodeDialog.popup_centered()


func close_popups_after_valid_code() -> void:
	$AnimationPlayer.play("close_windows")


## Window Maximation

func show_window_in_foreground(_window : Node) -> void:
	if _window in window_area.get_children():
		window_area.move_child(_window, window_area.get_child_count() - 1)
	_window.show()


func _on_SmithCoinButton_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/SmithCoinNewsWindow)


func _on_StaySmallButton_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/StaySmallWindow)


func _on_SlidingPuzzleButton_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/SlidingPuzzleWindow)


func _on_CodeKnox1Button_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/CodeKnots1)


func _on_CodeKnox2Button_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/CodeKnots2)


func _on_CodeKnox3Button_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/CodeKnots3)


func _on_YMCCButton_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/YMCCWindow)


func _on_CodeKnoxEnchryptButton_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/CodeKnoxEnchrypt)


func _on_HackedWindowButton_pressed() -> void:
	show_window_in_foreground($HBox/WindowArea/HackedWindow)

func _on_CodeKnoxExplanationButton_pressed():
	show_window_in_foreground($HBox/WindowArea/CodeKnoxExplanation)



func _on_FriendlyTextButton_pressed():
	if !$HBox/WindowArea/FriendTXT.visible:
		$HBox/WindowArea/FriendTXT.popup()


func _on_InstallerButton_pressed():
	$HBox/WindowArea/InstallationIntro.popup_centered()



## Popups
func _on_CmdWindow_move_to_front_requested(_window : Node) -> void:
	show_window_in_foreground(_window)


func _on_OsButton_pressed() -> void:
	$GrayOverlay.show()
	$BackToMenuDialog.popup_centered()


func _on_BackToMenuDialog_confirmed() -> void:
	var _error = get_tree().change_scene(ScenePaths.MAIN_MENU_SCENE)


func _on_BackToMenuDialog_popup_hide() -> void:
	$GrayOverlay.hide()


func _on_WrongCodeDialog_popup_hide() -> void:
	$GrayOverlay.hide()



# GameOver sequence
#	Shows the explosion sprite
func _on_DesktopTimer_timeout() -> void:
	$ExplosionAnimSprite.show()
	$ExplosionAnimSprite.play()	
	# stop all timers
	$HBox/TaskBar/Margin/TaskHBox/DesktopTimer.stop()
	AudioHandler.play_sound("sounds.explosion")

#	turns screen to red
func _on_ExplosionAnimSprite_frame_changed():
	# gives a death vibe to screen
	if $ExplosionAnimSprite.frame > 2:
		self.modulate = Color.red

#	loads "game over" scene
func _on_ExplosionAnimSprite_animation_finished():
	# fade to black animation
	var tween = $Tween
	tween.interpolate_property(self, "modulate",
		Color.red, Color.black, 1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(1), "timeout")
	self.modulate = Color.black
	# go to "game over" until the end	
	var _error = get_tree().change_scene(ScenePaths.GAME_OVER_SCENE)

# Force FriendTXT to popup again if the installer wasn't executed
func _on_FriendTXT_popup_hide():
	if force_friend_txt_reopen:
		$AnimationPlayer.play("intro")


# Goto end

func _on_PasswordFilter_all_answers_correct() -> void:
	get_tree().change_scene(ScenePaths.GAME_WON_SCENE)
