extends RigidBody2D

@onready var valuable_handler: Node2D = $ValuableHandler

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(Vector2.ZERO)
	#if collision_info:
		#valuable_handler.damage_valuable(5)
		
