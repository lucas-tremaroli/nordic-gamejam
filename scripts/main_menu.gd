extends Control

signal start_pressed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuMusicAudioStreamPlayer.play()
	Thread.new().start(init_model)


func init_model():
	print("main_menu.init_model")
	OS.execute("sh", ["python_scripts/init.sh"])


func _on_start_pressed() -> void:
	print("On start pressed")
	$MainMenuMusicAudioStreamPlayer.stop()
	start_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_how_to_play_pressed() -> void:
	print("On how to play pressed")
	$MainMenuMusicAudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://scenes/day_scene.tscn")


func _on_about_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/about.tscn")
