extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Variables to track double jumping
var jump_count: int = 0
const MAX_JUMPS: int = 2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# Reset the jump counter whenever the player is on the ground
		jump_count = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		# Allow a jump if on the floor OR if they haven't used up all jumps yet
		if is_on_floor() or jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jump_count += 1

	# Get the direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the the player
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
