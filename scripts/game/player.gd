extends CharacterBody2D

### UI ###
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@onready var flight_charge_bar = $FlightBar

### INPUTS ###
var input_flap: bool = false
var input_charge: bool = false

### PHYSICS ### https://www.youtube.com/watch?v=p3jDJ9FtTyM&t=58s
var grounded: bool = false
const flight_acceleration: float = -2
const gravity: float = .1
const terminal_fall_speed: float = 10

### GAMEPLAY ###
const max_flight_charge: float = 100
var flight_charge: float = 0
const flight_charge_step: float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	#flight_charge_bar.init_flight_charge(max_flight_charge)

# handle inputs and visuals
func _process(delta: float) -> void:
	var input_type: InputManager.InputType = InputManager.poll_input(delta)
	
	if input_type == InputManager.InputType.TAPPED:
		input_flap = true
	elif input_type == InputManager.InputType.HELD:
		input_charge
	
func _physics_process(delta: float) -> void:
	if input_flap:
		grounded = false
		var rotation_degrees: float = 30 if velocity.x<0 else -30
		velocity = velocity.rotated(deg_to_rad(rotation_degrees))
		# Vector2(0, flight_acceleration)
		input_flap = false
	elif not grounded:
		velocity += Vector2(0, gravity)
		
	if input_charge:
		print(flight_charge)
		flight_charge = flight_charge + flight_charge_step
		_set_flight_charge(flight_charge)
	#uncomment below if we want a decreasing bar effect
	#else:
		#flight_charge = flight_charge - flight_charge_step
		
	velocity = Vector2(velocity.x, clamp(velocity.y, -2*terminal_fall_speed, terminal_fall_speed))	
	var collisionInfo: KinematicCollision2D = move_and_collide(velocity)
	
	if collisionInfo != null:
			var grounded: bool = true
			velocity = Vector2.ZERO

func _set_flight_charge(value):
	flight_charge_bar.flight_charge = flight_charge
