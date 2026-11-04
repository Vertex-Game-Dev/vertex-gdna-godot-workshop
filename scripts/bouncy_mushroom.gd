class_name BouncyMushroom
extends Area2D

@export_category("Bounce Settings")
## The upward velocity applied to the player (negative is upward in Godot 2D).
@export var bounce_strength: float = -500.0
## Short cooldown to prevent unintended rapid re-triggering while in contact.
@export var bounce_cooldown: float = 0.1



var _can_bounce: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	
	

	# Verify the entering body is the player and has a velocity property
	if body.is_in_group("Player") and "velocity" in body:
		# Apply upward velocity while preserving existing horizontal movement
		body.velocity.y = bounce_strength
		
		
		
			
		# Temporarily disable triggers to avoid multi-frame spamming
		_can_bounce = false
		get_tree().create_timer(bounce_cooldown).timeout.connect(func(): _can_bounce = true)
