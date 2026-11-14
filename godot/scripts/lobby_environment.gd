extends Node3D
# EGG FIRE — lobby 3D estilizado inspirado na referência aprovada.
# Cenário montado com meshes leves para manter compatibilidade com Android.

const C = {
    "stone": Color("#77758e"), "tile": Color("#aaa0ae"), "grass": Color("#496f59"),
    "wood": Color("#71312f"), "red": Color("#a92538"), "roof": Color("#252b49"),
    "gold": Color("#f4bd55"), "pink": Color("#ff83c8"), "pale_pink": Color("#ffc1e5"),
    "mountain": Color("#526f9d"), "mountain2": Color("#7893c2"), "cloud": Color("#e8f5ff")
}

func mat(color: Color, roughness := 0.88) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = roughness
    return m

func add_box(parent: Node3D, pos: Vector3, size: Vector3, color: Color, bevel := false) -> MeshInstance3D:
    var mesh := BoxMesh.new()
    mesh.size = size
    var node := MeshInstance3D.new()
    node.mesh = mesh
    node.position = pos
    node.material_override = mat(color)
    parent.add_child(node)
    return node

func add_sphere(parent: Node3D, pos: Vector3, radius: float, color: Color, scale := Vector3.ONE) -> MeshInstance3D:
    var mesh := SphereMesh.new()
    mesh.radius = radius
    mesh.height = radius * 2.0
    var node := MeshInstance3D.new()
    node.mesh = mesh
    node.position = pos
    node.scale = scale
    node.material_override = mat(color)
    parent.add_child(node)
    return node

func add_cylinder(parent: Node3D, pos: Vector3, radius: float, height: float, color: Color) -> MeshInstance3D:
    var mesh := CylinderMesh.new()
    mesh.top_radius = radius
    mesh.bottom_radius = radius
    mesh.height = height
    mesh.radial_segments = 12
    var node := MeshInstance3D.new()
    node.mesh = mesh
    node.position = pos
    node.material_override = mat(color)
    parent.add_child(node)
    return node

func _ready() -> void:
    randomize()
    build_lighting()
    build_landscape()
    build_courtyard()
    build_shrine()
    build_torii()
    build_pagoda()
    build_sakura()
    build_lanterns()
    build_fence()
    build_camera()
    build_ui()

func build_lighting() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_material := ProceduralSkyMaterial.new()
    sky_material.sky_top_color = Color("#075ee8")
    sky_material.sky_horizon_color = Color("#a9d9ff")
    sky_material.sky_curve = 0.18
    sky_material.ground_bottom_color = Color("#53617d")
    sky_material.ground_horizon_color = Color("#b6d4ef")
    sky.sky_material = sky_material
    env.sky = sky
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color("#c6d9ff")
    env.ambient_light_energy = 0.8
    env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    world.environment = env
    add_child(world)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -28, 0)
    sun.light_color = Color("#ffe2d2")
    sun.light_energy = 1.35
    sun.shadow_enabled = true
    add_child(sun)

func build_landscape() -> void:
    # Camadas de montanhas com picos triangulares, atrás do templo.
    for i in range(9):
        var x := -20.0 + i * 5.0
        var h := 8.0 + float((i * 13) % 5) * 1.25
        var mesh := PrismMesh.new()
        mesh.size = Vector3(7.0, h, 4.0)
        var peak := MeshInstance3D.new()
        peak.mesh = mesh
        peak.position = Vector3(x, h * 0.48, -22.0)
        peak.rotation_degrees.y = 45
        peak.material_override = mat(C.mountain if i % 2 == 0 else C.mountain2)
        add_child(peak)
    # Nuvens volumétricas simples no horizonte.
    for i in range(14):
        var x := -18.0 + i * 2.8
        var y := 7.0 + sin(float(i) * 1.7) * 1.2
        var z := -19.0 - float(i % 3) * 1.2
        for j in range(3):
            add_sphere(self, Vector3(x + j * 0.8, y + (j % 2) * 0.35, z), 1.05, C.cloud, Vector3(1.5, 0.55, 0.8))

