extends CanvasLayer

var model_thread: Thread
var character_data = null

signal character_update(character_data)

func _ready() -> void:
	model_thread = Thread.new()

func query_model(prompt):
	var response = []
	OS.execute("python_scripts/venv/bin/python", ["python_scripts/model_query.py", prompt], response)
	var body = response[0]
	
	print(body)
	character_data = JSON.parse_string(body)

func _on_submit_button_pressed() -> void:
	model_thread.start(query_model.bind($PromptHud/PromptTextEdit.text))
	$PromptHud/SubmitButton.hide()

func _process(delta: float) -> void:
	if character_data != null:
		$PromptHud.visible = false
		$CharacterHud.visible = true
		
		$CharacterHud/Name.text = character_data["name"]
		$CharacterHud/Description.text = character_data["description"]
		
		character_update.emit(character_data)
		character_data = null
