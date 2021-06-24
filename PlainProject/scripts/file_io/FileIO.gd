extends Node

# Change this to "user://" on deployment
const DATA_ROOT = "user://"
const JSON_TYPE = ".json"


# Use this to check if a file exists
func file_exists(_file_path : String) -> bool:
	var dir = Directory.new();
	if dir.open(self.DATA_ROOT) == OK:
		return dir.file_exists(_file_path)
	else:
		return false


# Use this to load a JSON from a file
func retrieve_json_from_file(_save_path : String) -> Dictionary:
	if !_save_path.ends_with(JSON_TYPE):
		_save_path += JSON_TYPE
	var load_file = _open_file(_save_path)
	
	if load_file == null:
		return {}
	
	# load the data into persistent nodes
	var json_data = JSON.parse(load_file.get_as_text())
	
	if json_data.error != OK:
		print("FileSaver.gd: Error decoding JSON! (at ", _save_path, ")")
		return {}
	
	return json_data.result


# Use this to save (and replace) a dictionary as JSON
func save_json_to_file(_save_dict : Dictionary, _save_path : String, 
		_mkdir : bool = true) -> void:
	if !_save_path.ends_with(JSON_TYPE):
		_save_path += JSON_TYPE
	_save_to_file(_save_dict, _save_path, _mkdir)


# Opens a file a the specific location
func _open_file(_save_path : String) -> File:
	# Try to load the save
	var load_file = File.new()
	#Add DATA_ROOT to the save_path
	_save_path = str(DATA_ROOT + _save_path)
	
	if !load_file.file_exists(_save_path):
		print("FileSaver.gd: No file saved! (at ", _save_path, ")")
		return null
		
	# Parse the file if it existes
	if load_file.open(_save_path, File.READ) != 0:
		print("FileSaver.gd: Error opening file! (at ", _save_path, ")")
		return null
	
	return load_file


# Saves a dictionary to a file as dictionary
func _save_to_file(_save_dict : Dictionary, _save_path : String, \
		_mkdir : bool) -> void:
	_save_path = str(DATA_ROOT + _save_path)
	
	# Create the directory if _mkdir and required
	if _mkdir:
		# Cut the file from the path
		var dir_sep = _save_path.rfind("/")
		var dir_path = _save_path.substr(0, dir_sep)
		var _error = make_directory(dir_path)
		if _error != OK:
			printerr("FileSaver.gd: Directory could not be opened at path ", \
				dir_path)
	
	var save_file = File.new()
	save_file.open(_save_path, File.WRITE)
	
	if !save_file.is_open():
		printerr("FileSaver.gd: File could not be opened at path ", _save_path, \
			". ", _save_dict, " was not saved!")
		return
	
	# serialize the data dictionary to JSON, "  " for pretty indents
	save_file.store_line(JSON.print(_save_dict, " "))
	
	# Write the JSON back
	save_file.close()


# Use this to check if a file exists
func make_directory(_path : String) -> int:
	var dir = Directory.new();
	if !dir.dir_exists(_path):
		return dir.make_dir_recursive(_path)
	return OK



# Deletes a directory with all it's subdirectories
func delete_directory_recursive(_path : String) -> void:
	var directory = Directory.new()
	var error = directory.open(_path)
	
	if error == OK:
		directory.list_dir_begin(true)
		var file_name = directory.get_next()
		
		while file_name != "":
			if directory.current_is_dir():
				delete_directory_recursive(_path + "/" + file_name)
			else:
				directory.remove(file_name)
			file_name = directory.get_next()
		
		directory.remove(_path)
	else:
		print("Error removing " + _path)
