extends Button

func _on_pressed() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
