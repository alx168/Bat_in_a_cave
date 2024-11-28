extends Node

const INPUT_EVENT_NAME: String = "button_press"
var input: InputType
var input_hold_duration: float
const input_hold_threshold: float = .3 # https://www.reddit.com/r/gamedev/comments/mjdcrw/is_there_a_standard_length_of_time_to_determine/gtavk4s/

enum InputType {
	NONE,
	TAPPED,
	HELD
}  

func _ready() -> void:
	input = InputType.NONE
	input_hold_duration = 0.0
	
func poll_input(dTime: float) -> InputType:
	# I think this implementation will work assuming
	# there's only one consumer
	if Input.is_action_pressed(INPUT_EVENT_NAME):
		input_hold_duration += dTime
		
		return (
			InputType.HELD 
			if input_hold_duration > input_hold_threshold 
			else InputType.NONE
		)
	else:
		var ret: InputType = (
			InputType.TAPPED
			if (
				(input_hold_duration > 0.0)
				and (input_hold_duration < input_hold_threshold)
			) else InputType.NONE 
		)
		
		input_hold_duration = 0.0
		return ret
