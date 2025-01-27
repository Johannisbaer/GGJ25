extends Control  # Replace Control with your root node type

# Variables for managing text lines
var text_lines = []  # All lines loaded from the JSON file
var displayed_lines = []  # Lines currently shown in the text box
var max_lines = 9  # Maximum number of lines the text box can display
var line_index = 0  # Tracks the next line to load

# Called when the scene is ready
func _ready():
	load_text_lines()
	update_text_box()

# Loads lines from the JSON file
func load_text_lines():
	var file = FileAccess.open("res://text_lines.json", FileAccess.READ)
	if file:
		var data = file.get_as_text()
		var parsed_data = JSON.parse_string(data)
		if typeof(parsed_data) == TYPE_DICTIONARY:
			if "lines" in parsed_data:
				text_lines = parsed_data["lines"]
				print("Text lines loaded: ", text_lines)
			else:
				print("Error: 'lines' key not found in JSON.")
		else:
			print("Error: Failed to parse JSON.")
		file.close()
	else:
		print("Error: Could not open JSON file.")

# Updates the text box with the currently displayed lines
func update_text_box():
	var text_label = $TextBoxPanel/TextLabel  # Update path if your node names differ
	text_label.clear()  # Clear previous text
	for line in displayed_lines:
		text_label.add_text(line["text"] + "\n")  # Access the "text" key from the Dictionary

# Handles mouse clicks to load new text
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if line_index < text_lines.size():
			if displayed_lines.size() < max_lines:
				# Add a new line if space is available
				displayed_lines.append(text_lines[line_index])
			else:
				# Scroll lines upward when full
				displayed_lines.pop_front()
				displayed_lines.append(text_lines[line_index])
			line_index += 1
			update_text_box()
		else:
			print("No more lines to display.")
