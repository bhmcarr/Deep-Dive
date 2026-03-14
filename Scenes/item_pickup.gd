extends Area2D

@export var item_given: Item
@onready var floating_text_emitter: Node2D = $FloatingTextEmitter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(2): # player
		Inventory.add_item(item_given)
		floating_text_emitter.emit_text("Picked up " + item_given.name)
		queue_free()
