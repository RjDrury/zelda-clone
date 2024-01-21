extends Control

@onready var view = $"."
@onready var hat_texture = $"../sprites/hat"
@onready var hair_sprite = $"../sprites/hair"
const hatsDist = {
	0: preload("res://sprites/character/hat/hat_cowboy.png"),
	1: preload("res://sprites/character/hat/hat_witch.png")
}
const hairOptions = {
	0: Color(1, 1, 1, 1),
	1: Color(1, 0, 1, 1),
	2: Color(1, 1, 0, 1)
}

var curr_hat = 0
var curr_hair = 0

func _on_change_hat_pressed():
	curr_hat += 1
	hat_texture.texture = hatsDist[(curr_hat) % hatsDist.size()]

func _on_change_hair_pressed() -> void:
	curr_hair += 1
	hair_sprite.modulate = hairOptions[curr_hair % hairOptions.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_character_customizer"):
		view.visible = !view.visible



