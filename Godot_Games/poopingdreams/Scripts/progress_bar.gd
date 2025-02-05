extends ProgressBar

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		await get_tree().create_timer(0.1).timeout
		var score = Global.world_happieness
		self.value = score


@onready var indicator = $Sprite2D

func _ready():
	update_indicator_position()

func _process(delta):
	update_indicator_position()

func update_indicator_position():
	var normalized_value = (value - min_value) / (max_value - min_value)
	var bar_width = size.x
	var new_x = normalized_value * bar_width
	indicator.position.x = new_x
