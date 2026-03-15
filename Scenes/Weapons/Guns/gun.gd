extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var casing_particles: CPUParticles2D = $CasingParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle_flare: Sprite2D = $Sprite2D/MuzzleFlare
@onready var delay_timer: Timer = $DelayTimer
@onready var gun_sound_player: AudioStreamPlayer2D = $GunSoundPlayer
@onready var melee_hitbox: Area2D = $MeleeHitbox

@export var delay: float = 0.5 # time between shots in seconds
@export var melee_power := 750.0 # how much melee attacks affect physics objects
@export var melee_damage := 10.0 # how much melee damage this weapon inflicts
@export var bullet_scene: PackedScene = preload("res://Scenes/Weapons/Projectiles/bullet.tscn")
@export var bullet_speed := 500.0
@export var bullet_power := 1000.0
@export var bullet_damage := 20
@export var shake_screen: bool

enum ShotType {Single, Spread}
@export var shot_type: ShotType = ShotType.Single

#signal fired(shake_screen: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delay_timer.wait_time = delay
	add_to_group("guns")


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
		
	if Input.is_action_just_pressed("shoot") && delay_timer.is_stopped():
		match shot_type:
			ShotType.Single:
				_shoot(mouse_pos) # pass in normalized direction from mouse position
			ShotType.Spread:
				_shoot_spread(mouse_pos)
		
func _shoot(mouse_pos: Vector2) -> void:
	_play_gunfire_effects()
	
	var bullet = bullet_scene.instantiate()
	bullet.power = bullet_power
	bullet.speed = bullet_speed
	bullet.damage = bullet_damage
	bullet.global_position = to_global(bullet_spawn_point.position)
	bullet.initial_direction = (mouse_pos - global_position).normalized()
	
	get_tree().current_scene.add_child(bullet)
	
	Global.weapon_fired.emit(shake_screen)
	delay_timer.start()
	
func _shoot_spread(mouse_pos: Vector2) -> void:
	_play_gunfire_effects()
	
	var deg_vals = [-5, -2, 0, 2, 5]
	for i in deg_vals:
		var bullet = bullet_scene.instantiate()
		bullet.power = bullet_power
		bullet.speed = bullet_speed
		bullet.damage = bullet_damage
		bullet.global_position = to_global(bullet_spawn_point.position)
		bullet.initial_direction = (mouse_pos.rotated(deg_to_rad(i)) - global_position).normalized()
		get_tree().current_scene.add_child(bullet)
	
	Global.weapon_fired.emit(shake_screen)
	delay_timer.start()

func _play_gunfire_effects() -> void:
	casing_particles.emitting = true
	animation_player.play("fire")
	muzzle_flare.visible = true
	await get_tree().create_timer(0.1).timeout
	muzzle_flare.visible = false
	gun_sound_player.playing = true

func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	# TODO: Vary melee power (knockback) based on how much the melee weapon swung
	# You'll need a timer to update a value of how hard the weapon is currently being swung
	if body.get_collision_layer_value(3) || body.get_collision_layer_value(5):
		body.apply_impulse((get_global_mouse_position() - position).normalized() * melee_power)
		body.apply_torque_impulse(melee_power)
		if body.has_node("Valuable"):
			body.get_node("Valuable").damage_prop(melee_damage)
