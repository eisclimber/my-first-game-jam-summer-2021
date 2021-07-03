extends PanelContainer
class_name DesktopTimer

signal timeout()

const TIME_FORMAT = "%2d:%2d"


func _process(_delta : float) -> void:
	if $Timer.time_left >= 0:
		var time = int($Timer.time_left)
		var seconds = (time % 60)
		var minutes = int(time / 60)
		$Margin/TimeLabel.text = TIME_FORMAT % [minutes, seconds]
