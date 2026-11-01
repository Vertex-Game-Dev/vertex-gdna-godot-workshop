extends Area2D

# Configurable bounce strength
@export var bounce_velocity: float = -500.0

# Track the player currently inside the mushroom
var player_in_pad: CharacterBody2D = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	# Connect Area2D signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Play idle animation
	animated_sprite.play("idle")


func _on_body_entered(body: Node2D) -> void:

	# Check whether the entering body is a player
	if body is CharacterBody2D:

		# Prevent repeated bouncing while inside
		if player_in_pad != null:
			return

		var player := body as CharacterBody2D

		# Apply upward bounce velocity
		player.velocity.y = bounce_velocity

		# Remember the player currently touching the pad
		player_in_pad = player

		# Play bounce animation if available
		if animated_sprite.sprite_frames.has_animation("bounce"):
			animated_sprite.play("bounce")


func _on_body_exited(body: Node2D) -> void:

	# Allow another bounce after the player leaves
	if body == player_in_pad:
		player_in_pad = null

		# Return to idle animation
		if animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")
