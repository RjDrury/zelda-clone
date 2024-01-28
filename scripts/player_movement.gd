extends CharacterBody2D

var is_player = true
@export var speed = 200
@export var attack_damage = 20
@export var health = 100.0
@onready var animationPlayer = $sprites/AnimationPlayer
@onready var attack_hitbox = $attack_hitbox
@onready var knockback_timer = $knockback_timer
@onready var player = $"." 
var attack_hitbox_settings = {
	'left': {
		'position': Vector2(-12, -2),
		'target_position': Vector2(-10, 0)
	},
	'right': {
		'position': Vector2(12, -2),
		'target_position': Vector2(10, 0)
	},
	'up': {
		'position': Vector2(0, -12),
		'target_position': Vector2(0, -10)
	},
	'down': {
		'position': Vector2(0, 10),
		'target_position': Vector2(0, 10)
	}
}
var attack_direction = 'down'
var is_attacking = false
var is_knockedback = false
var is_dieing = false
var damaged_enemies_on_current_attack = []

func process_movement():
	#Input.getVector
	if is_knockedback:
		pass
	elif (is_attacking):
		velocity.x = 0
		velocity.y = 0		
		return
	elif Input.is_action_pressed("run_up"):
		animationPlayer.play("run_up")
		velocity.y = -speed 
		velocity.x = 0 
	elif Input.is_action_pressed("run_down"):
		animationPlayer.play("run_down")
		velocity.y = speed
		velocity.x = 0 
	elif Input.is_action_pressed("run_left"):
		animationPlayer.play("run_left")
		velocity.x = -speed 
		velocity.y = 0 
	elif Input.is_action_pressed("run_right"):
		animationPlayer.play("run_right")
		velocity.x = speed 
		velocity.y = 0 
	else:
		velocity.x = 0
		velocity.y = 0
		animationPlayer.stop()

	# Move the character based on the calculated velocity
	move_and_slide()

func process_attack():
	if is_attacking:
		_process_enemy_hit()
		is_still_attacking()
	elif Input.is_action_pressed("attack"):
		_animate_attack()
		_move_attack_hitbox()
		_process_enemy_hit()
	
func _animate_attack():
	var mouse_position = get_local_mouse_position()
	var direction = mouse_position
	direction = direction.normalized()
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animationPlayer.play("sword_right")
			attack_direction = 'right'
		else:
			animationPlayer.play('sword_left')
			attack_direction = 'left'
	else:
		if direction.y > 0:
			animationPlayer.play("sword_down")
			attack_direction = 'down'
		else:
			animationPlayer.play("sword_up")
			attack_direction = 'up'
	
	is_attacking = true

func _move_attack_hitbox():
	attack_hitbox.position = attack_hitbox_settings[attack_direction].position
	attack_hitbox.target_position = attack_hitbox_settings[attack_direction].target_position

func _process_enemy_hit():
	var count = attack_hitbox.get_collision_count()
	for i in range(count):
		var collision = attack_hitbox.get_collider(i)
		if collision != null:
			var enemy = collision.get_parent()
			if enemy != null and enemy.get('is_enemy') && !damaged_enemies_on_current_attack.has(enemy): 
				damaged_enemies_on_current_attack.append(enemy)
				enemy.take_damage(attack_damage, true)

func is_still_attacking():
	if !animationPlayer.current_animation.begins_with("sword_"):
		is_attacking = false
		damaged_enemies_on_current_attack.clear()

func take_damage(damange: int, knockback: bool, directionToKockback) -> void:
	if is_dieing:
		return
	health -= damange
	Globals.player_health = health
	if health <= 0:
		process_death()
		return
	if knockback:
		is_knockedback = true
		velocity = directionToKockback * speed 
		knockback_timer.start()
		playKnockBackAnimation(directionToKockback)
		move_and_slide()
		
func playKnockBackAnimation(direction: Vector2):
		if direction.x and abs(direction.y) <= abs(direction.x):
				if direction.x > 0:
						# Play the animation for knockback to the left
						animationPlayer.play("hurt_left")
				else:
						# Play the animation for knockback to the right
						animationPlayer.play("hurt_right")
		elif direction.y:
				if direction.y > 0:
						# Play the animation for knockback up
						animationPlayer.play("hurt_down")
				else:
						# Play the animation for knockback down
						animationPlayer.play("hurt_up")

func process_death():
	animationPlayer.play("die")
	is_dieing = true

func _process(_delta):
	if !is_dieing:
		process_attack()
		process_movement()

func _ready() -> void:
	Globals.player_health = health
func _on_knockback_timer_timeout() -> void:
	is_knockedback = false
	if !is_dieing:
		animationPlayer.play("RESET")
