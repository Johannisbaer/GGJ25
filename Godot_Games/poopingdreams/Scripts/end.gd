extends Button

func _on_pressed() -> void:
	await get_tree().create_timer(0.8).timeout
	get_tree().quit()
