extends Node2D

@export var floating_text_scene: PackedScene = preload("res://Scenes/floating_text.tscn")

func emit_text(text: String) -> void:
	var floating_text = floating_text_scene.instantiate()
	floating_text.text = text
	floating_text.global_position = get_parent().global_position
	get_tree().current_scene.add_child(floating_text)
	
