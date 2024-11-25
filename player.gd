extends CharacterBody2D

### UI ###
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@onready var flight_charge_bar = $FlightBar

### INPUTS ###
var input_flap: bool = false

### PHYSICS ###
var grounded: bool = false
const flight_acceleration: float = -2
const gravity: float = .1
const terminal_fall_speed: float = 5

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
	#print(flight_charge)
	if Input.is_action_just_pressed("button_press"):
		input_flap = true
	if Input.is_action_pressed("button_press") and flight_charge < max_flight_charge:
		#testing flight values
		flight_charge = flight_charge + flight_charge_step
	#uncomment below if we want a decreasing bar effect
	#elif not Input.is_action_pressed("button_press") and flight_charge >= 0:
		#flight_charge = flight_charge - flight_charge_step
	_set_flight_charge(flight_charge)
	
func _physics_process(delta: float) -> void:
	print(flight_charge)
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

func _set_flight_charge(value):
	flight_charge_bar.flight_charge = flight_charge
