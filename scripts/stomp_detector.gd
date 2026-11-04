extends Area2D

@export var bounce_velocity: float = -400.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding body is the player
	if body.is_in_group("Player") and "velocity" in body:
		# Check if the player is falling downward (landing on it from above)
		if body.velocity.y > 0:
			# Apply upward bounce to the player
			body.velocity.y = bounce_velocity
			
			# Defeat the slime: get the parent (Slime node) and remove it
			var slime = get_parent()
			if slime:
				# Disable collisions immediately so it can't trigger again
				queue_free() # Or disable its collision shapes first
				slime.queue_free()
