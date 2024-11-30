extends CharacterBody2D

const ECHO_LIFESPAN: float = 5.0
const ECHO_SPEED: float = 3.0
var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('hello')
	pass # Replace with function body.
	
func _initialize(_position: Vector2, _direction: Vector2) -> void:
	velocity = ECHO_SPEED * _direction
	position = _position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += delta
	
	if timer >= ECHO_LIFESPAN:
		queue_free()
	else:
		var coll: KinematicCollision2D = move_and_collide(velocity)
		
		if coll != null:
			var n: Vector2 = coll.get_normal()
			velocity = velocity - 2*(velocity.dot(n))*n
		
		
