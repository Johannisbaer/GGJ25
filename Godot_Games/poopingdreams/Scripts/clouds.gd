extends MeshInstance3D

@export var move_speed: float = 0.005  # Speed of movement
@export var direction_interval: float = 5.0  # Time (in seconds) for each direction

var time_since_change: float = 0.0  # Timer to track direction change
var current_direction: int = 0  # Tracks which direction is currently active

# Direction vectors for +x, -x, -y, +y
var directions := [
	Vector3(1, 0, 0),  # +x
	Vector3(-1, 0, 0), # -x
	Vector3(0, -1, 0), # -y
	Vector3(0, 1, 0)   # +y
]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Increment timer
	time_since_change += delta

	# Move in the current direction
	global_transform.origin += directions[current_direction] * move_speed * delta

	# Change direction after the interval
	if time_since_change >= direction_interval:
		time_since_change = 0.0  # Reset the timer
		current_direction = (current_direction + 1) % directions.size()  # Cycle through directions
