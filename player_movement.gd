extends CharacterBody2D

# Declare member variables here. Examples:
@export var speed = 200
@onready var animationPlayer = $sprites/AnimationPlayer
@onready var player = $"." 

var swordAnimationPlaying = false

func process_movement():
	if (swordAnimationPlaying):
		velocity.x = 0
		velocity.y = 0		
		return
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
		if !swordAnimationPlaying:
			animationPlayer.stop()

	# Move the character based on the calculated velocity
	move_and_slide()

func process_attack():
	if !Input.is_action_pressed("attack") || swordAnimationPlaying:
		return
		
	var mouse_position = get_local_mouse_position()
	var direction = mouse_position
	direction = direction.normalized()
	print(player.global_position)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animationPlayer.play("sword_right")
		else:
			animationPlayer.play('sword_left')
	else:
		if direction.y > 0:
			animationPlayer.play("sword_down")
		else:
			animationPlayer.play("sword_up")

	swordAnimationPlaying = true
	return true

func is_still_attacking():
	if !animationPlayer.current_animation.begins_with("sword_"):
		swordAnimationPlaying = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if(swordAnimationPlaying):
		is_still_attacking()
	process_attack()
	process_movement()
