extends CharacterBody2D

var speed_base_value = 100
var hitpoints_base_value = 10

@onready var max_hitpoints = Global.player_hitpoints_stat_multiplier * hitpoints_base_value
@onready var hitpoints = max_hitpoints
var is_alive = true
var current_direction = "down"
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var attack_in_progress = false

@onready var projectile = load("res://scenes/projectile.tscn")

signal player_died
signal player_health_changed
signal player_ammo_changed


func _ready() -> void:
	player_health_changed.emit()
	player_ammo_changed.emit()


func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack()
	if hitpoints <= 0:
		is_alive = false
		hitpoints = 0
		$DieAudio.play()
		emit_signal("player_died")


func player_movement(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		velocity.x = -1
	if Input.is_action_pressed("ui_down"):
		current_direction = "down"
		velocity.y = 1
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		velocity.y = -1
		
	if Input.is_action_just_pressed("shoot") and Global.player_ammo_stat > 0:
		shoot()

	if velocity.x == 0 and velocity.y == 0:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	else:
		if !attack_in_progress:
			play_animation(1)

	# Move diagonally at base speed
	velocity = velocity.normalized() * Global.player_movement_speed_stat_multiplier * speed_base_value

	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().name == "Objects" or collision.get_collider().name == "MapBorder":
			velocity = velocity.slide(collision.get_normal())
			move_and_collide(velocity * delta) # Glide along objects


func play_animation(movement) -> void:
	var dir  = current_direction
	var animation = $AnimatedSprite2D
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if !attack_in_progress:
				animation.play("side_idle")
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if !attack_in_progress:
				animation.play("side_idle")
	if dir == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if !attack_in_progress:
				animation.play("front_idle")
	if dir == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if !attack_in_progress:
				animation.play("back_idle")


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false


func player():
	pass


func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		hitpoints -= 10
		player_health_changed.emit()
		enemy_attack_cooldown = false
		$EnemyAttackCooldown.start()
		$HitAudio.play()


func _on_enemy_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func attack():
	var dir = current_direction
	if Input.is_action_just_pressed("Attack"):
		print("attack")
		Global.player_current_attack = true
		attack_in_progress = true
		$AttackAudio.play()
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$AttackCooldown.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$AttackCooldown.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$AttackCooldown.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$AttackCooldown.start()


func _on_attack_cooldown_timeout() -> void:
	$AttackCooldown.stop()
	Global.player_current_attack = false
	attack_in_progress = false


func shoot():
	print("shoot")
	Global.player_ammo_stat -= 1
	player_ammo_changed.emit()
	$ShootAudio.play()
		
	var instance = projectile.instantiate()
	instance.position = position
	if current_direction == "right":
		instance.direction.x = 1
	if current_direction == "left":
		instance.direction.x = -1
	if current_direction == "up":
		instance.direction.y = -1
	if current_direction == "down":
		instance.direction.y = 1
	get_parent().add_child.call_deferred(instance)
