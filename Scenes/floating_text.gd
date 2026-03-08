extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_2d: Label = $Label2D

@export var text: String

func _ready() -> void:
	label_2d.text = text
	animation_player.play("float_up")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