func build_courtyard() -> void:
    add_box(self, Vector3(0, -0.45, -2), Vector3(38, 0.8, 42), C.grass)
    add_box(self, Vector3(0, 0.02, 3), Vector3(29, 0.18, 22), C.stone)
    for x in range(-14, 15, 2):
        for z in range(-7, 14, 2):
            var color: Color = C.tile if (x + z) % 4 == 0 else C.stone
            add_box(self, Vector3(x, 0.14, z), Vector3(1.92, 0.08, 1.92), color)
    # Bordas e pequenos degraus do pátio.
    add_box(self, Vector3(0, 0.02, 14.2), Vector3(30, 0.35, 0.45), C.roof)
    add_box(self, Vector3(0, 0.02, -8.2), Vector3(30, 0.35, 0.45), C.roof)

func build_shrine() -> void:
    var x := -9.0
    # Edificação principal, portas, colunas e telhado em camadas.
    add_box(self, Vector3(x, 1.35, -3.4), Vector3(6.2, 2.7, 4.2), C.wood)
    add_box(self, Vector3(x, 1.35, -1.26), Vector3(4.5, 2.2, 0.12), Color("#39283d"))
    for side in [-1.0, 1.0]:
        add_box(self, Vector3(x + side * 2.65, 1.35, -1.1), Vector3(0.32, 2.8, 0.36), Color("#c05a45"))
    add_box(self, Vector3(x, 2.78, -3.4), Vector3(7.5, 0.22, 5.1), C.roof)
    add_box(self, Vector3(x, 3.0, -3.4), Vector3(8.1, 0.16, 4.5), C.wood)
    add_box(self, Vector3(x, 3.16, -3.4), Vector3(8.8, 0.18, 5.2), C.roof)
    # Telhado com beirais laterais em ângulo.
    for side in [-1.0, 1.0]:
        var eave := add_box(self, Vector3(x + side * 3.5, 3.0, -3.4), Vector3(1.4, 0.18, 5.4), C.roof)
        eave.rotation.z = side * deg_to_rad(-8)
    # Janela iluminada.
    add_box(self, Vector3(x - 1.75, 1.65, -1.18), Vector3(1.15, 1.35, 0.08), C.gold)
    # Escadaria frontal.
    for i in range(5):
        add_box(self, Vector3(x, 0.2 + i * 0.14, -0.15 + i * 0.4), Vector3(4.5 - i * 0.18, 0.2, 0.75), C.tile)

func build_torii() -> void:
    var x := 9.0
    for side in [-1.0, 1.0]:
        add_box(self, Vector3(x + side * 2.5, 2.1, -1.4), Vector3(0.52, 4.2, 0.58), C.red)
        add_box(self, Vector3(x + side * 2.5, 0.2, -1.4), Vector3(0.9, 0.42, 0.9), C.roof)
    add_box(self, Vector3(x, 4.18, -1.4), Vector3(6.8, 0.5, 0.8), C.red)
    add_box(self, Vector3(x, 4.53, -1.4), Vector3(7.6, 0.24, 1.0), C.roof)
    add_box(self, Vector3(x, 3.35, -1.4), Vector3(5.4, 0.28, 0.65), C.red)
    # Vigas superiores projetadas.
    for side in [-1.0, 1.0]:
        var tip := add_box(self, Vector3(x + side * 3.15, 4.58, -1.4), Vector3(1.1, 0.18, 0.85), C.roof)
        tip.rotation.z = side * deg_to_rad(8)

func build_pagoda() -> void:
    var base := Vector3(0, 0, -18.5)
    add_box(self, base + Vector3(0, 0.5, 0), Vector3(4.0, 1.0, 4.0), C.wood)
    for level in range(4):
        var y := 1.2 + level * 1.48
        var w := 4.4 - level * 0.62
        add_box(self, base + Vector3(0, y, 0), Vector3(w * 0.65, 1.15, w * 0.65), Color("#8d3d50"))
        add_box(self, base + Vector3(0, y + 0.68, 0), Vector3(w, 0.22, w), C.roof)
        add_box(self, base + Vector3(0, y + 0.84, 0), Vector3(w * 0.82, 0.12, w * 0.82), C.gold)
        for side in [-1.0, 1.0]:
            add_box(self, base + Vector3(side * w * 0.24, y, w * 0.34), Vector3(0.12, 0.9, 0.12), C.gold)
    add_cylinder(self, base + Vector3(0, 7.25, 0), 0.1, 1.8, C.gold)

