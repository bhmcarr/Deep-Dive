extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	position.x += direction.x * delta * SPEED
	direction.y = Input.get_axis("move_up", "move_down")
	position.y += direction.y * delta * SPEED

	_handle_animations()
	move_and_slide()
	
func _handle_animations() -> void:
	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
		
	if direction.x > 0:
		animated_sprite_2d.flip_h = true
	elif direction.x < 0:
		animated_sprite_2d.flip_h = false
