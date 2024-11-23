extends CharacterBody2D

### UI ###
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

### INPUTS ###
var input_flap: bool = false

### PHYSICS ###
var grounded: bool = false
const flight_acceleration: float = -2
const gravity: float = .1
const terminal_fall_speed: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# handle inputs and visuals
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("button_press"):
		input_flap = true
	
func _physics_process(delta: float) -> void:
	if input_flap:
		grounded = false
		velocity += Vector2(0, flight_acceleration)
		input_flap = false
	elif not grounded:
		velocity += Vector2(0, gravity)
		
	velocity = velocity.clamp(Vector2(0, -100), Vector2(0, terminal_fall_speed))	
	var collisionInfo: KinematicCollision2D = move_and_collide(velocity)
	
	if collisionInfo != null:
			var grounded: bool = true
			velocity = Vector2.ZERO
	
	
