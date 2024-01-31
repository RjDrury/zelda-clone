# MainScene.gd

extends Node

var transition_scene

@export var scene_directory = "res://scenes/locations/player_house.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body && body.get('is_player'):
		get_tree().change_scene_to_file(scene_directory)
