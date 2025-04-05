extends CanvasLayer

var npc_chat_response = null
var player_stats_data = null

func _ready() -> void:
	print("DayScene._ready")
	Thread.new().start(init_model)

func _enter_tree() -> void:
	print("DayScene._enter_tree")
	Thread.new().start(query_model_sleep_score.bind(0))
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_submit"):
		print("DayScene._process.ui_accept")
		print(Thread.new().start(query_model_player_stats.bind($UserBubble/PromptTextEdit.text)))
		$UserBubble/PromptTextEdit.editable = false
	
	if player_stats_data:
		Global.player_movement_speed_stat_multiplier = player_stats_data["movement_speed"]
		Global.player_hitpoints_stat_multiplier = player_stats_data["hitpoints"]
		Global.player_endurance_stat_multiplier = player_stats_data["endurance"]
		Global.player_attack_strength_stat_multiplier = player_stats_data["attack_strength"]
		player_stats_data = null
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	
	if npc_chat_response != null:
		$NpcBubble/NpcText.text = npc_chat_response
		npc_chat_response = null

func init_model():
	print("DayScene.init_model")
	OS.execute("sh", ["python_scripts/init.sh"])

func query_model_sleep_score(score):
	print("DayScene.query_model_sleep_score")
	var response = []
	OS.execute("python_scripts/venv/bin/python", ["python_scripts/model_query.py", '1', score], response)
	var body = response[0]
	
	print(body)
	npc_chat_response = body

func query_model_player_stats(prompt):
	var response = []
	OS.execute("python_scripts/venv/bin/python", ["python_scripts/model_query.py", '2', prompt], response)
	var body = response[0]
	
	print(body)
	on_player_stats.emit(JSON.parse_string(body))
	
	print("changing scene")
	get_tree().change_scene_to_file("res://scenes/sleeping.tscn")
	
		# Scene changes must be done on the main thread
	call_deferred("_change_scene")

func _change_scene():
	print("Actually changing scene now")
	get_tree().change_scene_to_file("res://scenes/sleeping.tscn")
	
	player_stats_data = JSON.parse_string(body)
