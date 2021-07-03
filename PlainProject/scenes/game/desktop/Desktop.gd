tool
extends Control
class_name Desktop

onready var window_area = $HBox/WindowArea

func _ready() -> void:
	if !Engine.is_editor_hint():
		$GrayOverlay.hide()
		$AnimationPlayer.play("intro")


## Intro Install

func _on_ProgramShortcut_double_clicked() -> void:
	$HBox/TaskBar/Margin/TaskHBox/IntroHBox/InstallerButton.show()
	$HBox/WindowArea/InstallationIntro.popup_centered()


func _on_InstallationIntro_installation_complete() -> void:
	$AnimationPlayer.play("popup_windows")



## Code entered

func _on_HackedWindow_code_entered(_correct_code : bool) -> void:
	if _correct_code:
		close_popups_after_valid_code()
	else:
		$GrayOverlay.show()
		$WrongCodeDialog.popup_centered()


func close_popups_after_valid_code() -> void:
	print("Desktop.gd: Correct code entered.")
#	$HBox/WindowArea/SlidingPuzzleWindow.hide()
#	$HBox/WindowArea/SmithCoinNewsWindow.hide()
#	$HBox/WindowArea/CodeKnots2.hide()
#	$HBox/WindowArea/CodeKnoxExplanation.hide()
#	$HBox/WindowArea/CodeKnots3.hide()
#	$HBox/WindowArea/YMCCWindow.hide()
#	$HBox/WindowArea/CodeKnots1.hide()
#	$HBox/WindowArea/StaySmallWindow.hide()
#	$HBox/WindowArea/CodeKnoxEnchrypt.hide()
#	$HBox/WindowArea/HackedWindow.hide()
#	$HBox/WindowArea/FriendTXT.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/SmithCoinButton.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/StaySmallButton.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/SlidingPuzzleButton.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/CodeKnox1Button.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/CodeKnox2Button.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/CodeKnox3Button.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/YMCCButton.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/CodeKnoxEnchryptButton.hide()
#	$HBox/TaskBar/Margin/TaskHBox/CmdHBox/HackedWindowButton.hide()



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



# GameOver

func _on_DesktopTimer_timeout() -> void:
	var _error = get_tree().change_scene(ScenePaths.GAME_OVER_SCENE)
