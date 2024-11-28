class_name StartLevelOption
extends MenuOption

func _process_option_held(dTime: float) -> void:	
	get_tree().change_scene_to_file("res://player.tscn")
