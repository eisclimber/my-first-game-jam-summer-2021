extends Control


func _ready() -> void:
	$AnimationPlayer.play("forklift_intro")


func _on_BackButton_pressed():
	get_tree().change_scene(ScenePaths.MAIN_MENU_SCENE)
