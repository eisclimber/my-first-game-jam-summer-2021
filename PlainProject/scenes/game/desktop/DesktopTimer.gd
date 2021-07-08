extends PanelContainer
class_name DesktopTimer

signal timeout()

const TIME_FORMAT = "%02d:%02d"

export (float) var countdown_time = 900 # 15 min
export (float) var queue_freuqency = 60

var lastTenSeconds = false

func start() -> void:
	# +1 to sync with sound queue
	$CountdownTimer.start(countdown_time + 1)
	$SoundQueueTimer.start(queue_freuqency)
	$BombTickTimer.start()
	$AudioStreamPlayer2D.play()
	show()


func stop() -> void:
	$CountdownTimer.stop()
	$SoundQueueTimer.stop()
	hide()


func _process(_delta : float) -> void:
	if $CountdownTimer.time_left >= 0 and !$CountdownTimer.is_stopped():
		var time = int($CountdownTimer.time_left)
		var seconds = (time % 60)
		var minutes = int(time / 60)
		$Margin/TimeLabel.text = TIME_FORMAT % [minutes, seconds]
		lastTenSeconds = minutes <= 0 and seconds < 11

func _on_CountdownTimer_timeout():
	emit_signal("timeout")


func _on_SoundQueueTimer_timeout():
	$AudioStreamPlayer2D.play()


func _on_BombTickTimer_timeout():
	if lastTenSeconds:
		$AudioBombTick.play()
	
