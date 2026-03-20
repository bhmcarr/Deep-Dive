extends Sprite2D

@onready var fade_out_animaton: AnimationPlayer = $FadeOutAnimaton

func _on_fade_out_timer_timeout() -> void:
	fade_out_animaton.play("fade_out")


func _on_fade_out_animaton_animation_finished(anim_name: StringName) -> void:
	queue_free()
