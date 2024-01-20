extends CharacterBody2D
@onready var animationPlayer = $sprites/AnimationPlayer
var speed = 100
var isChasing = false
var player = null


func _physics_process(_delta: float) -> void:
	if isChasing and player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	_animate_enemy()
	move_and_slide()

func _animate_enemy() -> void:
	if velocity.x == 0 and velocity.y == 0:
		animationPlayer.play('idle')
		return
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			animationPlayer.play('walk_right')
		else:
			animationPlayer.play('walk_left')
	else:
		if velocity.y > 0:
			animationPlayer.play('walk_down')
		else:
			animationPlayer.play('walk_up')

func _on_detection_zone_body_entered(body: Node2D) -> void:
	player = body
	isChasing = true


func _on_detection_zone_body_exited(_body: Node2D) -> void:
	player = null
	isChasing = false
