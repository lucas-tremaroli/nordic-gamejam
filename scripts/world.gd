extends Node2D

@onready var player = $Player 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	player.connect("player_died", Callable(self, "_on_player_died"))

func _on_player_died():
	print("Player has died")
	var score_screen = preload("res://scenes/SleepScoreScreen.tscn").instantiate()
	add_child(score_screen)
	score_screen.set_score(3.5)  # or calculate based on gameplay

	score_screen.process_mode = Node.PROCESS_MODE_PAUSABLE

	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func end_dream_and_show_score(hours_slept: float):
	var score_screen = preload("res://scenes/SleepScoreScreen.tscn").instantiate()
	add_child(score_screen)
	score_screen.set_score(hours_slept)
	# Optional: Pause the game while the screen is shown
	get_tree().paused = true
	#score_screen.pause_mode = Node.PAUSE_MODE_PROCESS
	
