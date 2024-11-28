extends CharacterBody2D

### UI ###
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@onready var flight_charge_bar = $FlightBar
@onready var aim_indicator: Line2D = $AimIndicator

### INPUTS ###
var tapped: bool = false
var held: bool = false

### PHYSICS ### https://www.youtube.com/watch?v=p3jDJ9FtTyM&t=58s
var is_grounded: bool = false
const GRAVITY: float = .1
const TERMINAL_FALL_SPEED: float = 7.5
const FLAP_ROTATION_BUFFER_THRESHOLD: float = .3
var flap_rotation_buffer: float = FLAP_ROTATION_BUFFER_THRESHOLD # how long we'll keep rotating with flaps before changing direction
var flight_rotation_degrees: float = 30

### GAMEPLAY ###
const max_flight_charge: float = 100
var flight_charge: float = 0
const flight_charge_step: float = 0.1

func _ready() -> void:
	screen_size = get_viewport_rect().size
	#flight_charge_bar.init_flight_charge(max_flight_charge)

# handle inputs and visuals
func _collect_inputs(delta:float) -> void:
	var input_type: InputManager.InputType = InputManager.poll_input(delta)
	
	if input_type == InputManager.InputType.TAPPED:
		tapped = true
	elif input_type == InputManager.InputType.HELD:
		held = true
		
func _update_hud() -> void:
	aim_indicator.global_position = position+velocity*20

func _process(delta: float) -> void:
	_collect_inputs(delta)
	_update_hud()

# handle state and physics
func _physics_process(delta: float) -> void:
	if is_grounded:
		if tapped:
			# TODO mirror aim rotation
			pass
		elif held:
			print(flight_charge)
			flight_charge = flight_charge + flight_charge_step
			_set_flight_charge(flight_charge)
		#uncomment below if we want a decreasing bar effect
		#else:
			#flight_charge = flight_charge - flight_charge_step
	else: # not is_grounded
		velocity += Vector2(0, GRAVITY)
		
		if tapped:
			if flap_rotation_buffer >= FLAP_ROTATION_BUFFER_THRESHOLD:
				print("flipping")
				flight_rotation_degrees = 30 if velocity.x<0 else -30
			velocity = velocity.rotated(deg_to_rad(flight_rotation_degrees))
			tapped = false
			flap_rotation_buffer = 0.0
		else:
			flap_rotation_buffer += delta
			 
		if held:
			# TODO flap to slow down?
			pass
			
			
		velocity = Vector2(velocity.x, clamp(velocity.y, -2*TERMINAL_FALL_SPEED, TERMINAL_FALL_SPEED))	
		
		if move_and_collide(velocity) != null:
			var is_grounded: bool = true
			velocity = Vector2.ZERO


func _set_flight_charge(value):
	flight_charge_bar.flight_charge = flight_charge
