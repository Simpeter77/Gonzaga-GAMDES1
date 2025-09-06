extends CharacterBody2D

const SPEED = 340.0
const JUMP_VELOCITY = -900.0

@onready var character_sprite = $AnimatedSprite2D

@export var weapon_scene: PackedScene = preload("res://weapon.tscn")
@export var weapon_cooldown: float = 0.3
@export var weapon_offset: Vector2 = Vector2(10, -5)  # adjust spawn point

var time_shot := 0.0
var last_x_direction: int = 1

func _physics_process(delta: float) -> void:
	time_shot += delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		character_sprite.animation = "jump"

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		character_sprite.animation = "jump"
	
	if Input.is_action_just_pressed("duck") and not is_on_floor():
		velocity.y = -1 * JUMP_VELOCITY
		character_sprite.animation = "duck"

	var input_dir := Input.get_axis("left", "right")
	if input_dir != 0:
		velocity.x = input_dir * SPEED
		last_x_direction = int(sign(input_dir))
	else:
		velocity.x = move_toward(velocity.x, 0, 45)

	if abs(velocity.x) > 1:
		character_sprite.animation = "run"
	elif is_on_floor():
		character_sprite.animation = "default"
		
	character_sprite.flip_h = last_x_direction < 0

	# Shooting input (respect cooldown)
	if Input.is_action_just_pressed("shoot") and time_shot >= weapon_cooldown:
		shoot()
		time_shot = 0.0

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is CharacterBody2D and collider.is_in_group("Enemy"):
			_game_over()


func shoot() -> void:
	var weapon = weapon_scene.instantiate()
	weapon.global_position = global_position + Vector2(weapon_offset.x * last_x_direction, weapon_offset.y)
	weapon.direction = last_x_direction  # pass shooting direction
	get_tree().current_scene.add_child(weapon)


func _game_over() -> void:
	print("Game Over: Player touched the Enemy")
