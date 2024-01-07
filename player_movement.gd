extends CharacterBody2D

# Declare member variables here. Examples:
@export var speed = 200
@onready var animationPlayer = $sprites/AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input handling
	var velocity = Vector2()  # Reset velocity
	
	if Input.is_action_pressed("run_up"):
		animationPlayer.play("run_up")
		velocity.y = -speed 
	
	elif Input.is_action_pressed("run_down"):
		animationPlayer.play("run_down")
		velocity.y = speed 

	elif Input.is_action_pressed("run_left"):
		animationPlayer.play("run_left")
		velocity.x = -speed 
	
	elif Input.is_action_pressed("run_right"):
		animationPlayer.play("run_right")
		velocity.x = speed 

	else:
		velocity.x = 0
		velocity.y = 0
		animationPlayer.stop()

	# Move the character based on the calculated velocity
	move_and_slide()
