extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2

var jump_count = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Reset jump count when player lands
	if is_on_floor():
		jump_count = 0

	# Handle normal jump and double jump
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get horizontal movement direction
	var direction := Input.get_axis("move_left", "move_right")

	# Handle sprite direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Handle animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	# Handle horizontal movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply movement
	move_and_slide()