func build_sakura() -> void:
    var tree_positions := [Vector3(-14, 0, -4), Vector3(-13, 0, 5), Vector3(14, 0, -5), Vector3(14, 0, 5)]
    for p in tree_positions:
        add_cylinder(self, p + Vector3(0, 2.5, 0), 0.3, 5.0, Color("#49303b"))
        # Galhos horizontais visíveis sob a copa.
        for branch in range(4):
            var limb := add_cylinder(self, p + Vector3((branch - 1.5) * 0.75, 3.5, -0.15), 0.11, 2.1, Color("#49303b"))
            limb.rotation.z = deg_to_rad(55 if branch % 2 == 0 else -55)
        for i in range(13):
            var angle := TAU * float(i) / 13.0
            var crown_pos := p + Vector3(cos(angle) * 2.0, 4.0 + sin(angle * 2.0) * 0.55, sin(angle) * 1.55)
            add_sphere(self, crown_pos, 1.12, C.pink if i % 2 == 0 else C.pale_pink, Vector3(1.35, 0.7, 1.0))
        for j in range(10):
            add_sphere(self, p + Vector3(randf_range(-3.2, 3.2), randf_range(2.5, 5.3), randf_range(-2.2, 2.2)), 0.11, C.pink, Vector3(1.7, 0.25, 0.8))

func build_lanterns() -> void:
    var positions := [Vector3(-5.2, 2.15, -1.25), Vector3(5.2, 2.15, -1.25), Vector3(-11.7, 2.2, -0.8), Vector3(11.7, 2.2, -0.8)]
    for p in positions:
        add_box(self, p, Vector3(0.68, 0.95, 0.68), Color("#f6a84d"))
        add_box(self, p + Vector3(0, 0.56, 0), Vector3(0.9, 0.14, 0.9), C.roof)
        add_box(self, p + Vector3(0, -0.55, 0), Vector3(0.85, 0.12, 0.85), C.roof)
        var light := OmniLight3D.new()
        light.position = p
        light.light_color = Color("#ffae55")
        light.light_energy = 0.8
        light.omni_range = 4.5
        add_child(light)

func build_fence() -> void:
    for x in range(-11, 12, 2):
        add_box(self, Vector3(x, 0.8, -9.0), Vector3(0.22, 1.6, 0.28), C.wood)
    add_box(self, Vector3(0, 1.42, -9.0), Vector3(23, 0.22, 0.35), C.wood)
    add_box(self, Vector3(0, 0.55, -9.0), Vector3(23, 0.18, 0.32), C.wood)

func build_camera() -> void:
    var camera := Camera3D.new()
    camera.position = Vector3(0, 8.2, 21.5)
    camera.fov = 54.0
    add_child(camera)
    camera.look_at(Vector3(0, 3.2, -7.0), Vector3.UP)
    camera.current = true

func build_ui() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(root)
    make_button(root, "♙  PERFIL", 0.025, 0.035, 0.105, 0.105, Color("#0875ed"))
    make_button(root, "🛒  LOJA", 0.135, 0.035, 0.105, 0.105, Color("#f3a51d"))
    make_button(root, "♟  PERSONAGENS", 0.025, 0.86, 0.19, 0.105, Color("#0875ed"))
    make_button(root, "▶  COMEÇAR", 0.79, 0.86, 0.19, 0.105, Color("#f3a51d"))

func make_button(root: Control, label: String, left: float, top: float, width: float, height: float, color: Color) -> void:
    var button := Button.new()
    button.text = label
    button.anchor_left = left
    button.anchor_top = top
    button.anchor_right = left + width
    button.anchor_bottom = top + height
    button.offset_left = 0
    button.offset_top = 0
    button.offset_right = 0
    button.offset_bottom = 0
    button.add_theme_font_size_override("font_size", 19)
    button.add_theme_color_override("font_color", Color.WHITE)
    button.add_theme_color_override("font_outline_color", Color("#17213c"))
    button.add_theme_constant_override("outline_size", 4)
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.border_color = Color("#17213c")
    style.set_border_width_all(3)
    style.set_corner_radius_all(13)
    style.shadow_color = Color(0, 0, 0, 0.35)
    style.shadow_size = 5
    button.add_theme_stylebox_override("normal", style)
    var hover := style.duplicate()
    hover.bg_color = color.lightened(0.16)
    button.add_theme_stylebox_override("hover", hover)
    button.pressed.connect(func(): print("EGG FIRE: botão ", label))
    root.add_child(button)
