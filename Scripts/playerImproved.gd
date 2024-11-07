extends CharacterBody2D
const DashGhost = preload("res://Scenes/Entities/DashGhost.tscn")
@onready var ghostTimer: Timer = $GhostTimer
@onready var dashTimer: Timer = $DashTimer

const SPEED = 450.0
const JUMP_VELOCITY = -750.0

const JUMP_GRAVITY = 2500
const FALL_GRAVITY = 4000
const WALL_SLIDE_GRAVITY = 1000
var currentGrav = Vector2(0, JUMP_GRAVITY)
@onready var sprite: AnimatedSprite2D = $Sprite

enum States {IDLE, RUNNING, JUMP, DASH, FALL, WALL_SLIDING, FAST_FALL}
var state: States = States.IDLE

# Dashing vars
var dashDirection = Vector2(1, 0)
var canDash = false
# Jumping vars
var canJump = true

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var vertDirection := Input.get_axis("up", "down")
	# Add the gravity.
	if not is_on_floor() and state != States.DASH:
		velocity += currentGrav * delta
		if velocity.y < 0:
			set_state(2) # Set Jump
		elif vertDirection > 0:
			set_state(6) # Set FastFall
		else: set_state(4) # Set Fall
	
	canJump = is_on_floor()
	
	if is_on_wall():
		set_state(5)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and canJump:
		if state == States.WALL_SLIDING:
			velocity.y = JUMP_VELOCITY
			velocity.x = -direction * SPEED
			canJump = false
		else:
			velocity.y = JUMP_VELOCITY
			canJump = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction or vertDirection:
		if state != States.DASH:
			velocity.x = direction * SPEED
			if is_on_floor(): set_state(1, vertDirection)
		dash(direction, vertDirection)
	else:
		if state != States.DASH:
			velocity.x = move_toward(velocity.x, 0, 150)
			if is_on_floor(): set_state(0)
	
	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite.flip_h = isLeft

# allows for variable jump height
func _input(event):
	if event.is_action_released("jump"):
		if velocity.y < 0.0:
			velocity.y *= 0.5
			
func dash(direction: int, vertDirection: float) -> void:
	if is_on_floor():
		canDash = true
		
	if Input.is_action_just_pressed("dash") and canDash:
		dashDirection = Vector2(direction, vertDirection)
		velocity = dashDirection.normalized() * 1000
		canDash = false
		set_state(3)
		ghostTimer.start()
		dashTimer.start()
	
	if state == States.DASH:
		velocity = dashDirection.normalized() * 1000

func set_state(newState: int, vertDirection = 0.0) -> void:
	var previousState = state
	state = newState
	
	if state != previousState:
		if state == States.IDLE:
			sprite.animation = "idle"
		elif state == States.RUNNING:
			if vertDirection == 1.0:
				sprite.animation = "ground"
			elif vertDirection == -1.0:
				sprite.animation = "groundUp"
			else: sprite.animation = "running" 
		elif state == States.FALL:
			currentGrav = Vector2(0, FALL_GRAVITY)
			sprite.animation = "fall"
		elif state == States.FAST_FALL:
			currentGrav = Vector2(0, FALL_GRAVITY)*3
			sprite.animation = "fall"
		elif state == States.JUMP:
			if previousState == States.FALL:
				# Set to Fall state
				velocity.y = 0
				set_state(4)
			else:
				currentGrav = Vector2(0, JUMP_GRAVITY)
				sprite.animation = "jump"
		elif state == States.WALL_SLIDING:
			canJump = true
			currentGrav = Vector2(0, WALL_SLIDE_GRAVITY)
			sprite.animation = "groundUp"

func instance_ghost() -> void:
	var ghost = DashGhost.instantiate()
	get_parent().add_child(ghost)
	
	var currentFrameIndex = sprite.frame
	var currSprite = sprite.sprite_frames.get_frame_texture("running", currentFrameIndex)
	ghost.texture = currSprite
	
	ghost.global_position = global_position
	ghost.flip_h = sprite.flip_h


func _on_ghost_timer_timeout() -> void:
	instance_ghost()


func _on_dash_timer_timeout() -> void:
	ghostTimer.stop()
	# Set state to fall after dash
	set_state(4)
