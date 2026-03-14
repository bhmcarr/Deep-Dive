extends Camera2D

@export var RANDOM_SHAKE_STRENGTH: float = 5.0
@export var SHAKE_DECAY_RATE: float = 10.0
@onready var rand = RandomNumberGenerator.new()

var player: CharacterBody2D
var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	var gun = get_tree().get_nodes_in_group("guns")[0] # Should only have one gun instantiated at a time
	#var gun = player.get_node("Gun")
	gun.fired.connect(_on_gun_fired)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position.lerp(player.position, delta * 100)
	
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)

	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = _get_random_offset()
	
	
func _on_gun_fired(shake_screen: bool) -> void:
	if shake_screen:
		apply_shake()
	
func apply_shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH

func _get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)
