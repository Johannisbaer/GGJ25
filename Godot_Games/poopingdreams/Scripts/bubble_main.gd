extends Node3D  # Main node of the Bubble

@export var travel_speed: float = 0.01
@export var horizontal_speed: float = 0.01
@export var z_speed: float = 0.01  # Speed for Z-axis movement
@export var lifespan: float = 50.0

var direction: Vector3
var time_alive: float = 0.0
var last_angle: float = 0.0

# Variables to store the fetched data
var wish: String = ""
var outcome_granted: String = ""
var outcome_popped: String = ""
var score_popped: int = 0
var score_granted: int = 0

func initialize_from_global() -> void:
	# Fetch the data from the highest index in the Global dictionary
	if Global.spawns.size() > 0:
		var highest_index = Global.spawn_index - 1
		var wish_data = Global.spawns.get(highest_index, null)
		
		if wish_data:
			# Assign the data to variables
			wish = wish_data.get("wish", "")
			outcome_granted = wish_data.get("outcome_granted", "")
			outcome_popped = wish_data.get("outcome_popped", "")
			score_popped = int(wish_data.get("score_popped", "0"))
			score_granted = int(wish_data.get("score_granted", "0"))
			
			# Initialize Label3D with the wish
			var label = $Label3D
			if label:
				label.text = wish
				adjust_label_to_fit()
	else:
		print("No spawns available in Global.spawns.")

func adjust_label_to_fit() -> void:
	var label = $Label3D
	if label:
		var text_mesh = label.mesh
		if text_mesh and text_mesh is TextMesh:
			var mesh_size = $MeshInstance3D.get_aabb().size  # Mesh dimensions
			var text_size = text_mesh.size

			# Adjust text scale to fit the mesh dimensions
			if text_size.x > 0 and text_size.y > 0:
				var scale_factor_x = mesh_size.x / text_size.x
				var scale_factor_y = mesh_size.y / text_size.y
				var scale_factor = min(scale_factor_x, scale_factor_y)
				label.scale = Vector3(scale_factor, scale_factor, scale_factor)

func _ready() -> void:
	# Call the method to fetch data and initialize the bubble
	initialize_from_global()
	
	# Randomize direction with a Z-axis component moving away from the camera
	var max_angle = PI / 2
	var min_angle_diff = deg_to_rad(30)
	var random_angle = 0.0

	while true:
		random_angle = randf_range(-max_angle, max_angle)
		if abs(random_angle - last_angle) >= min_angle_diff:
			break
	last_angle = random_angle

	var x = cos(random_angle) * horizontal_speed
	var y = max(sin(random_angle), 0) * travel_speed
	var z = z_speed  # Move away from the camera

	direction = Vector3(x, y, z).normalized()
	set_process(true)

func _process(delta: float) -> void:
	# Move the entire Bubble node (mesh and collision follow automatically)
	global_transform.origin += direction * delta
	time_alive += delta
	if time_alive >= lifespan:
		queue_free()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_bubble_clicked()

func _on_bubble_clicked() -> void:
	print("Bubble clicked!")
	print("Wish:", wish)
	print("Outcome Popped:", outcome_popped)
	print("Score Popped:", score_popped)
	queue_free()
