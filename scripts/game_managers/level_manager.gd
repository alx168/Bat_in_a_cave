class_name LevelManager
extends Node

### DISPLAY ###
@onready var hud: CanvasLayer = $Player/PlayerPerspective/HUDLayer

### GAME STATE ###
var objective_total: int
var objective_found: int

func _ready() -> void:
	# find data of interest in game world
	var preys: Array  = get_tree().get_nodes_in_group("prey")
	objective_found = 0
	objective_total = preys.size()
	_refresh_hud()
	
func _refresh_hud() -> void:
	hud._update_objective_counter(objective_found, objective_total)
	
func _increment_objective_counter():
	objective_found += 1
	_refresh_hud()
	
	if objective_found >= objective_total:
		print("maybe we should yell at the player for like 5 seconds and tell them they won")
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
