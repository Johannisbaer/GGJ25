extends Node3D

var default_cursor = preload('res://images/StandartHands.png')
var left_click_cursor = preload("res://images/PoppingHands.png")
var right_click_cursor = preload("res://images/SavingHands.png")

func _input(event):
 #CHange coursor on left-click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$CursorSprite.texture = left_click_cursor
		elif event.button_index== MOUSE_BUTTON_LEFT and not event.pressed:
			$CursorSprite.texture = default_cursor

		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				$CursorSprite.texture = right_click_cursor
			else:$CursorSprite.texture = default_cursor
			
				
				


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	$CursorSprite.position = get_viewport().get_mouse_position()
