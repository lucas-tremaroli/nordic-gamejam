extends CharacterBody2D

var speed = 410
var health = 500
var is_alive = true
var current_direction = "none"
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var attack_in_progress = false


func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	
	if health <= 0:
		$AnimatedSprite2D.play("death")
		is_alive = false


func player_movement(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		velocity.x = speed
		velocity.y = 0
		if !attack_in_progress:
			play_animation(1)
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		velocity.x = -speed
		velocity.y = 0
		if !attack_in_progress:
			play_animation(1)
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		velocity.x = 0
		velocity.y = speed
		if !attack_in_progress:
			play_animation(1)
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		velocity.x = 0
		velocity.y = -speed
		if !attack_in_progress:
			play_animation(1)
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()


func play_animation(movement) -> void:
	var dir  = current_direction
	var animation = $AnimatedSprite2D
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if dir == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			animation.play("front_idle")
	if dir == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
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
		health -= 20
		print(health)
		enemy_attack_cooldown = false
		$EnemyAttackCooldown.start()


func _on_enemy_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func attack():
	var dir = current_direction
	if Input.is_action_just_pressed("Attack"):
		Global.player_current_attack = true
		attack_in_progress = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
