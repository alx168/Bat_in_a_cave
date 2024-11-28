class_name StartLevelOption
extends MenuOption

func _process_option_held(held: bool, dTime: float) -> void:
	if held:
		option_current_hold_duration += dTime
		
		if option_current_hold_duration > option_confirm_hold_threhold:
			get_tree().change_scene_to_file("res://player.tscn")
