extends CharacterBody2D

### UI ###
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@onready var flight_charge_bar = $FlightBar
@onready var aim_indicator: Line2D = $AimIndicator
@onready var indicator_layer: CanvasLayer = $PlayerPerspective/IndicatorLayer
@onready var audio_stream = $AudioStreamPlayer2D

### INPUTS ###
var TAP_INTERAL: float = .25
var tap_stack: int = 0
var time_since_last_tap: float = 0.0
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
const FLIGHT_CHARGE_STEP: float = 2
var flight_charge: float = 0.0
const AIM_ROTATION_RATE: float = deg_to_rad(90.0)
var aim_direction: Vector2 = Vector2.RIGHT
var aim_rotation_direction: int = 1

### LEVEL STATE ### dunno if I like the player having to notify the level manager
@onready var level_manager: Node = get_node("/root/SceneRoot")

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
		tap_stack += 1
		time_since_last_tap = 0.0
	else:
		time_since_last_tap += delta
		
	if input_type == InputManager.InputType.HELD:
		held = true
	else:
		held = false
		
func _update_hud() -> void:	
	if is_grounded:
		aim_indicator.visible = true
		aim_indicator.position = aim_direction*50
		aim_indicator.points[1] = aim_indicator.position+aim_direction*50
		
		flight_charge_bar.visible = (flight_charge > 0.0)
		flight_charge_bar.flight_charge = flight_charge
	else:
		flight_charge_bar.visible = false
		aim_indicator.visible = false

func _process(delta: float) -> void:
	_collect_inputs(delta)
	_update_hud()

# handle state and physics
func _physics_process(delta: float) -> void:
	if is_grounded:
		audio_stream.stop()
		if held:
			flight_charge += FLIGHT_CHARGE_STEP
		elif flight_charge > 0.0:
			if tap_stack>0:
				velocity = aim_direction * MAX_JUMP_VELOCITY * flight_charge/100
				flight_charge = 0.0
				is_grounded = false
				tap_stack = 0
			else:
				flight_charge -= FLIGHT_CHARGE_STEP
		else: # bar isn't charged at all
			if pending_action:
				pass
			elif tap_stack>0:
				if time_since_last_tap > TAP_INTERAL and tap_stack==1:
					aim_rotation_direction *= -1
					tap_stack = 0
				elif tap_stack>=2:
					shoot_echo(position + 50*aim_direction, aim_direction)
					tap_stack = 0
			else:
				aim_direction = aim_direction.rotated(AIM_ROTATION_RATE*delta*aim_rotation_direction)
	else: # not is_grounded
		velocity += Vector2(0, GRAVITY)
		audio_stream.play()
		
		if tap_stack>0:
			if flap_rotation_buffer >= FLAP_ROTATION_BUFFER_THRESHOLD:
				flight_rotation_degrees = 30 if velocity.x<0 else -30
			velocity = velocity.rotated(deg_to_rad(flight_rotation_degrees))
			tap_stack = 0
			flap_rotation_buffer = 0.0
		else:
			flap_rotation_buffer += delta
			 
		if held:
			# TODO flap to slow down?
			pass
			
		velocity = Vector2(velocity.x, clamp(velocity.y, -2*TERMINAL_FALL_SPEED, TERMINAL_FALL_SPEED))	
		
	_handle_collisions(move_and_collide(velocity))
			
func _handle_collisions(_collision: KinematicCollision2D) -> void:
	if (_collision == null):
		return
	else:
		var collider = _collision.get_collider()
		
		if collider is TileMapLayer:
			is_grounded = true
			velocity = Vector2.ZERO
		elif 'prey' in collider.get_groups():
			collider.queue_free()
			level_manager._increment_objective_counter()
		elif 'hazard' in collider.get_groups():
			level_manager._die()

### STUFF FOR ECHO ABILITY
var echo_ray = preload("res://scenes/displays/echo_ray.tscn")
var echo_angles = range(-20, 21, 5)

func shoot_echo(_initial_position: Vector2, _aim_direction: Vector2) -> void:
	for angle in echo_angles:
		var e = echo_ray.instantiate()
		e._initialize(_initial_position, _aim_direction.rotated(deg_to_rad(angle)))
		indicator_layer.add_child(e)
		
	pass
