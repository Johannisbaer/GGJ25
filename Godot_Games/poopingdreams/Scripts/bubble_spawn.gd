extends MeshInstance3D

@export var bubble_scene_path: String = "res://models/Bubble.blend"  # Path to the Bubble scene

var bubble_scene: PackedScene  # To store the loaded Bubble scene

func _ready() -> void:
	# Load the Bubble scene
	bubble_scene = load(bubble_scene_path)
	if bubble_scene == null:
		print("Failed to load Bubble scene:", bubble_scene_path)
		return

	print("Bubble scene loaded successfully:", bubble_scene_path)

	# Connect the spawn_event signal from the parent node
	var parent = get_parent()
	if parent:
		parent.connect("spawn_event", Callable(self, "_on_spawn_event"))
		print("Connected to spawn_event signal from parent.")
	else:
		print("No parent found. Signal connection failed.")

func _on_spawn_event(wish_data: Dictionary) -> void:
	print("spawn_event triggered with wish_data:", wish_data)
	if bubble_scene:
		spawn_bubble(wish_data)
	else:
		print("Bubble scene is not loaded. Cannot spawn bubbles.")

func spawn_bubble(wish_data: Dictionary) -> void:
	# Instance the Bubble scene
	var bubble_instance = bubble_scene.instantiate()
	if bubble_instance:
		# Determine a random position on the PlaneMesh surface
		var surface_position = get_random_surface_position()
		bubble_instance.global_transform.origin = surface_position

		# Add the bubble to the scene tree
		add_child(bubble_instance)

		# Debugging: Print to console
		print("Bubble spawned successfully!")
		print("Surface position:", surface_position)
		print("Wish data:", wish_data)
	else:
		# If the instance creation fails
		print("Failed to instance Bubble scene.")

func get_random_surface_position() -> Vector3:
	# Get the bounding box (AABB) of the PlaneMesh
	var aabb = get_mesh().get_aabb()

	# Debugging: Print the AABB dimensions
	print("AABB of PlaneMesh:", aabb)

	# Calculate random X and Z positions within the bounds of the PlaneMesh
	var random_x = randf_range(aabb.position.x, aabb.position.x + aabb.size.x)
	var random_z = randf_range(aabb.position.z, aabb.position.z + aabb.size.z)

	# Use the top surface (upward-facing Y)
	var surface_position = Vector3(random_x, aabb.position.y + aabb.size.y, random_z)

	# Debugging: Print the generated random position
	print("Generated random surface position:", surface_position)

	return to_global(surface_position)  # Convert to global coordinates
