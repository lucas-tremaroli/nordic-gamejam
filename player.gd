extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var player_size

func query_model():
	var response = []
	OS.execute("python_scripts/venv/bin/python", ["python_scripts/model_query.py", "A character that jumps high"], response)
	print(response[0])

func _ready():
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size
	# hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		query_model()
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO + player_size / 2, screen_size - player_size / 2)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk_horizontal"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x > 0
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "walk_down"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "walk_up"


func _on_body_entered(body: Node2D) -> void:
	hide() # Replace with function body.
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
