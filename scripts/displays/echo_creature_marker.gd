extends Node2D

var lifespan: float = 5.0
var timer: float = 0.0
	
func _initialize(_lifespan: float, creature: CharacterBody2D) -> void:
	lifespan = _lifespan
	global_position = creature.position
	var shape = creature.get_node("CollisionShape2D").shape
	
	if shape is CircleShape2D:
		scale.x = shape.radius*2
		scale.y = shape.radius*2
	elif shape is RectangleShape2D:
		scale = shape.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += delta
	
	if timer >= lifespan:
		queue_free()
