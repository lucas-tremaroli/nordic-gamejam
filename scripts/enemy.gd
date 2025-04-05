extends CharacterBody2D

const SPEED : int = 40
const CHANGE_DIR_TIME := 1.5

var player_attack_strength_base_value = 20
@onready var player_attack_strength = Global.player_attack_strength_stat_multiplier * player_attack_strength_base_value


var player = null
var health : int = 100
var player_chase : bool = false
var player_in_attack_zone : bool = false
var direction := Vector2.ZERO
var change_dir_timer := 0.0
var can_take_damage = true


func _physics_process(delta: float) -> void:
	take_damage()
	update_health()
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
	if player_in_attack_zone and Global.player_current_attack:
		if can_take_damage:
			$CanTakeDamageCooldown.start()
			can_take_damage = false
			health = health - player_attack_strength
			if health <= 0:
				self.queue_free()


func pick_new_direction():
	direction.x = randf_range(-SPEED, SPEED)
	direction.y = randf_range(-SPEED, SPEED)
	change_dir_timer = CHANGE_DIR_TIME


func _on_can_take_damage_cooldown_timeout() -> void:
	can_take_damage = true


func update_health():
	var healthbar = $ProgressBar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
