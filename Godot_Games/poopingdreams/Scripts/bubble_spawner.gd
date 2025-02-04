extends Node3D

@export var bubble_scene: PackedScene = preload("res://scenes/Bubble.tscn")  # Reference to your Bubble scene
@export var spawn_position: Vector3 = Vector3(0, 1, 0)  # Default spawn position

func _ready() -> void:
	# Connect to the spawn_event signal from the parent node (TextManager)
	var text_manager = get_parent()
	if text_manager and text_manager.has_signal("spawn_event"):
		text_manager.connect("spawn_event", Callable(self, "_on_spawn_event"))

func _on_spawn_event(wish_data: Dictionary) -> void:
	print("Bubble spawner received event with wish:", wish_data.get("wish", "No wish data"))
	spawn_bubble(wish_data)

func spawn_bubble(wish_data: Dictionary) -> void:
	# Instantiate a new Bubble
	var bubble_instance = bubble_scene.instantiate()
	# Set the bubble's position to the spawner's position (or a custom one)
	bubble_instance.global_transform.origin = spawn_position
	# Optionally, pass the wish data to the bubble if it needs it
	if bubble_instance.has_method("initialize"):
		bubble_instance.initialize(wish_data)
	# Add the bubble as a child of the spawner
	add_child(bubble_instance)
