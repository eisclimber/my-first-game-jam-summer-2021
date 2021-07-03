extends Control


func _ready() -> void:
	$AnimationPlayer.play("intro")


func _input(_event : InputEvent) -> void:
	if Input.is_action_pressed("ui_cancel"):
		$AnimationPlayer.stop()
		var _error = get_tree().change_scene(ScenePaths.GAME_SCENE)


func _on_AnimationPlayer_animation_finished(_anim_name : String) -> void:
	var _error = get_tree().change_scene(ScenePaths.GAME_SCENE)
