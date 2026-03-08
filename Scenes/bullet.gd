extends RigidBody2D

@export var initial_direction: Vector2 = Vector2.ZERO
@onready var sprite_2d: Sprite2D = $Sprite2D

var bullet_hole_scene = preload("res://Scenes/bullet_hole.tscn")
var bullet_hit_scene = preload("res://Scenes/bullet_hit_effect.tscn")
@onready var bullet_hit_sound_player: AudioStreamPlayer2D = $BulletHitSoundPlayer

var direction := Vector2.ZERO
var BULLET_SPEED = 500.0
var BULLET_POWER = 1000.00
var BULLET_DAMAGE = 20

var velocity = Vector2(250, 250)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = initial_direction
	look_at(get_global_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = direction * BULLET_SPEED
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		# apply force if needed
		var body = collision_info.get_collider()
		if body.has_method("get_collision_layer_value"):
			if body.get_collision_layer_value(3):
				print("hit valuable")
				_spawn_bullet_hit()
				bullet_hit_sound_player.playing = true
				body.apply_impulse(direction * BULLET_POWER)
				body.apply_torque_impulse(BULLET_POWER)
				body.damage_prop(BULLET_DAMAGE)
		else:
			_spawn_bullet_hole()
		
		queue_free()
		
func _spawn_bullet_hole():
	var bullet_hole = bullet_hole_scene.instantiate()
	bullet_hole.global_position = global_position
	get_tree().current_scene.add_child(bullet_hole)
	
func _spawn_bullet_hit():
	var bullet_hit = bullet_hit_scene.instantiate()
	bullet_hit.global_position = global_position
	get_tree().current_scene.add_child(bullet_hit)
