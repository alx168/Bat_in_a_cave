extends Sprite2D

const LIFESPAN: float = 5.0
var timer: float = 0.0
	
func _initialize(_position: Vector2, _surface_normal: Vector2) -> void:
	position = _position
	rotation = _surface_normal.angle_to(Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += delta
	
	if timer >= LIFESPAN:
		queue_free()
