class_name Enemy extends CharacterBody2D

enum States { BLOCKED, IDLE, WALKING, ATTACK, STAGGERED, ESCAPING }

static var enemy_group := "enemies"

@export var speed := 300
@export var navigation_agent: NavigationAgent2D
@export var combat_module: CombatModule
@export var timer: Timer

var target: Node2D
var state: States = States.IDLE
var movement_direction: Vector2


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _physics_process(_delta: float) -> void:
	movement_direction = (
		to_local(navigation_agent.get_next_path_position()).normalized()
	)
	if state == States.IDLE:
		velocity = movement_direction * speed
		move_and_slide()
	if  state == States.ESCAPING:
		velocity = -movement_direction * speed
		move_and_slide()

func set_target() -> void:
	navigation_agent.target_position = target.global_position


func _on_timer_timeout() -> void:
	set_target()


func damage(damage_taken: float, attack_direction: Vector2 = Vector2.ZERO) -> void:
	combat_module.damage(damage_taken, attack_direction)
