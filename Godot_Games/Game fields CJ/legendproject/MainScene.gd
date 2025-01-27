extends Control  # Ensure this matches your root node type

var text_lines = []  # Stores all lines from JSON
var displayed_lines = []  # Lines currently shown in the text box
var max_lines = 5  # Maximum number of lines to display
var line_index = 0  # Tracks the current line
var happiness_level = 0  # Tracks the current happiness level

# Called when the scene is ready
func _ready():
	load_text_lines()
	#calculate_max_lines()
	update_text_box()
	update_happiness_meter()

# Load lines and scores from the JSON file
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
	var text_label = $TextBoxPanel/TextLabel
	text_label.clear()
	for line_data in displayed_lines:
		text_label.add_text(line_data["text"] + "\n")

# Updates the happiness meter
func update_happiness_meter():
	var meter_fill = $HappinessMeter/Fill  # The green/red bar
	var zero_marker = $HappinessMeter/ZeroMarker  # The triangle marker

	# Calculate fill size
	var bar_width = $HappinessMeter.rect_size.x / 2  # Half of the bar is for positive, half for negative
	var fill_width = clamp(happiness_level, -bar_width, bar_width)

	# Set the fill's size and color
	meter_fill.rect_size.x = abs(fill_width)
	meter_fill.rect_position.x = zero_marker.rect_position.x + (fill_width > 0 if 0 else fill_width)
	meter_fill.modulate = fill_width >= 0 if Color(0, 1, 0) else Color(1, 0, 0)

# Handles mouse clicks to load new text and update happiness
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if line_index < text_lines.size():
			var current_line = text_lines[line_index]

			# Add the text and update happiness level
			if displayed_lines.size() < max_lines:
				displayed_lines.append(current_line)
			else:
				displayed_lines.pop_front()
				displayed_lines.append(current_line)
			happiness_level += current_line["score"]
			print("Happiness level:", happiness_level)
			line_index += 1

			# Update the UI
			update_text_box()
			update_happiness_meter()
		else:
			print("No more lines to display.")
