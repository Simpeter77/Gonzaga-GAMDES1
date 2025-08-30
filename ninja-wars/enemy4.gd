extends CharacterBody2D

const SPEED = 600.0
@export var start_delay: float = 13.0   # delay before starting to move

@onready var character_sprite = $AnimatedSprite2D

# Start moving left by default
var direction: int = -1   
var can_move: bool = false

func _ready() -> void:
	# wait before allowing movement
	if start_delay > 0:
		await get_tree().create_timer(start_delay).timeout
	can_move = true

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Apply horizontal movement
	velocity.x = direction * SPEED
	character_sprite.flip_h = direction < 0

	move_and_slide()

	# Reverse direction when hitting a wall
	if is_on_wall():
		direction *= -1
