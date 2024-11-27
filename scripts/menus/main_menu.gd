@tool
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
	all_menu_options[highlighted_option_index]._set_highlighted(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("button_press"):
		# highlight tne next menu option, and let the options
		all_menu_options[highlighted_option_index]._set_highlighted(false)
		highlighted_option_index = (highlighted_option_index+1)%len(all_menu_options)
		all_menu_options[highlighted_option_index]._set_highlighted(true)
	else:
		# assert(false, "TODO detect if the button was pressed _and_ held")
		var held: bool = false # TODO detect if the button was pressed _and_ held
		all_menu_options[highlighted_option_index]._process_option_held(held, delta)
