extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0

@onready var character_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if (velocity.x>1 || velocity.x<-1):
		character_sprite.animation = "run"
	else:
		character_sprite.animation = "default"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		character_sprite.animation = "jump"
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		character_sprite.animation = "jump"
	
	if Input.is_action_just_pressed("duck") and !is_on_floor():
		velocity.y = -1 * JUMP_VELOCITY
		character_sprite.animation = "duck"

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	#var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 45)

	var isLeft = velocity.x <0
	character_sprite.flip_h = isLeft
	
	move_and_slide()
