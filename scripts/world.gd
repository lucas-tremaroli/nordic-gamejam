extends Node2D

@onready var player = $Player
@onready var health_bar
@onready var hours_slept_label

@export var enemy_scene : PackedScene
var enemy_timer = 0
var enemy_timer_threshold : int = 4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("player_died", Callable(self, "_on_player_died"))
	player.connect("player_health_changed", Callable(self, "_on_player_health_update"))
	health_bar = get_node("CanvasLayer/HealthBar")
	hours_slept_label = get_node("CanvasLayer/HoursSlept")
	
	Global.seconds_survived = 0
	Global.score = 0
	$ScoreTimer.start()


func _on_player_died():
	print("Player has died")
	
	$ScoreTimer.stop()
	var score_screen = preload("res://scenes/SleepScoreScreen.tscn").instantiate()
	
	add_child(score_screen)
	score_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_timer += delta
	spawn_enemies()
	if $BackgroundMusicAudioStreamPlayer.playing == false:
		$BackgroundMusicAudioStreamPlayer.play()


func end_dream_and_show_score(hours_slept: float):
	var score_screen = preload("res://scenes/SleepScoreScreen.tscn").instantiate()
	add_child(score_screen)
	score_screen.set_score(hours_slept)
	# Optional: Pause the game while the screen is shown
	get_tree().paused = true
	#score_screen.pause_mode = Node.PAUSE_MODE_PROCESS


func spawn_enemies():
	if enemy_timer > enemy_timer_threshold:
		var enemy = enemy_scene.instantiate()
		var enemy_spawn_location = $EnemySpawnPath/EnemySpawnPathFollow
		enemy_spawn_location.progress_ratio = randf()
		enemy.position = enemy_spawn_location.position
		add_child(enemy)
		enemy_timer = 0

	
func _on_player_health_update():
	print("HEALTHBAR VALUE: ", player.hitpoints)
	health_bar.value = player.hitpoints * 100 / player.max_hitpoints


func _on_score_timer_timeout() -> void:
	Global.seconds_survived += 1
	Global.score = floor(Global.seconds_survived / 20)
	hours_slept_label.text = "Hours slept: " + str(Global.score) + "/10"
