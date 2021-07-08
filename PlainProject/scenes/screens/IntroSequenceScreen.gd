extends Control

onready var label = $Margin/AnimatedLabel
onready var tween = $Tween

var animating = true
var deltaTime = 0

const ALARM_SOUND = "sounds.Alarm-clock-bell-ringing-sound-effect"
const KEYBOARD_SOUND = "sounds.Fast-pace-typing"

func _ready() -> void:
	intro_alarm()


func _input(_event : InputEvent) -> void:
	if Input.is_action_pressed("ui_cancel"):
		animating = false


func _process(delta):
	deltaTime = delta


func intro_alarm() -> void:
	var t = 0
	# firts play alram sound
	AudioHandler.play_sound(ALARM_SOUND)
	
	while animating and t < 3.5:
		# in case the user skips
		t = t + deltaTime
		yield(get_tree(), "idle_frame")

	AudioHandler.stop_sound()
	
	if animating:
		intro_text()
	else:
		finish_intro()


func intro_text() -> void:
	var letterDelta = 0.15
	var texts = [ 
		$Margin/FirstLabel.text,
		$Margin/SecondLabel.text
	]
	# play keyboard anim
	AudioHandler.play_sound(KEYBOARD_SOUND)
	
	for text in texts:
		yield(get_tree().create_timer(0.5), "timeout")
		label.text = ""
		for _char in text:
			# check user's status
			if not animating:
				break
			# text anim
			label.text = label.text + _char
			yield(get_tree().create_timer(0.15), "timeout")

		# check user's status
		if not animating:
			break
	# end for
	finish_intro()
	
	
func finish_intro() -> void:
	AudioHandler.stop_sound()
	# color anim
	tween.interpolate_property(
		self, "modulate",
		# just fades out
		Color.white, Color.black, 2,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.start()
	yield(get_tree().create_timer(3), "timeout")
	
	var _error = get_tree().change_scene(ScenePaths.GAME_SCENE)
