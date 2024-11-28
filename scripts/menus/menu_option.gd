class_name MenuOption
extends Control

var option_current_hold_duration: float = 0.0
var option_confirm_hold_threhold: float = 3.0
var option_style: StyleBoxFlat = get_theme_stylebox("panel")

func _process_option_held(dTime: float) -> void:
	print("Godot apparently doesn't have abstract base classes... override me!")
