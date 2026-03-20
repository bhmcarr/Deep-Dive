extends Area2D

@export var item_given: Item
@onready var floating_text_emitter: Node2D = $FloatingTextEmitter

func _on_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(2) && !Inventory.is_full(): # player
		Inventory.add_item(item_given)
		floating_text_emitter.emit_text("Picked up " + item_given.name)
		queue_free()
	else:
		floating_text_emitter.emit_text("Inventory is full!")
