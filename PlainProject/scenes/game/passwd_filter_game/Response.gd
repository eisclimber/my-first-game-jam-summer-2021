extends VBoxContainer

func set_text(input: String, response: String):
	$InHist.text = " > " + input
	$Response.text = response

func set_storyline(storyline: String):
	$Response.text = storyline
