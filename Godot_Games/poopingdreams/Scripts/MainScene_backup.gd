extends Control  # Ensure this matches your root node type

var displayed_lines = []  # Lines currently shown in the text box
var max_lines = 5  # Maximum number of lines to display
var line_index = 0  # Tracks the current line

# Called when the scene is ready
func _ready():
	# Ensure this Control node does not block input by itself
	mouse_filter = MOUSE_FILTER_IGNORE  # Make this node ignore mouse input by default
	update_text_box()

# Updates the text box with the currently displayed lines
func update_text_box():
	$TextBoxPanel/TextLabel.clear()
	for line_data in displayed_lines:
		print(line_data)
		$TextBoxPanel/TextLabel.add_text("You caused: " + line_data + "\n\n")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		await get_tree().create_timer(0.1).timeout
		if len(Global.outcome) > 2:
			if displayed_lines.size() < max_lines:
				displayed_lines.append(Global.outcome)
			else:
				displayed_lines.pop_front()
				displayed_lines.append(Global.outcome)
			line_index += 1
			Global.outcome = ""
			update_text_box()
