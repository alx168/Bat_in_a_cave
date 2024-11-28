# reference: https://www.youtube.com/watch?v=ZDPM45cHHlI&t=550s
class_name ControlConfigurationOption
extends MenuOption

# two variables that tell us if the user 
var is_button_freed: bool
var is_configuring: bool

func _ready() -> void:
	is_button_freed = false
	
func _input(event):
	if is_button_freed and (event is InputEventKey):
		print("hello")
		InputMap.action_add_event(InputManager.INPUT_EVENT_NAME, event)
		is_button_freed = false
		is_configuring = false

func _process_option_held(delta: float, held: bool) -> void:
	if held:
		is_configuring = true
	elif is_configuring and not held:
		is_button_freed = true
		InputMap.action_erase_events(InputManager.INPUT_EVENT_NAME)
 
