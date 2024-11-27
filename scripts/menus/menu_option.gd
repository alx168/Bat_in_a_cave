@tool
class_name MenuOption
extends Node

var option_current_hold_duration: float = 0.0
var option_confirm_hold_threhold: float = 3.0
var option_is_highlighted: bool = false
var option_style: StyleBoxFlat
var bg_color_highlighted: Color = Color("#6495ED")
var bg_color_unhighlighted: Color = Color("#B0C4DE")

func _ready() -> void:
	option_style = StyleBoxFlat.new()
	option_style.set_bg_color(bg_color_unhighlighted)

func _process_option_held(held: bool, dTime: float) -> void:
	print("Godot apparently doesn't have abstract base classes... override me!")

func _set_highlighted(is_highlighed: bool):
	option_is_highlighted = is_highlighed
	option_current_hold_duration = 0.0
	option_style.set_bg_color( # Alex, I hope you never find this, but I LOVE ternaries
		bg_color_highlighted
		if is_highlighed
		else bg_color_unhighlighted
	)
