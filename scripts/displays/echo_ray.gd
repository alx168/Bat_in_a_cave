extends CharacterBody2D

const LIFESPAN: float = 10.0
const SPEED: float = 5.0
var timer: float = 0.0
const echo_terrain_indicator = preload("res://scenes/displays/echo_terrain_marker.tscn")
const echo_predator_indicator = preload("res://scenes/displays/echo_predator_marker.tscn")
const echo_prey_indicator = preload("res://scenes/displays/echo_prey_marker.tscn")

	
func _initialize(_position: Vector2, _direction: Vector2) -> void:
	velocity = SPEED * _direction
	position = _position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += delta
	
	if timer >= LIFESPAN:
		queue_free()
	else:
		var time_left: float = LIFESPAN - timer
		var collision: KinematicCollision2D = move_and_collide(velocity)
		
		if collision != null:
			var collider = collision.get_collider()
			
			if collider is TileMapLayer:
				# bounce the ray
				var n: Vector2 = collision.get_normal()
				velocity = velocity - 2*(velocity.dot(n))*n
				
				# paint something to the screen to indicate the bounce
				var i = echo_terrain_indicator.instantiate()
				i._initialize(time_left, position, n)
				add_sibling(i)
			elif 'prey' in collider.get_groups():
				# if hit creature, create an indicator, and destroy the echo
				var i = echo_prey_indicator.instantiate()
				i._initialize(time_left, collider)
				add_sibling(i)
				queue_free()
			elif 'hazard' in collider.get_groups():
				var i = echo_predator_indicator.instantiate()
				i._initialize(time_left, collider)
				add_sibling(i)
				queue_free()
			
		
		
