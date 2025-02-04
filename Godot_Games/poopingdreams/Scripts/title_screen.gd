extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	# Load the main game scene
	var game_scene = load("res://scenes/planet_and_clouds.tscn")  # Replace with the path to your game scene
	get_tree().change_scene_to_packed(game_scene)
