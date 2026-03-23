extends Node2D
@onready var crosshair: Sprite2D = $Crosshair


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# hide the mouse cursor on gmae load
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Inventory.add_item(preload("uid://cge3leyx361p"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	crosshair.global_position = mouse_pos
	
	
