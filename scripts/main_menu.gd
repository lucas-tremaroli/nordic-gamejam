extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuMusicAudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print("On start pressed")
	$MainMenuMusicAudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_how_to_play_pressed() -> void:
	pass # Replace with function body.


func _on_about_pressed() -> void:
	pass # Replace with function body.
