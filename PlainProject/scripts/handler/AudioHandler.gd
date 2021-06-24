extends Node

const BUS_MASTER = "Master"
const BUS_SOUNDS = "Sounds"
const BUS_MUSIC = "Music"
const BUS_AMBIENT = "Ambient"

onready var sounds_player = $SoundsPlayer
onready var music_player = $MusicPlayer
onready var ambient_player = $AmbientPlayer

var audio_dict : Dictionary = {}
var local_audio_enabled : bool = true

var current_music : String = ""


func _ready() -> void:
	randomize()
	pause_mode = PAUSE_MODE_PROCESS
	audio_dict = $AudioLoader.load_audio_dict()
	play_random_music()


func get_stream(_stream_name : String) -> AudioStreamSample:
	if audio_dict.has(_stream_name):
		return load(audio_dict[_stream_name]) as AudioStreamSample
	else:
		printerr("AudioHandler.gd: No audio with name ", _stream_name, ".")
		return null


# Play Sounds
func play_in_bus(_sound_name : String, _bus_name : String) -> void:
	var sound = get_stream(_sound_name)
	if sound != null:
		match(_bus_name):
			BUS_SOUNDS:
				sounds_player.stream = sound
				sounds_player.play()
			BUS_MUSIC:
				music_player.stream = sound
				music_player.play()
				current_music = _sound_name
			BUS_AMBIENT:
				ambient_player.stream = sound
				ambient_player.play()


func play_sound(_sound_name : String) -> void:
	play_in_bus(_sound_name, BUS_SOUNDS)


func play_music(_music_name : String) -> void:
	play_in_bus(_music_name, BUS_MUSIC)


func play_ambient(_ambient_name : String) -> void:
	play_in_bus(_ambient_name, BUS_AMBIENT)


# Stop sounds
func stop_bus(_bus_name : String) -> void:
	match(_bus_name):
		BUS_SOUNDS:
			sounds_player.stop()
		BUS_MUSIC:
			music_player.stop()
			current_music = ""
		BUS_AMBIENT:
			ambient_player.stop()


func stop_sound() -> void:
	stop_bus(BUS_SOUNDS)


func stop_music() -> void:
	stop_bus(BUS_MUSIC)


func stop_ambient() -> void:
	stop_bus(BUS_AMBIENT)


func change_bus_volume_by_name(_bus_name : String, _volume_pct : float) -> void:
	var bus_index = AudioServer.get_bus_index(_bus_name)
	if bus_index != -1:
		change_bus_volume(bus_index, _volume_pct)


func change_bus_volume(_bus_index : int, _volume_pct : float) -> void:
	var volume_db = 0
	if _volume_pct != 0:
		volume_db = linear2db(_volume_pct)
	
	AudioServer.set_bus_mute(_bus_index, (_volume_pct == 0.0))
	
	if _volume_pct != 0.0:
		AudioServer.set_bus_volume_db(_bus_index, volume_db)


func set_bus_muted_by_name(_bus_name : String, _muted : bool) -> void:
	var bus_index = AudioServer.get_bus_index(_bus_name)
	if bus_index != -1:
		set_bus_muted(bus_index, _muted)


func set_bus_muted(_bus_idx : int, _muted : bool) -> void:
	AudioServer.set_bus_mute(_bus_idx, _muted)


func get_audios_beginning_with_key(_key : String, _exceptions = []) -> PoolStringArray:
	var audios = audio_dict.keys()
	var keys = []
	for stream in audios:
		if stream.begins_with(_key) and !_exceptions.has(stream):
			keys.append(stream)
	return keys


func play_random_music() -> void:
	var music = get_audios_beginning_with_key("music.", [current_music])
	if music.size() == 0:
		if current_music != "": # Only one music audio -> replay current
			play_music(current_music)
		else: # no music available
			printerr("AudioHandler.gd: No music available!")
	else: # play a random other song
		music.shuffle()
		play_in_bus(music[0], BUS_MUSIC)


func _on_MusicPlayer_finished() -> void:
	play_random_music()


func set_bus_paused(_paused : bool, _bus_name : String) -> void:
	match(_bus_name):
		BUS_SOUNDS:
			sounds_player.stream_paused = _paused
		BUS_MUSIC:
			music_player.stream_paused = _paused
		BUS_AMBIENT:
			ambient_player.stream_paused = _paused
