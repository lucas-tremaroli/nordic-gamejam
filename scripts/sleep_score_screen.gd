extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var hours_label = $HoursLabel  # this will find your Label node automatically

func set_score(hours_slept: float) -> void:
	print("Hours slept", hours_slept)
	print(hours_label)
	hours_label.text = "You Slept \n %.1f Hours" % hours_slept
