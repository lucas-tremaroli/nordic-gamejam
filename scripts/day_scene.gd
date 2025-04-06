extends CanvasLayer

var npc_chat_response = null
var player_stats_data = null

func _ready() -> void:
	print("DayScene._ready")

func _enter_tree() -> void:
	print("DayScene._enter_tree")
	Thread.new().start(query_model_sleep_score.bind(Global.score))
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_submit"):
		print("DayScene._process.ui_accept")
		print(Thread.new().start(query_model_player_stats.bind($UserBubble/PromptTextEdit.text)))
		$UserBubble/PromptTextEdit.editable = false
	
	if player_stats_data:
		Global.player_movement_speed_stat_multiplier = player_stats_data["movement_speed"]
		Global.player_hitpoints_stat_multiplier = player_stats_data["hitpoints"]
		Global.player_attack_strength_stat_multiplier = player_stats_data["attack_strength"]
		Global.player_ammo_stat = player_stats_data["ammo"]
		player_stats_data = null
		get_tree().change_scene_to_file("res://scenes/sleeping.tscn")
	
	if npc_chat_response != null:
		$NpcBubble/NpcText.text = npc_chat_response
		npc_chat_response = null

func query_model_sleep_score(score):
	print("DayScene.query_model_sleep_score")
	var response = []
	print("Score sent to the llm", score)
	OS.execute("python_scripts/venv/bin/python", ["python_scripts/model_query.py", '1', score], response)
	var body = response[0]
	
	print(body)
	npc_chat_response = body

func query_model_player_stats(prompt):
	var response = []
	OS.execute("python_scripts/venv/bin/python", ["python_scripts/model_query.py", '2', prompt], response)
	var body = response[0]
	
	print(body)
	
	player_stats_data = JSON.parse_string(body)
