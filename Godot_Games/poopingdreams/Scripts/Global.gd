extends Node3D

# Existing variables
var spawns = {}  # Dictionary to store spawns
var spawn_index = 0  # Index to track spawn entries

# New variable for controlling popping sound
var play_popping_sound: bool = false
var play_saving_sound: bool = false

var world_happieness: int = 0
var outcome: String = ""
