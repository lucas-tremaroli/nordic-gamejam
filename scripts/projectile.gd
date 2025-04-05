extends CharacterBody2D

@export var speed = 1000
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity = direction.normalized()
	velocity = velocity * speed
	move_and_slide()
