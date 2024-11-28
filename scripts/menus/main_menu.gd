extends Node

var all_menu_options: Array
var highlighted_option_index: int

func _ready():
	# set the highlighted menu option to the highest one in the Scene Hierarchy
	# tell the button that it's highlighted, in case 
	# TODO how tf do I do this - although the children are being initialized, I can't access their `_set_highlighted` method
	highlighted_option_index = 0
	all_menu_options = []
	all_menu_options = get_tree().get_nodes_in_group("menu_options")
	print(len(all_menu_options))
	all_menu_options[highlighted_option_index].grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var user_input: InputManager.InputType = InputManager.poll_input(delta)
	
	if user_input == InputManager.InputType.TAPPED:
		# highlight tne next menu option, and let the options know
		all_menu_options[highlighted_option_index].release_focus()
		highlighted_option_index = (highlighted_option_index+1)%len(all_menu_options)
		all_menu_options[highlighted_option_index].grab_focus()
	elif user_input == InputManager.InputType.HELD:
		all_menu_options[highlighted_option_index]._process_option_held(delta)
