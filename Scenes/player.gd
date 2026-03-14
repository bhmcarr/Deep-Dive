extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2.ZERO
var push_force = 5.0

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	position.x += direction.x * delta * SPEED
	direction.y = Input.get_axis("move_up", "move_down")
	position.y += direction.y * delta * SPEED
	
	# Handle switching weapons
	if Input.is_action_just_pressed("item_1"):
		_switch_weapon(0)
	if Input.is_action_just_pressed("item_2"):
		_switch_weapon(1)
	if Input.is_action_just_pressed("item_3"):
		_switch_weapon(2)
		
	_handle_animations()
	move_and_slide()
	
	# TODO: This doesn't seem to work like I thought..
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
	
func _switch_weapon(inv_index: int) -> void:
	# get selected item
	var item_to_switch = Inventory.get_item(inv_index)
	if item_to_switch == null || item_to_switch.type != Global.ItemType.Weapon:
		return
	
	# remove current gun
	var current_gun = get_tree().get_nodes_in_group("guns")[0]
	current_gun.queue_free()
	
	# replace with gun in inventory
	var gun_scene = load(item_to_switch.node_path)
	print ("Switched weapon to ", item_to_switch.name)
	var gun = gun_scene.instantiate()
	add_child(gun)
	
	
	
func _handle_animations() -> void:
	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
		
	if direction.x > 0:
		animated_sprite_2d.flip_h = true
	elif direction.x < 0:
		animated_sprite_2d.flip_h = false
