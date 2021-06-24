tool
extends OptionButton
class_name LocaleSelect

# Connnect signals on ready
func _ready() -> void:
	var _error1 = connect("pressed", self, "_on_LocaleSelect_pressed")
	var _error2 = connect("item_selected", self, "_on_LocaleSelect_item_selected")
	mouse_default_cursor_shape = CURSOR_POINTING_HAND
	setup_locales()


# Load and add all supported Locales
func setup_locales() -> void:
	var locales = TranslationServer.get_loaded_locales()
	var active_locale = Settings.get_locale()
	items = []
	for i in range(locales.size()):
		# Add the name of the locale as label
		var locale_name = TranslationServer.get_locale_name(locales[i])
		# Add the item to the optionButton
		add_item(locale_name)
		# Add the UNIX locale name as metadata
		set_item_metadata(i, locales[i])
		# Check if the locale is the active/saved locale
		if locales[i] == active_locale:
			selected = i


# Changes the locale if a Locale is selected
func _on_LocaleSelect_item_selected(_idx : int) -> void:
	Settings.set_locale(get_item_metadata(_idx))


# Play click_up uppon mouse release
func _on_LocaleSelect_pressed() -> void:
	AudioHandler.play_sound("sounds.menu_button_released")
