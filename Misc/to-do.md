1. Bubble Spawn Area
	•	Model a curved triangular surface in Blender to act as the bubble spawn area.
	•	Ensure it fits the visible area from the fixed camera perspective.
	•	Add enough subdivisions to allow for smooth curvature.
	•	Export the spawn area as a .glb or .gltf file and import it into Godot.
	•	Create a script in Godot to:
	•	Randomly select spawn points on the surface.
	•	Calculate the orthogonal (normal) direction at each spawn point for bubble movement.

2. Text Manager
	•	Create a TextManager script in Godot to manage bubble text:
	•	Use a static array for text storage (initial setup).
	•	Optionally, load text dynamically from a JSON or CSV file.
	•	Provide functions to fetch random text or text by index.
	•	Add the TextManager as an autoload (singleton) for easy access across the project.

3. Bubbles
	•	Create a bubble model in Blender:
	•	Simple sphere with transparent material for a glassy look.
	•	Export as .glb or .gltf.
	•	Set up a Bubble Scene in Godot:
	•	Add the bubble model as a MeshInstance3D.
	•	Add a Label3D for displaying text.
	•	Add an Area3D and CollisionShape3D for interaction (e.g., popping).
	•	Write a script for the bubble to:
	•	Fetch text from the TextManager and display it in the Label3D.
	•	Move along its orthogonal direction with slight randomness.
	•	Trigger a popping animation, sound, and particle effect when interacted with.

4. Globe
	•	Model a simple globe in Blender:
	•	Add textures for continents and oceans.
	•	Optional: Add rotation animation for a spinning effect.
	•	Export the globe as .glb or .gltf and import it into Godot.
	•	Add the globe to the scene and ensure it aligns with the spawn area.

5. Hand
	•	Model and rig a hand in Blender:
	•	Create bones for fingers and add necessary weights.
	•	Create two animations:
	•	Thumbs Up: Thumb raised, fingers curled.
	•	Pop: Index finger extends and pokes forward.
	•	Export the hand as .glb or .gltf with animations.
	•	Set up a Hand Scene in Godot:
	•	Add the hand model and an AnimationPlayer for controlling the animations.
	•	Attach an Area3D and CollisionShape3D to the fingertip for detecting bubble interactions.
	•	Write a script for the hand to:
	•	Play the “Thumbs Up” animation on specific input (e.g., button press).
	•	Play the “Pop” animation when interacting with a bubble.

6. Bubble Spawning and Interaction
	•	Write a Bubble Spawner script to:
	•	Spawn bubbles at random points on the spawn area.
	•	Assign text to each bubble from the TextManager.
	•	Move bubbles upward along the orthogonal direction.
	•	Ensure bubbles stay within the camera’s view.
	•	Add logic for bubble popping:
	•	Detect collision with the hand’s fingertip.
	•	Trigger a popping effect (animation, particle, sound).
	•	Remove the bubble from the scene.

7. Effects and Polish
	•	Add visual effects:
	•	Particle effects for bubble popping.
	•	Optional glow or shimmer for bubbles.
	•	Add audio effects:
	•	Pop sound for bubble interaction.
	•	Background music or ambient sounds.
	•	Fine-tune lighting for a polished visual appearance.