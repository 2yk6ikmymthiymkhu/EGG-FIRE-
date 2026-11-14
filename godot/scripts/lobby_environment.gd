extends Node3D
# Lobby 3D do EGG FIRE: cenário inspirado na referência anime japonesa.
# Geometria procedural provisória; modelos artísticos finais podem substituir cada peça.

const MAT = {
    "stone": Color("#77758e"), "stone_light": Color("#aaa0ae"),
    "grass": Color("#496f59"), "wood": Color("#6f302d"),
    "wood_light": Color("#a94a3c"), "roof": Color("#252b49"),
    "gold": Color("#f4bd55"), "pink": Color("#ff83c8"),
    "pink_light": Color("#ffc1e5"), "paper": Color("#ffe0a0"),
    "mountain": Color("#526f9d"), "mountain_light": Color("#7893c2"),
    "sky": Color("#2388e9")
}

func _ready() -> void:
    _make_environment()
    _make_courtyard()
    _make_shrine()
    _make_torii()
    _make_pagoda()
    _make_cherry_trees()
    _make_lanterns()
    _make_railings()
    _make_lobby_ui()
    var player := get_node_or_null("Player")
    if player:
        player.position = Vector3(0, 0, 8.5)
        var body := player.get_node_or_null("BodyMesh")
        if body:
            body.visible = false

func _material(color: Color, roughness := 0.82) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = roughness
    return m

func _mesh(parent: Node3D, mesh: Mesh, pos: Vector3, color: Color, scale_value := Vector3.ONE) -> MeshInstance3D:
    var item := MeshInstance3D.new()
    item.mesh = mesh
    item.position = pos
    item.scale = scale_value
    item.material_override = _material(color)
    parent.add_child(item)
    return item

func _box(parent: Node3D, pos: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
    var mesh := BoxMesh.new()
    mesh.size = size
    return _mesh(parent, mesh, pos, color)

func _cylinder(parent: Node3D, pos: Vector3, radius: float, height: float, color: Color, sides := 12) -> MeshInstance3D:
    var mesh := CylinderMesh.new()
    mesh.top_radius = radius
    mesh.bottom_radius = radius
    mesh.height = height
    mesh.radial_segments = sides
    return _mesh(parent, mesh, pos, color)

func _sphere(parent: Node3D, pos: Vector3, radius: float, color: Color, scale_value := Vector3.ONE) -> MeshInstance3D:
    var mesh := SphereMesh.new()
    mesh.radius = radius
    mesh.height = radius * 2.0
    return _mesh(parent, mesh, pos, color, scale_value)

func _make_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_mat := ProceduralSkyMaterial.new()
    sky_mat.sky_top_color = Color("#0875ed")
    sky_mat.sky_horizon_color = Color("#b8ddff")
    sky_mat.ground_bottom_color = Color("#52617c")
    sky_mat.ground_horizon_color = Color("#b7d7ef")
    sky.sky_material = sky_mat
    env.sky = sky
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color("#c8d9ff")
    env.ambient_light_energy = 0.75
    env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    world.environment = env
    add_child(world)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -28, 0)
    sun.light_color = Color("#ffe4ce")
    sun.light_energy = 1.25
    sun.shadow_enabled = true
    add_child(sun)

func _make_courtyard() -> void:
    _box(self, Vector3(0, -0.35, -3), Vector3(34, 0.7, 38), MAT.grass)
    _box(self, Vector3(0, 0.02, 3), Vector3(28, 0.18, 22), MAT.stone)
    for x in range(-13, 14, 2):
        for z in range(-6, 13, 2):
            _box(self, Vector3(x, 0.13, z), Vector3(1.88, 0.08, 1.88), MAT.stone_light if (x + z) % 4 == 0 else MAT.stone)
    # Montanhas em camadas ao fundo
    for i in range(7):
        var x := -15.0 + float(i) * 5.0
        var h := 5.5 + float((i * 7) % 4) * 1.4
        var peak := _mesh(self, PrismMesh.new(), Vector3(x, h * 0.5, -18), MAT.mountain if i % 2 == 0 else MAT.mountain_light, Vector3(4.8, h, 3.0))
        peak.rotation_degrees.y = 45

func _make_shrine() -> void:
    var x := -8.0
    _box(self, Vector3(x, 1.0, -3.5), Vector3(6.0, 2.0, 4.0), MAT.wood)
    _box(self, Vector3(x, 2.05, -3.5), Vector3(6.8, 0.25, 4.7), MAT.gold)
    _box(self, Vector3(x, 2.45, -3.5), Vector3(7.4, 0.28, 5.0), MAT.roof)
    _box(self, Vector3(x, 1.0, -1.42), Vector3(5.2, 1.9, 0.18), Color("#39273d"))
    for side in [-1.0, 1.0]:
        _box(self, Vector3(x + side * 2.8, 1.25, -1.2), Vector3(0.28, 2.5, 0.3), MAT.wood_light)
    # Degraus
    for i in range(4):
        _box(self, Vector3(x, 0.22 + i * 0.16, -0.8 + i * 0.42), Vector3(4.0 - i * 0.25, 0.22, 0.8), MAT.stone_light)
    # beirais do telhado
    _box(self, Vector3(x, 2.75, -3.5), Vector3(8.0, 0.16, 5.6), MAT.roof)

