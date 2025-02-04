extends Control

@onready var outcome_label = $Label

var display_duration = 3.0  # Duration to display the label before fading out (in seconds)
var fade_duration = 1.0     # Duration of the fade-out effect (in seconds)
var timer = 0.0             # Timer to track time elapsed
var is_fading = false       # Flag to indicate if the label is currently fading

func _ready():
	# Ensure the label is initially invisible
	mouse_filter = MOUSE_FILTER_IGNORE 
	outcome_label.visible = false
	outcome_label.modulate.a = 0.0  # Set alpha to 0

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		await get_tree().create_timer(0.1).timeout
		if len(Global.outcome) > 2:# Display the outcome when the mouse is clicked
			display_outcome(Global.outcome)
			Global.outcome = ""

func display_outcome(text):
	# Set the label text
	outcome_label.text = text
	# Make the label visible
	outcome_label.visible = true
	# Reset the alpha to 1 (fully opaque)
	outcome_label.modulate.a = 1.0
	# Reset the timer and flags
	timer = 0.0
	is_fading = false

func _process(delta):
	if outcome_label.visible:
		timer += delta
		if timer >= display_duration and not is_fading:
			is_fading = true
			timer = 0.0  # Reset timer for fade-out
		elif is_fading:
			# Calculate the new alpha value
			outcome_label.modulate.a = 1.0 - (timer / fade_duration)
			if outcome_label.modulate.a <= 0.0:
				# Fade-out complete
				outcome_label.visible = false
				is_fading = false
