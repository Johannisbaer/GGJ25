extends Label3D

# Variables to store the fetched data
var wish: String = ""
var outcome_granted: String = ""
var outcome_popped: String = ""
var score_popped: int = 0
var score_granted: int = 0

func _ready():
	initialize_from_global()

func initialize_from_global() -> void:
	# Fetch the data from the highest index in the Global dictionary
	if Global.spawns.size() > 0:
		var highest_index = Global.spawn_index - 1
		var wish_data = Global.spawns.get(highest_index, null)
		
		if wish_data:
			# Assign the data to variables
			wish = str(wish_data.get("wish", "Default Wish"))
			outcome_granted = str(wish_data.get("outcome_granted", ""))
			outcome_popped = str(wish_data.get("outcome_popped", ""))
			score_popped = int(wish_data.get("score_popped", 0))
			score_granted = int(wish_data.get("score_granted", 0))
			
			# Update Label3D text
			self.text = wish
		else:
			print("No valid wish data found in Global.spawns.")
	else:
		print("No spawns available in Global.spawns.")
