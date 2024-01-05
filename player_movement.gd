extends CharacterBody2D

# Declare member variables here. Examples:
@export var speed = 200
@onready var animationPlayer = $sprites/AnimationPlayer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input handling
	velocity = Vector2()  # Reset velocity
	
	if Input.is_action_pressed("walk_down"):
		# Set the AnimationPlayer's animation to "run_down"
		animationPlayer.play("run_down")
		
		# Adjust the velocity or perform other actions as needed for walking down
		velocity.y += 1  # You might need to adjust this based on your game's requirements
		
	else:
		# If the "walk_down" key is not pressed, stop the animation
		animationPlayer.stop()
	
	# Move the character based on the calculated velocity
	move_and_slide()
