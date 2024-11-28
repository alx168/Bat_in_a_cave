class_name VolumeOption
extends MenuOption

var volume_slider: HSlider
var volume_change_rate: float = 20
var volume_float: float = 100 # storing as a float because the slider truncates updates that are too small

func _ready() -> void:
	volume_float = 50.0
	volume_slider = get_node(".")
	volume_slider.value = volume_float

func _process_option_held(dTime: float, held: bool) -> void:
	if held:
		volume_float += volume_change_rate*dTime
		volume_slider.value = volume_float
	else:
		volume_float -= volume_change_rate*dTime
		volume_slider.value = volume_float
		
	volume_float = clamp(volume_float, 0.0, 100.0)
	
