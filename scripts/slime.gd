extends Node2D

const SPEED = 60
const STOMP_BOUNCE = -250.0
var direction = 1
var is_dead := false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stomp_area: Area2D = $StompArea
@onready var killzone: Area2D = $Killzone

func _ready() -> void:
	stomp_area.body_entered.connect(_on_stomp_area_body_entered)

func _process(delta):
	if is_dead:
		return

	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	position.x += direction * SPEED * delta

func _on_stomp_area_body_entered(body: Node2D) -> void:
	if is_dead or not (body is CharacterBody2D):
		return
	# Only count it as a stomp if the player is falling onto the slime
	if body.velocity.y <= 0 or body.is_on_floor():
		return
	_die(body)

func _die(player: CharacterBody2D) -> void:
	is_dead = true
	# Stop the slime from hurting the player or triggering again
	killzone.set_deferred("monitoring", false)
	stomp_area.set_deferred("monitoring", false)
	# Bounce the player
	player.velocity.y = STOMP_BOUNCE
	# Death visual, then remove
	if animated_sprite.sprite_frames.has_animation("death"):
		animated_sprite.play("death")
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
