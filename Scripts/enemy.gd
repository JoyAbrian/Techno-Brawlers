extends CharacterBody2D

@export var speed: float = 150.0
@export var attack_duration: float = 2.0
@export var attack_range: float = 20.0
@export var max_health: int = 100
@onready var animated_sprite: AnimatedSprite2D = $"Bat Guy"

var current_health: int = max_health
var is_attacking: bool = false
var attack_timer: float = 0.0
var target: Node2D = null

func _ready() -> void:
	target = get_node("../../player")

func _physics_process(delta: float) -> void:
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
		return

	if target:
		var distance_to_target = position.distance_to(target.position)
		if distance_to_target > attack_range:
			move_towards_target()
		else:
			if not is_attacking:
				start_attack()

	move_and_slide()

func move_towards_target() -> void:
	var direction = (target.position - position).normalized()
	velocity = direction * speed

	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false

	animated_sprite.play("Walk")

func start_attack() -> void:
	if not is_attacking:
		is_attacking = true
		attack_timer = attack_duration
		animated_sprite.play("Attack")
		velocity = Vector2.ZERO

		if target and target.has_method("take_damage"):
			target.call("take_damage", 10)

func take_damage(damage: int) -> void:
	current_health -= damage
	if current_health <= 0:
		die()
	else:
		animated_sprite.play("Hurt")

func die() -> void:
	queue_free()
