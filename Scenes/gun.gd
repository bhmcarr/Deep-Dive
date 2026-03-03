extends Node2D
var bullet_scene = preload("res://Scenes/bullet.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var casing_particles: CPUParticles2D = $CasingParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# handle gun rotation
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var rel_rotation = fmod(rotation_degrees, 360)
	if rel_rotation > 135:
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
		
	if Input.is_action_just_pressed("shoot"):
		_shoot(mouse_pos) # pass in normalized direction from mouse position
	
		
func _shoot(mouse_pos: Vector2) -> void:
	casing_particles.emitting = true
	animation_player.play("fire")
	var bullet = bullet_scene.instantiate()
	bullet.global_position = to_global(bullet_spawn_point.position)
	bullet.initial_direction = (mouse_pos - global_position).normalized()
	
	get_tree().current_scene.add_child(bullet)
