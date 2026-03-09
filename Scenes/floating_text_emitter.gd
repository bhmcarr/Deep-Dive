extends Node2D

@export var floating_text_scene: PackedScene = preload("res://Scenes/floating_text.tscn")
var rng = RandomNumberGenerator.new()

func emit_text(text: String) -> void:
	var rand_x = rng.randi_range(-20, 20)
	var rand_y = rng.randi_range(-20, 20)
	
	var floating_text = floating_text_scene.instantiate()
	floating_text.text = text
	floating_text.global_position = get_parent().global_position + Vector2(rand_x, rand_y)
	get_tree().current_scene.add_child(floating_text)
	
