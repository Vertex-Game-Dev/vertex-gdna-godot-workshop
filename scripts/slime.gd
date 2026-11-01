extends Node2D

const SPEED = 60
const BOUNCE_FORCE = -300.0

var direction = 1
var defeated = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weakspot: Area2D = $weakspot
@onready var killzone_shape: CollisionShape2D = $Killzone/CollisionShape2D

func _process(delta):
	if defeated:
		return


	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta


func _on_weakspot_body_entered(body: Node2D) -> void:
	if defeated:
		return


	if body is CharacterBody2D and body.velocity.y > 0:
		if body.global_position.y < global_position.y:
			defeated = true

			body.velocity.y = BOUNCE_FORCE

			killzone_shape.set_deferred("disabled", true)
			weakspot.set_deferred("monitoring", false)

			queue_free.call_deferred()
