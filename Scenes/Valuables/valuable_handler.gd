extends Node2D
@onready var floating_text_emitter: Node2D = $FloatingTextEmitter
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var break_particles: CPUParticles2D = $BreakParticles
@onready var nearby_valuable_hitbox: Area2D = $NearbyValuableHitbox

@export var value: int = 100
@export var mass: float = 10
@export var keep_upright: bool = false

func _ready() -> void:
	# set default parent properties
	var valuable = get_parent()
	valuable.gravity_scale = 0.0
	valuable.mass = mass
	
	valuable.set_collision_layer_value(1, false) # turn off default
	valuable.set_collision_layer_value(3, true) # enable valuable collision layer
	valuable.set_collision_mask_value(1, true)
	valuable.set_collision_mask_value(2, true) 
	valuable.set_collision_mask_value(3, true) 
	
func _physics_process(delta: float) -> void:
	if keep_upright:
		# adjust parent's orientation
		var parent = get_parent()
		if "rotation" in parent:
			parent.rotation = 0

func damage_valuable(damage_amount: int, impact_direction: Vector2, impact_power: int) -> void:
	value -= damage_amount
	if value <= 0:
		_break_valuable()
	else:
		floating_text_emitter.emit_text("$" + str(value))
		
	if nearby_valuable_hitbox.has_overlapping_bodies():
		var bodies = nearby_valuable_hitbox.get_overlapping_bodies()
		for body in bodies:
			if body.has_method("apply_impulse"):
				body.apply_impulse(impact_direction * impact_power)
				body.apply_torque_impulse(impact_power)
		
func _break_valuable() -> void:
	var image = sprite_2d.texture.get_image()
	var center_x = image.get_width() / 2
	var center_y = image.get_height() / 2
	var center_coords = Vector2i(center_x, center_y)
	var color: Color = image.get_pixelv(center_coords)
	
	sprite_2d.visible = false
	# disable parent collision
	get_parent().get_node("CollisionShape2D").set_deferred('disabled', true)
	
	break_particles.color = color
	break_particles.emitting = true


func _on_break_particles_finished() -> void:
	# Free parent node (the actual valuable itself)
	get_parent().queue_free()
