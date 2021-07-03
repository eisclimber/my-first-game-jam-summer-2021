extends Control


func _ready() -> void:
	$AnimationPlayer.play("intro")


func _on_AnimationPlayer_animation_finished(_anim_name : String) -> void:
	get_tree().change_scene(ScenePaths.GAME_SCENE)
