extends Node

"""
This Script is used to hold all Settings of the game such as audio volumes.
"""

# Location of the settings file
const SETTINGS_PATH = "settings/Settings.json"
const DEFAULT_SETTINGS = {
		"fullscreen": false,
		"window_size": {
			"x": 1280,
			"y": 720
		},
		"locale": "en",
		"master_volume": 1.0,
		"sounds_volume": 1.0,
		"music_volume": 1.0,
		"ambient_volume": 1.0
	}

# Dictionary golding the current settings
var settings : Dictionary


func _ready() -> void:
	load_settings()
	setup()

################# Getter ##################

func is_hard_input_enabled() -> bool:
	return settings["hard_input_enabled"]


func is_fullscreen() -> bool:
	return settings["fullscreen"]


func get_locale() -> String:
	return settings["locale"]


################ Setter ###################

func set_audio_bus_volume(_bus_name : String, _bus_volume : float) -> void:
	var volume = clamp(_bus_volume, 0.0, 1.0)
	var bus_key = (_bus_name.to_lower()) + "_volume"
	
	if settings.has(bus_key):
		settings[bus_key] = volume
		AudioHandler.change_bus_volume_by_name(_bus_name, volume)
	save_settings()


func set_hard_input_enabled(_enabled : bool) -> void:
	settings["hard_input_enabled"] = _enabled
	save_settings()


func set_locale(_locale : String) -> void:
	settings["locale"] = _locale
	TranslationServer.set_locale(_locale)
	save_settings()


func set_fullscreen(_enabled : bool) -> void:
	settings["fullscreen"] = _enabled
	OS.window_fullscreen = _enabled
	save_settings()


func set_window_size(_size : Vector2) -> void:
	settings["window_size"]["x"] = _size.x
	settings["window_size"]["y"] = _size.y
	OS.window_size = _size
	save_settings()


################ Helper ###################

func setup() -> void:
	setup_audio()
	setup_screen()


func setup_audio() -> void:
	set_audio_bus_volume("Master", settings["master_volume"])
	set_audio_bus_volume("Sounds", settings["sounds_volume"])
	set_audio_bus_volume("Music", settings["music_volume"])
	set_audio_bus_volume("Ambient", settings["ambient_volume"])


func setup_screen() -> void:
	# Set fullscreen
	set_fullscreen(settings["fullscreen"])
	
	# Set window size
	var size_entry = settings["window_size"]
	var window_size = Vector2(size_entry["x"], size_entry["y"])
	set_window_size(window_size)


################FileIO###################

func load_settings() -> void:
	settings = FileIO.retrieve_json_from_file(SETTINGS_PATH)
	
	# Use default settings if no settings are found
	if settings.empty():
		printerr("Settings.gd: No Settings found. Creating new one by using default.")
		settings = DEFAULT_SETTINGS
		save_settings()
	
	# Check if every entry exists. If not use the value from the default settings
	for key in DEFAULT_SETTINGS.keys():
		if !settings.has(key):
			settings[key] = DEFAULT_SETTINGS[key]
			save_settings()



func save_settings() -> void:
	FileIO.save_json_to_file(settings, SETTINGS_PATH)
