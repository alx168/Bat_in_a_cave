extends CharacterBody2D

const LIFESPAN: float = 5.0
const SPEED: float = 3.0
var timer: float = 0.0
var echo_terrain_indicator = preload("res://scenes/echo_terrain_indicator.tscn")
	
func _initialize(_position: Vector2, _direction: Vector2) -> void:
	velocity = SPEED * _direction
	position = _position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += delta
	
	if timer >= LIFESPAN:
		queue_free()
	else:
		var coll: KinematicCollision2D = move_and_collide(velocity)
		
		if coll != null:
			# bounce the ray
			var n: Vector2 = coll.get_normal()
			velocity = velocity - 2*(velocity.dot(n))*n
			
			# paint something to the screen to indicate the bounce
			var i = echo_terrain_indicator.instantiate()
			i._initialize(position, n)
			add_sibling(i)
		
		
