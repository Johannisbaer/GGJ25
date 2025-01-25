extends Node

@export var json_file_path: String = "res://text_data/wishes.json"  # Path to the JSON file
@export var spawn_interval: float = 20.0  # Time in seconds between spawns

var wishes: Array = []  # List of wishes with outcomes
var time_since_last_spawn: float = 0.0  # Timer to track spawn events

# Define a signal to trigger an event
signal spawn_event(wish_data: Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the JSON file and populate the wishes array
	if _load_json_file(json_file_path):
		print("Wishes loaded successfully!")
	else:
		print("Failed to load wishes!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wishes.size() == 0:
		return  # No data to process, stop execution

	# Increment the timer
	time_since_last_spawn += delta

	# Check if it's time to trigger a spawn event
	if time_since_last_spawn >= spawn_interval:
		time_since_last_spawn = 0.0  # Reset the timer
		_trigger_spawn_event()  # Trigger the spawn event

# Loads the JSON file and populates the wishes array
func _load_json_file(file_path: String) -> bool:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_instance = JSON.new()  # Create an instance of the JSON class
		var json_data = json_instance.parse(file.get_as_text())  # Parse the JSON content
		file.close()
		if json_data == OK:
			wishes = json_instance.data["wishes"]  # Store the array of wishes with outcomes
			return true
	return false

# Triggers a spawn event using a random wish
func _trigger_spawn_event() -> void:
	var random_wish = wishes[randi() % wishes.size()]  # Pick a random wish
	print("TM - Sending wish: ", random_wish["wish"])
	# Emit the signal with the wish data
	emit_signal("spawn_event", random_wish)
