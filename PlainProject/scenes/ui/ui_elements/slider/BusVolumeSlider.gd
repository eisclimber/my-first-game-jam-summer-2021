tool
extends LabeledHSlider
class_name BusVolumeSlider

# The bus that will be affected by the slider
export (String) var audio_bus = AudioHandler.BUS_MASTER setget set_audio_bus


func _ready() -> void:
	set_audio_bus(audio_bus)
	var bus_id = AudioServer.get_bus_index(audio_bus)
	# Change the bus if it exists and if not in the Editor
	if bus_id != -1 and !Engine.is_editor_hint():
		# Handle muted bus (volume set to 0)
		if AudioServer.is_bus_mute(bus_id):
			set_value(0)
		else:
			var linear_audio = db2linear(AudioServer.get_bus_volume_db(bus_id))
			set_value(linear_audio * 100)


# Called uppon dragging the slider
func _on_BusVolumeSlider_value_changed(_value : float) -> void:
	if !Engine.is_editor_hint():
		var pct = _value / 100.0
		Settings.set_audio_bus_volume(audio_bus, pct)


# Setter for the affected audio bus
func set_audio_bus(_audio_bus : String) -> void:
	audio_bus = _audio_bus
	if localization_enabled:
		var label = "audio." + _audio_bus.to_lower() + '_bus'
		# Rename for Political Correctness:)
		if label == 'audio.master_bus':
			label = 'audio.volume_bus'
		
		set_prefix(tr(label) + ' : ')
	else:
		set_prefix(_audio_bus + ": ")
