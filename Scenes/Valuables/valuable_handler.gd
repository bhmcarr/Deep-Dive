extends Node2D
@onready var floating_text_emitter: Node2D = $FloatingTextEmitter
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var break_particles: CPUParticles2D = $BreakParticles

@export var value: int = 100
@export var mass: float = 10

func _ready() -> void:
	# set default parent properties
	var valuable = get_parent()
	valuable.gravity_scale = 0.0
	valuable.mass = mass
	
	valuable.set_collision_layer_value(1, false) # turn off default
	valuable.set_collision_layer_value(3, true) # enable valuable collision layer
	valuable.set_collision_mask_value(1, true) # turn off default
	valuable.set_collision_mask_value(2, true) # turn off default

func damage_valuable(damage_amount: int) -> void:
	value -= damage_amount
	if value <= 0:
		_break_valuable()
	else:
		floating_text_emitter.emit_text("$" + str(value))
		
func _break_valuable() -> void:
	var image = sprite_2d.texture.get_image()
	var center_x = image.get_width() / 2
	var center_y = image.get_height() / 2
	var center_coords = Vector2i(center_x, center_y)
	var color: Color = image.get_pixelv(center_coords)
	
	sprite_2d.visible = false
	
	break_particles.color = color
	break_particles.emitting = true


func _on_break_particles_finished() -> void:
	# Free parent node (the actual valuable itself)
	get_parent().queue_free()
