extends Node

# From which directory the project should be parsed for audio files
export(String, DIR) var audio_dir_path = "res://resources/audio"

# If true the name of each file will be uniquely derived from its location
# E.g. 'res://some/dir/file.wav' will have the id  'dir.file' with 
# audio_dir_path = 'res://dir/'
# If false the name will be only the file name (unique file names required!!)
export(bool) var id_from_paths = true 

"""
 This is the audio loader.
 It features two AudioStreamPlayer, one for sounds and one for music
 All audio is stored in dicts and will be loaded from the audio folder(s).
 Currently the sounds will be loaded uppon playing it if that causes the sound
 to lag, load the sound on _ready() (but it will consume more memory)
"""

# Loads the audio dict from the .import-files in the AUDIO_FILE_PATH-directoy
func load_audio_dict() -> Dictionary:
	var files = get_files_in_dir(audio_dir_path)
	var audio_dict = {}
	
	for file in files:
		if file.ends_with(".import"):
			file = file.replace(".import", "")
			if has_audio_file_postfix(file):
				var sound_id = create_audio_id(file)
				if audio_dict.has(sound_id):
					printerr("AudioLoader.gd: Duplicate key: ", sound_id)
				audio_dict[sound_id] = file
	return audio_dict


# Lists all files in a directoy (and all subsequent)
func get_files_in_dir(_dir_path : String) -> PoolStringArray:
	var dir = Directory.new()
	var error = dir.open(_dir_path)
	var files = []
	
	if error == OK:
		dir.list_dir_begin()
		var file_name =  dir.get_next()
		while file_name != "":
			if !file_name.begins_with("."):
				if dir.current_is_dir():
					files = files + get_files_in_dir(_dir_path.plus_file(file_name))
				else:
					files.append(_dir_path.plus_file(file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		printerr("AudioLoader.gd: Could not load ", dir, ". Error: ", error)
	return files


# Creates a id depentent on the selected method
func create_audio_id(_path: String) -> String:
	if id_from_paths:
		return create_audio_id_from_path(_path)
	return create_audio_id_from_file(_path)


# Creates an id from a files location
func create_audio_id_from_path(_path : String) -> String:
	var trimmed_path = trim_path(_path)
	return trimmed_path.replace("/", ".")


# Creates a id from a files name
func create_audio_id_from_file(_path : String) -> String:
	var trimmed_path = trim_path(_path)
	var split_path = trimmed_path.split("/", false)
	return split_path[split_path.size() - 1]


# Trimms eccess information from a file path for id creation
func trim_path(_path : String) -> String:
	var trimmed_path = _path.trim_prefix(audio_dir_path)
	trimmed_path = trimmed_path.trim_prefix("/")
	trimmed_path = trimmed_path.trim_suffix(".wav")
	trimmed_path = trimmed_path.trim_suffix(".ogg")
	return trimmed_path


# True if it is one of the three supported audio formats (.wav, .ogg, .mp3)
func has_audio_file_postfix(_path : String) -> bool:
	return _path.ends_with(".wav") or _path.ends_with(".ogg") \
		 or _path.ends_with(".mp3")
