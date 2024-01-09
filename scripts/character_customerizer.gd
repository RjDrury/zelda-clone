extends Control

@onready var view = $"."
@onready var hat_texture = $"../sprites/hat"
const hatsDist = {
	0: preload("res://sprites/character/hat/hat_cowboy.png"),
	1: preload("res://sprites/character/hat/hat_witch.png")
}

var curr_hat = 0

func _on_change_hat_pressed():
	hat_texture.texture = hatsDist[(curr_hat + 1) % hatsDist.size()]
	curr_hat += 1
	print(curr_hat)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_character_customizer"):
		view.visible = !view.visible
