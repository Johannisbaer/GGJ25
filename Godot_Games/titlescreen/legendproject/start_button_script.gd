extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	 # Load the main game scene
	var game_scene = load("res://MainScene.tscn")  # Replace with the path to your game scene
	get_tree().change_scene_to_packed(game_scene)
