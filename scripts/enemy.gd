extends CharacterBody2D

const SPEED : int = 200
const HEALTH : int = 100
const CHANGE_DIR_TIME := 1.5

var player = null
var player_chase : bool = false
var player_in_attack_zone : bool = false
var direction := Vector2.ZERO
var change_dir_timer := 0.0

func _physics_process(delta: float) -> void:
	take_damage()
	if player_chase:
		position += (player.position - position) / SPEED
		$AnimatedSprite2D.play("walk")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		change_dir_timer -= delta
		if change_dir_timer <= 0:
			pick_new_direction()
		velocity = direction * SPEED
		move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	$EnemyEngageAudioStreamPlayer.play()


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false


func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false


func take_damage():
	pass


func pick_new_direction():
	direction.x = randf_range(-SPEED, SPEED)
	direction.y = randf_range(-SPEED, SPEED)
	direction = direction.normalized()
	change_dir_timer = CHANGE_DIR_TIME
