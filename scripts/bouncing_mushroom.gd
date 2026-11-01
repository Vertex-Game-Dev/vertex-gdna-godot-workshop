extends Area2D

@export var bounce_velocity: float = -450.0
@export var cooldown: float = 0.3

var _can_bounce := true

@onready var sprite: Sprite2D = $Sprite2D
@onready var base_scale: Vector2 = sprite.scale

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not _can_bounce or not (body is CharacterBody2D):
		return
	# Only bounce when the player lands from above
	if body.global_position.y > global_position.y:
		return
	_can_bounce = false
	body.velocity.y = bounce_velocity
	_squash()
	await get_tree().create_timer(cooldown).timeout
	_can_bounce = true

func _squash() -> void:
	var tween := create_tween()
	tween.tween_property(sprite, "scale", base_scale * Vector2(1.3, 0.7), 0.08)
	tween.tween_property(sprite, "scale", base_scale, 0.15)
