class_name VolumeOption
extends MenuOption

#func _ready() -> void:
	## TODO get initial volume
	#pass # Replace with function body.

func _process_option_held(held: bool, dTime: float) -> void:
	# TODO while option is selected, decrease the volume,
	# but if the button is being held, (slowly) increase the volume
	if has_focus() and not held:
		pass
	elif not has_focus() and held:
		pass