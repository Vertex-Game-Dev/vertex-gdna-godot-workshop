
extends Node2D

const SPEED = 60
var direction = 1
var _defeated = false

# Get references to the slime's nodes
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stomp_area: Area2D = $StompArea
@onready var killzone: Area2D = $Killzone


func _ready() -> void:
	# Connect the stomp detection signal
	stomp_area.body_entered.connect(_on_stomp_area_body_entered)


func _process(delta):
	# Stop movement if the slime is defeated
	if _defeated:
		return

	# Change direction when hitting a wall
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	# Move the slime horizontally
	position.x += direction * SPEED * delta


func _on_stomp_area_body_entered(body: Node2D) -> void:
	# Ignore interactions if already defeated
	if _defeated:
		return

	# Check if the player lands on the slime from above
	if body.name == "Player" or body.is_in_group("player"):
		if body.velocity.y > 0:
			_defeated = true

			# Bounce the player upward
			body.apply_bounce(-300.0)

			# Disable further collision detection
			killzone.monitoring = false
			killzone.monitorable = false
			stomp_area.monitoring = false
			stomp_area.monitorable = false

			# Remove the defeated slime
			queue_free()
