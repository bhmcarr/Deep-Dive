extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floating_text_emitter: Node2D = $FloatingTextEmitter
@onready var item_use_particle_effect: CPUParticles2D = $ItemUseParticleEffect
@onready var item_upgrade_particle_effect: CPUParticles2D = $ItemUpgradeParticleEffect

const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2.ZERO
var push_force = 5.0

func _ready() -> void:
	# connect to global health signal
	Global.player_health_changed.connect(_on_player_health_changed)
	Global.player_speed_changed.connect(_on_player_speed_changed)

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	position.x += direction.x * delta * Global.player_speed
	direction.y = Input.get_axis("move_up", "move_down")
	position.y += direction.y * delta * Global.player_speed
	
	# Handle switching weapons
	var prev_index = Inventory.selected_item_index
	if Input.is_action_just_pressed("item_1"):
		Inventory.set_selected_item_index(0)
		_switch_weapon(0, prev_index)
	if Input.is_action_just_pressed("item_2"):
		Inventory.set_selected_item_index(1)
		_switch_weapon(1, prev_index)
	if Input.is_action_just_pressed("item_3"):
		Inventory.set_selected_item_index(2)
		_switch_weapon(2, prev_index)
		
	_handle_animations()
	move_and_slide()
	
	# TODO: This doesn't seem to work like I thought..
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			

func _switch_weapon(inv_index: int, previous_index: int) -> void:
	# bail if this is not a weapon
	#if Inventory.get_item(inv_index).type != Item.ItemType.RangedWeapon && Inventory.get_item(inv_index).type != Item.ItemType.MeleeWeapon:
		#return
		
	# get selected item
	var item_to_switch = Inventory.get_item(inv_index)
	
	# remove current weapon
	var current_weapons = get_tree().get_nodes_in_group("held_items")
	if current_weapons.size() != 0:
		if Inventory.current[previous_index].charges == 0:
			Inventory.remove_item(previous_index)
		current_weapons[0].queue_free()

	if item_to_switch == null || item_to_switch.type == Item.ItemType.Placeholder:
		return

	# replace with weapon in inventory
	var weapon_scene = load(item_to_switch.node_path)
	print ("Switched weapon to ", item_to_switch.name)
	var weapon = weapon_scene.instantiate()
	add_child(weapon)
	
	Global.weapon_changed.emit()
	
	
func _on_player_health_changed(amount: int, did_health_decrease: bool) -> void:
	item_use_particle_effect.emitting = true
	if did_health_decrease:
		floating_text_emitter.emit_text("-" + str(amount))
	else:
		floating_text_emitter.emit_text("+" + str(amount))

func _on_player_speed_changed(new_amount: int, did_speed_decrease: bool) -> void:
	item_upgrade_particle_effect.emitting = true
	floating_text_emitter.emit_text("SPEED IS NOW " + str(new_amount) + "!!")
	
func _handle_animations() -> void:
	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	if (position.x - get_global_mouse_position().x) < 0:
		animated_sprite_2d.flip_h = true
	elif (position.x - get_global_mouse_position().x) > 0:
		animated_sprite_2d.flip_h = false
