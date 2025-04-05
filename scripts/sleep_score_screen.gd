extends CanvasLayer

@onready var hours_label = $HoursLabel  # this will find your Label node automatically


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hours_label.text = "You Slept \n %.1f Hours" % Global.score


func _on_wake_up_button_pressed() -> void:
	print("wake up button pressed")
	get_tree().change_scene_to_file("res://scenes/day_scene.tscn")
