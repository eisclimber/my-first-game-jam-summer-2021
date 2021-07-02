extends WindowDialog

onready var button = $Button
onready var startingPanel = $StartingPanel
onready var installLocPanel = $"Install Location"
onready var progressPanel = $"Installation progress"

onready var loadingIcon = $AnimatedSprite
onready var threatLabel = $"Installation progress/Threat label"
onready var progressBar = $"Installation progress/ProgressBar"

onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	button.connect("pressed", self, "panel_start")

#	Called when the NEXT button is pressed
#	just hides and shows next next panel
func panel_start():
	startingPanel.hide()
	installLocPanel.show()
	
	loadingIcon.show()
	loadingIcon.playing = true
	
	button.disconnect("pressed", self, "panel_start")
	button.connect("pressed", self, "install_location_panel")

#	Same as above, but with progress bar panel
func install_location_panel():
	installLocPanel.hide()
	progressPanel.show()
	
	button.disabled = true
	simulate_progress()
	
#	Does a fake progress bar
#	Shows a threatening message in the end...
func simulate_progress():
	var letterFactor = 0.05
	var threateningStr = \
		"I have to show you something first..."
	var maxLength = threateningStr.length()
	var letter = 0
	
	threatLabel.text = ""
	
	tween.interpolate_property(
		progressBar, "value",
		0, 66.6, 2.3,
		Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	
	yield(get_tree().create_timer(2.3), "timeout")
	
	while threatLabel.text.length() < maxLength:
		threatLabel.text += threateningStr[letter]
		letter += 1
		yield(get_tree().create_timer(letterFactor), "timeout")
	
	print("[DEBUG]	Done")
