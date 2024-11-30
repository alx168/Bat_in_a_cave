extends CanvasLayer

var label_template: String = "Prey Left: %d/%d"

func _update_objective_counter(
	_objectives_completed: int, 
	_objectives_total: int
) -> void:
	$ObjectiveLabel.text = label_template % [_objectives_completed, _objectives_total]
