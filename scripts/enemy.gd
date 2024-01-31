extends CharacterBody2D
@onready var animationPlayer = $sprites/AnimationPlayer
@onready var knockback_timer = $knockback_timer
@onready var attack_timer = $attack_timer
@onready var body_sprite = $sprites/body

var player = null
var speed = 100
var is_chasing = false
var is_attacking = false
var is_enemy = true
@export var health = 100.0
var is_dieing = false
var is_knockedback = false

func _physics_process(_delta: float) -> void:
	if is_dieing:
		if !animationPlayer.current_animation.begins_with("die"):
			self.queue_free()
		return
	if !is_knockedback:
		if is_chasing and player and !is_attacking:
			update_chase_velocity()
		else:
			reset_velocity()
	
	move_and_slide()
	_animate_enemy()

func update_chase_velocity() -> void:
	var direction = (player.position - position).normalized()
	velocity = direction * speed

func reset_velocity() -> void:
	velocity = Vector2.ZERO

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
	is_chasing = true
func _on_detection_zone_body_exited(_body: Node2D) -> void:
	player = null
	is_chasing = false

func take_damage(damage: int, knockback: bool = false) -> void:
	health -= damage
	if health <= 0:
		process_death()
	if knockback:
		is_knockedback = true
		body_sprite.modulate = Color(1, 0, 0, 1)
		var direction = (position - player.position).normalized()
		velocity = direction * speed 
		knockback_timer.start()

func process_death() -> void:
	animationPlayer.play('die')
	is_dieing = true

func _on_knockback_timer_timeout() -> void:
	is_knockedback = false
	body_sprite.modulate = Color(1, 1, 1, 1)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.get('is_player') && player && !is_knockedback && !is_dieing:
		var knockBackDirection = (player.position - position).normalized()
		body.take_damage(12.5, true, knockBackDirection)
		is_attacking = true
		attack_timer.start()

func _on_attack_timer_timeout() -> void:
	is_attacking = false
