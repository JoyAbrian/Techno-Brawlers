extends CharacterBody2D

@export var speed: float = 200.0
@export var attack_duration: float = 0.5
@onready var animated_sprite: AnimatedSprite2D = $Ajax

var is_attacking: bool = false
var attack_timer: float = 0.0

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			if velocity.length() > 0:
				animated_sprite.play("Run")
			else:
				animated_sprite.play("Idle")
		return

	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed

		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false

		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

	if Input.is_action_just_pressed("attack"):
		start_attack("Attack 1", 0.8)
	elif Input.is_action_just_pressed("double_attack"):
		start_attack("Attack 2", 1.1)
	elif Input.is_action_just_pressed("heavy_attack"):
		start_attack("Attack 3", 1.1)

	move_and_slide()

func start_attack(animation: String, attack_time: float) -> void:
	if not is_attacking:
		is_attacking = true
		attack_timer = attack_time
		animated_sprite.play(animation)
		velocity = Vector2.ZERO
