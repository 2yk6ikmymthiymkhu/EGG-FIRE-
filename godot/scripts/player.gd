extends CharacterBody3D

@export var move_speed: float = 5.5
@export var acceleration: float = 18.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003
@export var touch_sensitivity: float = 0.005

@onready var camera_pivot: Node3D = $CameraPivot

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var touch_move: Vector2 = Vector2.ZERO
var look_touch_id: int = -1

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        _rotate_camera(event.relative * mouse_sensitivity)
    elif event is InputEventScreenTouch:
        if event.pressed and event.position.x > get_viewport().get_visible_rect().size.x * 0.42:
            look_touch_id = event.index
        elif not event.pressed and event.index == look_touch_id:
            look_touch_id = -1
    elif event is InputEventScreenDrag and event.index == look_touch_id:
        _rotate_camera(event.relative * touch_sensitivity)
    elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _rotate_camera(delta: Vector2) -> void:
    rotate_y(-delta.x)
    camera_pivot.rotate_x(-delta.y)
    camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-55), deg_to_rad(35))

func set_touch_move(value: Vector2) -> void:
    touch_move = value.limit_length(1.0)

func request_jump() -> void:
    if is_on_floor():
        velocity.y = jump_velocity

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta

    if Input.is_action_just_pressed("jump"):
        request_jump()

    var input_2d := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    if touch_move.length() > input_2d.length():
        input_2d = touch_move

    var direction := (transform.basis * Vector3(input_2d.x, 0.0, input_2d.y)).normalized()
    var target_velocity := direction * move_speed
    velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
    velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
    move_and_slide()
