extends Node


func _ready():
	var locale = Settings.get_locale()
	# Set the localization to english
	TranslationServer.set_locale(locale)
