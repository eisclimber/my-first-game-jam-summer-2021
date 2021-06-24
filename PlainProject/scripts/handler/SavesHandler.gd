extends Node

const SAVES_PATH = "saves/saves.json"
const current_saves_version = 1

var save_dict = {}

func _ready():
	load_save_dict()


# Loads the current save dict or creates an empty if it doesn't exist
func load_save_dict():
	if FileIO.file_exists(SAVES_PATH):
		save_dict = FileIO.retrieve_json_from_file(SAVES_PATH)
	
	# Check all entries in the default saves dict. If they don't exist add them
	var default_save_dict = create_save_dict()
	var needs_saving = false
	for entry in default_save_dict:
		if !save_dict.has(entry):
			save_dict[entry] = default_save_dict[entry]
			needs_saving = true
	if needs_saving:
		save_save_dict()


# Saves the current save_dict
func save_save_dict():
	FileIO.save_json_to_file(save_dict, SAVES_PATH)


# Create a new save_dict filled with basic information
func create_save_dict() -> Dictionary:
	var dict = {}
	dict["version"] = self.current_saves_version
	dict["levels"] = {}
	
	return dict


# Loads all scores of the level (saves need to be loaded before)
# Returns an empty array if there are no scores for a level
# Each score object has the properties timestamp, cost, playTime and score as described in the docs
func get_scores(level_name: String) -> Array:
	var scores: Array = self.save_dict.get("levels", {}).get(level_name, [])
	var validated_scores = []
	
	for score_obj in scores:
		var timestamp = score_obj.get("timestamp")
		var cost = score_obj.get("cost")
		var play_time = score_obj.get("playTime")
		var score = score_obj.get("score")
		
		if (timestamp != null):
			timestamp = self._iso_utc_to_local_datetime(timestamp)
		
		if timestamp.get("year") != null \
			&& cost != null \
			&& play_time != null \
			&& score != null \
		:
			validated_scores.append({
				"timestamp": timestamp,
				"cost": int(cost),
				"playTime": int(play_time),
				"score": int(score)
			})
	
	return validated_scores


func save_score(level_name: String, play_time: int, cost: int, score: int):
	var level_scores = self.save_dict.get("levels", {}).get(level_name)
	
	if level_scores == null || typeof(level_scores) != TYPE_ARRAY:
		level_scores = []
		self.save_dict["levels"][level_name] = level_scores
	
	var utc_time = OS.get_datetime(true)
	
	level_scores.append({
		"timestamp": "%04d-%02d-%02dT%02d:%02d:%02dZ" %
			[utc_time.year, utc_time.month, utc_time.day, utc_time.hour, utc_time.minute, utc_time.second],
		"cost": cost,
		"playTime": play_time,
		"score": score
	})
	
	self.save_save_dict()


"""
Returns the best score (highscore) from the given scores
The given scores are expected to be in the format as get_scores()
Returns null if no score exists
"""
func get_best_score(scores: Array) -> Dictionary:
	var best_score = null
	
	for score in scores:
		if best_score == null || score.score > best_score.score:
			best_score = score
	
	return best_score


# Returns how much stars are earned when completing the level with the given score (3, 2, 1 or 0)
func earned_stars_in_level(level_info: Dictionary, score: int) -> int:
	if (score >= level_info.stars[2]):
		return 3
	elif (score >= level_info.stars[1]):
		return 2
	elif (score >= level_info.stars[0]):
		return 1
	else:
		return 0


# Returns sum of stars up to the given level
func cumulated_stars_until_level(level_id: String, include_level = false) -> int:
	var earned_stars = 0
	
	for level_key in ScenePaths.LEVELS.keys():
		if level_key == level_id && !include_level:
			break
		
		var level_info = ScenePaths.get_level_info(level_key)
		var best_score = self.get_best_score(self.get_scores(level_key))
		
		if best_score != null:
			earned_stars += self.earned_stars_in_level(level_info, best_score.score)
		
		if level_key == level_id:
			break
	
	return earned_stars


"""
Returns whether the given level is unlocked.
earned_stars: stars earned until this level (or stars that should be taken into account for unlocking the level)
"""
func is_level_unlocked_by_stars(level_info: Dictionary, earned_stars: int) -> bool:
	if OS.is_debug_build():
		return true
	
	if (earned_stars >= level_info.stars_required):
		return true
	else:
		return false


func is_level_unlocked(level_info: Dictionary) -> bool:
	if OS.is_debug_build():
		return true
	
	var stars = self.cumulated_stars_until_level(level_info.id, false)
	return self.is_level_unlocked_by_stars(level_info, stars)


func is_level_completed(_level_name : String) -> bool:
	var scores: Array = self.save_dict.get("levels", {}).get(_level_name, [])
	
	return scores != []



# Convert ISO 8601 string (only YYYY-MM-DDThh:mm:ssTZD with TZD = Z (UTC) supported) to datetime dictionary
# The returned datetime is localized to the user's time zone
# Returns empty dictionary if iso string is invalid
func _iso_utc_to_local_datetime(iso_date: String) -> Dictionary:
	var date: Array = iso_date.split("T")[0].split("-")
	var time: Array = iso_date.split("T")[1].trim_suffix("Z").split(":")
	
	if date.size() != 3 && time.size() != 3:
		return {}
	
	# Invalid "numbers" will result in 0
	var datetime_utc = {
		"year": int(date[0]),
		"month": int(date[1]),
		"day": int(date[2]),
		"hour": int(time[0]),
		"minute": int(time[1]),
		"second": int(time[2])
	}
	
	# Get offset from UTC (--> timezone)
	# Not sure if this takes DST (daylight saving time) into account
	# Using OS.get_time_zone_info() would definitely return wrong results because of a bug
	# https://github.com/godotengine/godot/issues/37571
	var current = OS.get_unix_time_from_datetime(OS.get_datetime())
	var current_utc = OS.get_unix_time_from_datetime(OS.get_datetime(true))
	var utc_offset = current - current_utc
	
	# Ugly converting because we don't have nice helpers
	var datetime_utc_unix = OS.get_unix_time_from_datetime(datetime_utc)
	var datetime = OS.get_datetime_from_unix_time(datetime_utc_unix + utc_offset)
	
	return datetime
