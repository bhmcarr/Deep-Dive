extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var x_direction = Input.get_axis("move_left", "move_right")
	position.x += x_direction * delta * SPEED
	var y_direction = Input.get_axis("move_up", "move_down")
	position.y += y_direction * delta * SPEED

	move_and_slide()
