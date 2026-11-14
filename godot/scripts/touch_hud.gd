extends CanvasLayer

var player: CharacterBody3D
var joystick_origin := Vector2.ZERO
var joystick_vector := Vector2.ZERO
var joystick_active := false
var joystick_radius := 76.0
var hud_root: Control

func _ready() -> void:
    player = get_parent() as CharacterBody3D
    hud_root = Control.new()
    hud_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    hud_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(hud_root)
    hud_root.draw.connect(_draw_joystick)

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
    hud_root.add_child(jump)

    var fire := Button.new()
    fire.text = "ATIRAR"
    fire.custom_minimum_size = Vector2(112, 72)
    fire.anchor_left = 1.0
    fire.anchor_top = 1.0
    fire.anchor_right = 1.0
    fire.anchor_bottom = 1.0
    fire.offset_left = -132
    fire.offset_top = -220
    fire.offset_right = -28
    fire.offset_bottom = -148
    fire.pressed.connect(player.request_fire)
    hud_root.add_child(fire)

func _draw_joystick() -> void:
    if joystick_active:
        hud_root.draw_circle(joystick_origin, joystick_radius, Color(0.1, 0.1, 0.1, 0.28))
        hud_root.draw_circle(joystick_origin + joystick_vector * joystick_radius, 28.0, Color(0.9, 0.9, 0.95, 0.75))

func _unhandled_input(event: InputEvent) -> void:
    var screen_size := get_viewport().get_visible_rect().size
    if event is InputEventScreenTouch:
        if event.pressed and event.position.x < screen_size.x * 0.42 and event.position.y > screen_size.y * 0.35:
            joystick_active = true
            joystick_origin = event.position
            _update_joystick(event.position)
            get_viewport().set_input_as_handled()
        elif not event.pressed and joystick_active:
            joystick_active = false
            joystick_vector = Vector2.ZERO
            player.set_touch_move(Vector2.ZERO)
            hud_root.queue_redraw()
            get_viewport().set_input_as_handled()
    elif event is InputEventScreenDrag and joystick_active and event.position.x < screen_size.x * 0.48:
        _update_joystick(event.position)
        get_viewport().set_input_as_handled()

func _update_joystick(position: Vector2) -> void:
    joystick_vector = ((position - joystick_origin) / joystick_radius).limit_length(1.0)
    player.set_touch_move(joystick_vector)
    hud_root.queue_redraw()
