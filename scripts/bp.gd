extends Area2D

@export var bounce_strength: float = -500.0

var _on_cooldown: bool = false


func _on_body_entered(body: Node2D) -> void:
	print("Detected body: ", body.name)

	if _on_cooldown:
		return

	if body.name == "Player" or body.is_in_group("player"):
		body.apply_bounce(bounce_strength)
		_on_cooldown = true
		await get_tree().create_timer(0.4).timeout
		_on_cooldown = false
