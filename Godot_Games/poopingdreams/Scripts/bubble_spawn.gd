extends MeshInstance3D

@export var distance_d: float = 10.0  # Distance the bubble travels upward
@export var travel_time: float = 20.0  # Time in seconds for the bubble to travel
@export var glow_color: Color = Color(1, 0.5, 0.5)  # Glow color (light pink)
@export var glow_intensity: float = 1.5  # Glow intensity multiplier

func _ready() -> void:
	# Make the parent (Bubble_Surface) invisible
	self.visible = false
	
	# Connect to the spawn_event signal from the parent node
	var parent = get_parent()
	if parent:
		parent.connect("spawn_event", Callable(self, "_on_spawn_event"))
		print("Connected to spawn_event signal from parent.")
	else:
		print("No parent found. Signal connection failed.")

func _on_spawn_event(wish_data: Dictionary) -> void:
	# Debug: Log the received signal and data
	print("spawn_event triggered! Wish Data:", wish_data)
	spawn_moving_bubble()

func spawn_moving_bubble() -> void:
	# Get the template child node (e.g., the preconfigured bubble)
	var template_bubble = $Bubble  # Adjust the path to match your child node's name
	if not template_bubble:
		print("Bubble node not found!")
		return

	# Duplicate the template bubble
	var bubble_instance = template_bubble.duplicate()
	if not bubble_instance:
		print("Failed to duplicate the bubble!")
		return

	# Set the duplicate's properties
	var surface_position = get_random_surface_position()
	bubble_instance.global_transform.origin = surface_position

	# Add the duplicate to the scene as a child of this node
	add_child(bubble_instance)
	print("Bubble spawned at:", surface_position)

	# Apply glow and scaling effect
	apply_glow_effect(bubble_instance)
	apply_scaling_effect(bubble_instance)

	# Move the bubble upward along the Y-axis
	move_bubble(bubble_instance)

func apply_glow_effect(bubble_instance: MeshInstance3D) -> void:
	# Add a glow effect by modifying the material
	var material = StandardMaterial3D.new()
	material.emission_enabled = true  # Enable emission
	material.emission = glow_color * glow_intensity  # Set the glow color and intensity
	bubble_instance.material_override = material
	print("Glow effect applied to bubble.")

func apply_scaling_effect(bubble_instance: MeshInstance3D) -> void:
	# Use a Tween to animate the bubble's scaling for a pulsating effect
	var tween = create_tween()
	var original_scale = bubble_instance.scale
	var enlarged_scale = original_scale * 1.2  # Scale up by 20%

	# Tween to enlarge the bubble
	tween.tween_property(bubble_instance, "scale", enlarged_scale, 1.0)
	tween.set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.set_trans(Tween.TransitionType.QUAD)

	# Tween to shrink the bubble back to its original size
	tween.tween_property(bubble_instance, "scale", original_scale, 1.0)
	tween.set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.set_trans(Tween.TransitionType.QUAD)

	# Set the tween to loop infinitely
	tween.set_loops(-1)
	print("Scaling effect applied to bubble.")

func move_bubble(bubble_instance: MeshInstance3D) -> void:
	# Calculate the start and end positions for the bubble
	var start_position = bubble_instance.global_transform.origin
	var end_position = start_position + Vector3(0, distance_d, 0)  # Move along the Y-axis

	# Use a Tween to animate the bubble's movement
	var tween = create_tween()
	tween.tween_property(bubble_instance, "global_transform:origin", end_position, travel_time)

	# Connect the tween's "finished" signal to remove the bubble
	tween.connect("finished", Callable(self, "_on_tween_finished").bind(bubble_instance))

func _on_tween_finished(bubble_instance: MeshInstance3D) -> void:
	# Debug: Log when the bubble reaches its destination
	print("Bubble reached its destination. Deleting bubble.")
	bubble_instance.queue_free()

func get_random_surface_position() -> Vector3:
	# Get the AABB (axis-aligned bounding box) of the PlaneMesh
	var aabb = get_mesh().get_aabb()
	print("AABB dimensions of PlaneMesh:", aabb)

	# Calculate a random X and Z position within the bounds of the PlaneMesh
	var random_x = randf_range(aabb.position.x, aabb.position.x + aabb.size.x)
	var random_z = randf_range(aabb.position.z, aabb.position.z + aabb.size.z)

	# Use the top surface (upward-facing Y) of the PlaneMesh
	var surface_position = Vector3(random_x, aabb.position.y + aabb.size.y, random_z)

	# Debug: Log the generated random surface position
	print("Generated random surface position:", surface_position)
	return to_global(surface_position)  # Convert to global coordinates
