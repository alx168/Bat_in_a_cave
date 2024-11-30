extends Node

### DISPLAY ###
@onready var hud: CanvasLayer = $Player/PlayerPerspective/HUDLayer

### GAME STATE ###
var preys: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# find data of interest in game world
	preys = get_tree().get_nodes_in_group("prey")
	
	# update HUD
	# hud._update_objective_counter(0, preys.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