func _make_torii() -> void:
    var x := 8.0
    for side in [-1.0, 1.0]:
        _box(self, Vector3(x + side * 2.5, 2.0, -1.0), Vector3(0.48, 4.0, 0.5), Color("#a92336"))
        _box(self, Vector3(x + side * 2.5, 0.22, -1.0), Vector3(0.9, 0.45, 0.9), MAT.roof)
    _box(self, Vector3(x, 4.05, -1.0), Vector3(6.4, 0.48, 0.7), Color("#a92336"))
    _box(self, Vector3(x, 4.38, -1.0), Vector3(7.0, 0.22, 0.85), MAT.roof)
    _box(self, Vector3(x, 3.25, -1.0), Vector3(5.2, 0.25, 0.5), Color("#a92336"))

func _make_pagoda() -> void:
    var base := Vector3(0, 0, -16)
    _box(self, base + Vector3(0, 0.5, 0), Vector3(3.5, 1.0, 3.5), MAT.wood)
    for floor_index in range(4):
        var y := 1.3 + floor_index * 1.45
        var width := 3.8 - floor_index * 0.55
        _box(self, base + Vector3(0, y, 0), Vector3(width * 0.62, 1.15, width * 0.62), Color("#8b3b48"))
        _box(self, base + Vector3(0, y + 0.68, 0), Vector3(width, 0.2, width), MAT.roof)
        _box(self, base + Vector3(0, y + 0.82, 0), Vector3(width * 0.82, 0.12, width * 0.82), MAT.gold)
    _cylinder(self, base + Vector3(0, 7.0, 0), 0.09, 1.7, MAT.gold, 8)

func _make_cherry_trees() -> void:
    var positions := [Vector3(-12, 0, -5), Vector3(-12, 0, 4), Vector3(12, 0, -7), Vector3(13, 0, 4)]
    for p in positions:
        _cylinder(self, p + Vector3(0, 2.4, 0), 0.28, 4.8, Color("#49303b"), 9)
        for i in range(9):
            var angle := float(i) * TAU / 9.0
            var offset := Vector3(cos(angle) * 1.8, 3.7 + sin(angle * 2.0) * 0.5, sin(angle) * 1.4)
            _sphere(self, p + offset, 1.35, MAT.pink if i % 2 == 0 else MAT.pink_light, Vector3(1.25, 0.72, 1.0))
        for j in range(8):
            var petal_pos := p + Vector3(randf_range(-3, 3), randf_range(1.8, 4.8), randf_range(-2, 2))
            _sphere(self, petal_pos, 0.12, MAT.pink, Vector3(1.8, 0.25, 0.8))

func _make_lanterns() -> void:
    for p in [Vector3(-4.5, 2.2, -1.4), Vector3(4.5, 2.2, -1.4), Vector3(-10.8, 2.0, -1.0), Vector3(10.8, 2.0, -1.0)]:
        _box(self, p, Vector3(0.72, 0.9, 0.72), MAT.gold)
        _box(self, p + Vector3(0, 0.53, 0), Vector3(0.9, 0.12, 0.9), MAT.roof)
        var glow := OmniLight3D.new()
        glow.position = p
        glow.light_color = Color("#ffb45c")
        glow.light_energy = 0.65
        glow.omni_range = 4.0
        add_child(glow)

func _make_railings() -> void:
    for x in range(-10, 11, 2):
        _box(self, Vector3(x, 0.8, -8.0), Vector3(0.22, 1.6, 0.25), MAT.wood_light)
    _box(self, Vector3(0, 1.45, -8.0), Vector3(22, 0.22, 0.35), MAT.wood)

func _make_lobby_ui() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var ui := Control.new()
    ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(ui)
    _ui_button(ui, "PERFIL", Vector2(28, 22), Vector2(112, 72), Color("#0875ed"))
    _ui_button(ui, "LOJA", Vector2(150, 22), Vector2(112, 72), Color("#f3a51d"))
    _ui_button(ui, "PERSONAGENS", Vector2(28, -94), Vector2(235, 72), Color("#0875ed"), true)
    _ui_button(ui, "▶  COMEÇAR", Vector2(-270, -94), Vector2(242, 72), Color("#f3a51d"), false, true)

func _ui_button(parent: Control, label: String, offset: Vector2, size: Vector2, color: Color, bottom := false, right := false) -> void:
    var button := Button.new()
    button.text = label
    button.add_theme_font_size_override("font_size", 23)
    button.add_theme_color_override("font_color", Color.WHITE)
    button.add_theme_color_override("font_outline_color", Color("#20243a"))
    button.add_theme_constant_override("outline_size", 4)
    button.custom_minimum_size = size
    button.position = offset
    if bottom:
        button.anchor_top = 1.0
        button.anchor_bottom = 1.0
    if right:
        button.anchor_left = 1.0
        button.anchor_right = 1.0
    var normal := StyleBoxFlat.new()
    normal.bg_color = color
    normal.border_color = Color("#17213c")
    normal.set_border_width_all(3)
    normal.set_corner_radius_all(16)
    normal.shadow_color = Color(0, 0, 0, 0.35)
    normal.shadow_size = 5
    button.add_theme_stylebox_override("normal", normal)
    var hover := normal.duplicate()
    hover.bg_color = color.lightened(0.16)
    button.add_theme_stylebox_override("hover", hover)
    button.pressed.connect(func(): print("EGG FIRE lobby: ", label))
    parent.add_child(button)
