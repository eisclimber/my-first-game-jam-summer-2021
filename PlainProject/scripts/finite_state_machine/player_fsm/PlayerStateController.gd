extends StateController
class_name PlayerStateController


# Use inheritage to define a mapping between state ids and their node paths
func initialize_states_map():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"fall": $Fall
	}
