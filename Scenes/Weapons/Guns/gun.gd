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
	add_to_group("held_items")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# handle gun rotation
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var rel_rotation = fmod(rotation_degrees, 360)
	var is_melee = Inventory.current[Inventory.selected_item_index].type == Item.ItemType.MeleeWeapon
	if rel_rotation > 135 && !is_melee:
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
		
	if Input.is_action_just_pressed("shoot") && delay_timer.is_stopped() && !is_melee:
		match shot_type:
			ShotType.Single:
				_shoot(mouse_pos) # pass in normalized direction from mouse position
			ShotType.Spread:
				_shoot_spread(mouse_pos)
		
func _shoot(mouse_pos: Vector2) -> void:
	var current_charges = Inventory.get_item(Inventory.selected_item_index).charges
	_play_gunfire_effects(current_charges == 0)
	if current_charges == 0:
		return
	
	Inventory.remove_charges(Inventory.selected_item_index, 1)
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
	var current_charges = Inventory.get_item(Inventory.selected_item_index).charges
	_play_gunfire_effects(current_charges == 0)
	if current_charges == 0:
		return
	
	var remaining_charges = Inventory.remove_charges(Inventory.selected_item_index, 1)
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

func _play_gunfire_effects(out_of_ammo: bool) -> void:
	animation_player.play("fire")
	if !out_of_ammo:
		casing_particles.emitting = true
		muzzle_flare.visible = true
		await get_tree().create_timer(0.1).timeout
		muzzle_flare.visible = false
		gun_sound_player.playing = true
