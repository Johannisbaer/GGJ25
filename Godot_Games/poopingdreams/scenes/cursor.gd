extends Node3D

# Existing variables
var default_cursor = preload('res://images/StandartHands.png')
var left_click_cursor = preload("res://images/PoppingHands.png")
var right_click_cursor = preload("res://images/SavingHands.png")

# Handle mouse input
func _input(event):
	# Change cursor on left-click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				$CursorSprite.texture = left_click_cursor

				# Add a 0.1s delay before playing the popping sound
				await get_tree().create_timer(0.1).timeout

				# Play popping sound if enabled in Global
				if Global.play_popping_sound:
					$Popping_Sound.play()
					Global.play_popping_sound = false  # Set the global variable to false
			else:
				$CursorSprite.texture = default_cursor

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				$CursorSprite.texture = right_click_cursor

				# Add a 0.1s delay before playing the saving sound
				await get_tree().create_timer(0.1).timeout

				# Play saving sound if enabled in Global
				if Global.play_saving_sound:
					$Saving_Sound.play()
					Global.play_saving_sound = false  # Set the global variable to false
			else:
				$CursorSprite.texture = default_cursor

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame to update the cursor position
func _process(delta: float) -> void:
	$CursorSprite.position = get_viewport().get_mouse_position()
