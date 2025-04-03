extends CanvasLayer


func _on_submit_button_pressed() -> void:
	$PromptHud.visible = false
	$CharacterHud.visible = true
	
	$CharacterHud/Name.text = "Crocodilo"
	$CharacterHud/Description.text = "."
