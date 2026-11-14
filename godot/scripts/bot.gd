extends CharacterBody3D

@export var move_speed := 2.6
@export var detection_range := 28.0
@export var attack_range := 1.8
@export var damage_per_hit := 8.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var target: Node3D
var attack_cooldown := 0.0
var health := 100.0
var wander_direction := Vector3.ZERO
var wander_timer := 0.0

func _ready() -> void:
    add_to_group("bots")
    var players := get_tree().get_nodes_in_group("player")
    if not players.is_empty():
        target = players[0]

func take_damage(amount: float) -> void:
    health = maxf(health - amount, 0.0)
    if health <= 0.0:
        remove_from_group("bots")
        queue_free()

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    attack_cooldown = maxf(attack_cooldown - delta, 0.0)
    var desired := Vector3.ZERO
    if is_instance_valid(target):
        var distance := global_position.distance_to(target.global_position)
        if distance <= detection_range:
            desired = target.global_position - global_position
            desired.y = 0.0
            if distance <= attack_range and attack_cooldown <= 0.0:
                if target.has_method("take_damage"):
                    target.take_damage(damage_per_hit)
                attack_cooldown = 1.2
    if desired.length() < 0.01:
        wander_timer -= delta
        if wander_timer <= 0.0:
            wander_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
            wander_timer = randf_range(1.5, 4.0)
        desired = wander_direction
    desired = desired.normalized()
    velocity.x = move_toward(velocity.x, desired.x * move_speed, 8.0 * delta)
    velocity.z = move_toward(velocity.z, desired.z * move_speed, 8.0 * delta)
    if desired.length() > 0.1:
        look_at(global_position + desired, Vector3.UP)
    move_and_slide()
