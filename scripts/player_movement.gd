extends CharacterBody2D

@export var speed = 200
@export var attack_damage = 20
@export var health = 100
@onready var animationPlayer = $sprites/AnimationPlayer
@onready var attack_hitbox = $attack_hitbox
@onready var player = $"." 
var attack_hitbox_settings = {
	'left': {
		'position': Vector2(-10, 10),
		'target_position': Vector2(-10, 0)
	},
	'right': {
		'position': Vector2(10, 10),
		'target_position': Vector2(10, 0)
	},
	'up': {
		'position': Vector2(0, -5),
		'target_position': Vector2(0, -10)
	},
	'down': {
		'position': Vector2(0, 20),
		'target_position': Vector2(0, 10)
	}
}
var attack_direction = 'down'
var is_attacking = false
var is_knockedback = false
var damaged_enemies_on_current_attack = []

func process_movement():
	if (is_attacking):
		velocity.x = 0
		velocity.y = 0		
		return

	if Input.is_action_pressed("run_up"):
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

func take_damage(damange: int, knockback: bool) -> void:
	health -= damange
	if health <= 0:
		process_death()
	if knockback:
		is_knockedback = true
		#body_sprite.modulate = Color(1, 0, 0, 1)
		var direction = (position - player.position).normalized()
		velocity = direction * speed 
		#knockback_timer.start()

func process_death():
	pass


func _process(_delta):
	process_attack()
	process_movement()
