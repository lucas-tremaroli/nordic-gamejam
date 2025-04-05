extends CharacterBody2D

var speed = 300
var health = 100
var player = null
var player_chase = false
var player_in_attack_zone = false

func _physics_process(delta: float) -> void:
	take_damage()
	if player_chase:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("walk")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")


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
