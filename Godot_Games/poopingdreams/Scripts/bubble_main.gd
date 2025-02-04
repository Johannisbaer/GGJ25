extends Node3D  # Main node of the Bubble

@export var travel_speed: float = 0.01
@export var horizontal_speed: float = 0.01
@export var z_speed: float = 0.01  # Speed for Z-axis movement
@export var lifespan: float = 70.0
@export var slowdown_percentage: float = 90  # A percentage to slow down the velocity

var direction: Vector3
var time_alive: float = 0.0
var last_angle: float = 0.0

# Variables to store the fetched data
var wish: String = ""
var outcome_granted: String = ""
var outcome_popped: String = ""
var score_popped: int = 0
var score_granted: int = 0

# Define the function before _ready()
func initialize_from_global() -> void:
	if Global.spawns.size() > 0:
		var highest_index = Global.spawn_index - 1
		var wish_data = Global.spawns.get(highest_index, null)
		
		if wish_data:
			wish = wish_data.get("wish", "")
			outcome_granted = wish_data.get("outcome_granted", "")
			outcome_popped = wish_data.get("outcome_popped", "")
			score_popped = int(wish_data.get("rating_outcome_popped", "0"))
			score_granted = int(wish_data.get("rating_outcome_granted", "0"))
			
			var label = $Label3D
			if label:
				label.text = wish
				adjust_label_to_fit()
	else:
		print("No spawns available in Global.spawns.")

func _ready() -> void:
	initialize_from_global()

	# Initialize random direction
	var max_angle = PI
	var min_angle_diff = deg_to_rad(30)
	var random_angle = 0.0

	while true:
		random_angle = randf_range(0, max_angle)
		if abs(random_angle - last_angle) >= min_angle_diff:
			break
	last_angle = random_angle

	var x = cos(random_angle) * horizontal_speed
	var z = sin(random_angle) * z_speed
	var y = travel_speed

	direction = Vector3(x, y, z).normalized()
	
	var slowdown_factor = 1.0 - (slowdown_percentage / 100.0)
	direction *= slowdown_factor

	set_process(true)

func adjust_label_to_fit() -> void:
	var label = $Label3D
	if label:
		var text_mesh = label.mesh
		if text_mesh and text_mesh is TextMesh:
			var mesh_size = $MeshInstance3D.get_aabb().size
			var text_size = text_mesh.size

			if text_size.x > 0 and text_size.y > 0:
				var scale_factor_x = mesh_size.x / text_size.x
				var scale_factor_y = mesh_size.y / text_size.y
				var scale_factor = min(scale_factor_x, scale_factor_y)
				label.scale = Vector3(scale_factor, scale_factor, scale_factor)

func _process(delta: float) -> void:
	global_transform.origin += direction * delta
	time_alive += delta
	if time_alive >= lifespan:
		queue_free()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_on_bubble_clicked_left()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_on_bubble_clicked_right()

func _on_bubble_clicked_left() -> void:
	print("Bubble clicked with left mouse button!")
	print("Wish:", wish)
	Global.play_popping_sound = true
	print("Outcome Popped:", outcome_popped)
	Global.outcome = outcome_popped
	print("Score Popped:", score_popped)
	Global.world_happieness = Global.world_happieness + score_popped
	print("GH: ", Global.world_happieness)
	queue_free()

func _on_bubble_clicked_right() -> void:
	print("Bubble clicked with right mouse button!")
	print("Wish:", wish)

	# Create a unique material override for this instance
	var mesh_instance = $MeshInstance3D
	if mesh_instance and mesh_instance.mesh:
		# Check if there's an existing override; if not, duplicate the current material
		if not mesh_instance.material_override:
			var original_material = mesh_instance.mesh.surface_get_material(0)
			if original_material:
				mesh_instance.material_override = original_material.duplicate()

		# Change the color on the material override
		var material_override = mesh_instance.material_override
		if material_override is StandardMaterial3D:
			material_override.albedo_color = Color(1.0, 0.84, 0.0)  # Light gold color

	Global.play_saving_sound = true
	print("Outcome Granted:", outcome_granted)
	Global.outcome = outcome_granted
	print("Score Granted:", score_granted)
	Global.world_happieness = Global.world_happieness + score_granted
	print("GH: ", Global.world_happieness)
	await get_tree().create_timer(2).timeout
	queue_free()
