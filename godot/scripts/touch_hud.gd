extends CanvasLayer

var player: CharacterBody3D
var joystick_origin := Vector2.ZERO
var joystick_vector := Vector2.ZERO
var joystick_active := false
var joystick_radius := 76.0
var jump_button: Button

func _ready() -> void:
    player = get_parent() as CharacterBody3D
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(root)

    var jump := Button.new()
    jump.text = "PULAR"
    jump.custom_minimum_size = Vector2(104, 72)
    jump.anchor_left = 1.0
    jump.anchor_top = 1.0
    jump.anchor_right = 1.0
    jump.anchor_bottom = 1.0
    jump.offset_left = -132
    jump.offset_top = -112
    jump.offset_right = -28
    jump.offset_bottom = -40
    jump.pressed.connect(player.request_jump)
    root.add_child(jump)
    jump_button = jump

    root.draw.connect(_draw_joystick.bind(root))

func _draw_joystick(_root: Control) -> void:
    if joystick_active:
        _root.draw_circle(joystick_origin, joystick_radius, Color(0.1, 0.1, 0.1, 0.28))
        _root.draw_circle(joystick_origin + joystick_vector * joystick_radius, 28.0, Color(0.9, 0.9, 0.95, 0.75))

func _unhandled_input(event: InputEvent) -> void:
    var screen_size := get_viewport().get_visible_rect().size
    if event is InputEventScreenTouch:
        if event.pressed and event.position.x < screen_size.x * 0.42 and event.position.y > screen_size.y * 0.35:
            joystick_active = true
            joystick_origin = event.position
            _update_joystick(event.position)
        elif not event.pressed and joystick_active:
            joystick_active = false
            joystick_vector = Vector2.ZERO
            player.set_touch_move(Vector2.ZERO)
            get_viewport().set_input_as_handled()
    elif event is InputEventScreenDrag and joystick_active and event.position.x < screen_size.x * 0.48:
        _update_joystick(event.position)

func _update_joystick(position: Vector2) -> void:
    joystick_vector = ((position - joystick_origin) / joystick_radius).limit_length(1.0)
    player.set_touch_move(joystick_vector)
    get_viewport().get_camera_3d()
    queue_redraw()
