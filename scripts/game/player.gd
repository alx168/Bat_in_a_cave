extends CharacterBody2D

### UI ###
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@onready var flight_charge_bar = $FlightBar
@onready var aim_indicator: Line2D = $AimIndicator

### INPUTS ###
var tapped: bool = false
var held: bool = false
var pending_action: bool = false

### PHYSICS ### https://www.youtube.com/watch?v=p3jDJ9FtTyM&t=58s
var is_grounded: bool = false
const GRAVITY: float = .1
const TERMINAL_FALL_SPEED: float = 7.5
const FLAP_ROTATION_BUFFER_THRESHOLD: float = .3
const MAX_JUMP_VELOCITY: float = 1.5*TERMINAL_FALL_SPEED
var flap_rotation_buffer: float = FLAP_ROTATION_BUFFER_THRESHOLD # how long we'll keep rotating with flaps before changing direction
var flight_rotation_degrees: float = 30

### GAMEPLAY ###
const MAX_FLIGHT_CHARGE: float = 100
const FLIGHT_CHARGE_STEP: float = 1
var flight_charge: float = 0.0
const AIM_ROTATION_RATE: float = deg_to_rad(90.0)
var aim_direction: Vector2 = Vector2.RIGHT
var aim_rotation_direction: int = 1

func _ready() -> void:
	screen_size = get_viewport_rect().size
	#flight_charge_bar.init_flight_charge(MAX_FLIGHT_CHARGE)
 
# handle inputs and visuals
func _collect_inputs(delta:float) -> void:
	var input_type: InputManager.InputType = InputManager.poll_input(delta)
	
	if input_type == InputManager.InputType.INDETERMINATE:
		pending_action = true
	else:
		pending_action = false
		
	if input_type == InputManager.InputType.TAPPED:
		tapped = true
	elif input_type == InputManager.InputType.HELD:
		held = true
	else:
		held = false
		
func _update_hud() -> void:	
	if is_grounded:
		flight_charge_bar.visible = true
		flight_charge_bar.flight_charge = flight_charge
		
		aim_indicator.visible = true
		aim_indicator.position = aim_direction*50
		aim_indicator.points[1] = aim_indicator.position+aim_direction*50
	else:
		flight_charge_bar.visible = false
		aim_indicator.visible = false

func _process(delta: float) -> void:
	_collect_inputs(delta)
	_update_hud()

# handle state and physics
func _physics_process(delta: float) -> void:
	if is_grounded:
		if held:
			flight_charge += FLIGHT_CHARGE_STEP
		elif flight_charge > 0.0:
			if tapped:
				velocity = aim_direction * MAX_JUMP_VELOCITY * flight_charge/100
				flight_charge = 0.0
				is_grounded = false
				tapped = false
			else:
				flight_charge -= FLIGHT_CHARGE_STEP
		else:
			if pending_action:
				pass
			elif tapped:
				aim_rotation_direction *= -1
				tapped = false
			else:
				aim_direction = aim_direction.rotated(AIM_ROTATION_RATE*delta*aim_rotation_direction)
				
		#uncomment below if we want a decreasing bar effect
		#else:
			#flight_charge = flight_charge - FLIGHT_CHARGE_STEP
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
			is_grounded = true
			velocity = Vector2.ZERO
	
