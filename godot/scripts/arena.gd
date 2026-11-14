extends Node3D

const BOT_COUNT := 15
var player_scene: PackedScene = preload("res://scenes/player.tscn")
var bot_script: Script = preload("res://scripts/bot.gd")
var safe_zone: MeshInstance3D
var safe_radius := 72.0
var elapsed := 0.0
var player: CharacterBody3D
var status_label: Label

func _ready() -> void:
    _create_environment()
    _create_ground()
    _create_cover()
    _create_safe_zone()
    _create_player()
    _spawn_bots()
    _create_hud()

func _create_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_material := ProceduralSkyMaterial.new()
    sky_material.sky_top_color = Color("#4f9be8")
    sky_material.sky_horizon_color = Color("#c8e5ff")
    sky_material.ground_bottom_color = Color("#536b55")
    sky_material.ground_horizon_color = Color("#b2c5a3")
    sky.sky_material = sky_material
    env.sky = sky
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color("#dce8ff")
    env.ambient_light_energy = 0.8
    world.environment = env
    add_child(world)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48.0, -28.0, 0.0)
    sun.light_energy = 1.25
    sun.shadow_enabled = true
    add_child(sun)

func _create_ground() -> void:
    var body := StaticBody3D.new()
    body.name = "Terrain"
    add_child(body)
    var mesh := PlaneMesh.new()
    mesh.size = Vector2(180.0, 180.0)
    var ground := MeshInstance3D.new()
    ground.mesh = mesh
    var material := StandardMaterial3D.new()
    material.albedo_color = Color("#47734b")
    material.roughness = 1.0
    ground.material_override = material
    body.add_child(ground)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = Vector3(180.0, 0.5, 180.0)
    collision.shape = shape
    collision.position.y = -0.25
    body.add_child(collision)

func _create_cover() -> void:
    randomize()
    for i in range(55):
        var x := randf_range(-78.0, 78.0)
        var z := randf_range(-78.0, 78.0)
        if Vector2(x, z).length() < 12.0:
            continue
        _create_tree(Vector3(x, 0.0, z))
    for i in range(30):
        var rock := MeshInstance3D.new()
        var rock_mesh := SphereMesh.new()
        rock_mesh.radius = randf_range(0.35, 1.1)
        rock_mesh.height = rock_mesh.radius * 1.2
        rock.mesh = rock_mesh
        rock.position = Vector3(randf_range(-80, 80), 0.25, randf_range(-80, 80))
        rock.scale = Vector3(1.4, 0.7, 1.0)
        var rock_material := StandardMaterial3D.new()
        rock_material.albedo_color = Color("#777d79")
        rock.material_override = rock_material
        add_child(rock)

func _create_tree(pos: Vector3) -> void:
    var trunk := MeshInstance3D.new()
    var trunk_mesh := CylinderMesh.new()
    trunk_mesh.top_radius = 0.22
    trunk_mesh.bottom_radius = 0.35
    trunk_mesh.height = 2.8
    trunk.mesh = trunk_mesh
    trunk.position = pos + Vector3(0.0, 1.4, 0.0)
    var bark := StandardMaterial3D.new()
    bark.albedo_color = Color("#59402e")
    trunk.material_override = bark
    add_child(trunk)
    var leaves := MeshInstance3D.new()
    var crown := SphereMesh.new()
    crown.radius = randf_range(1.4, 2.4)
    crown.height = crown.radius * 1.8
    leaves.mesh = crown
    leaves.position = pos + Vector3(0.0, 3.2, 0.0)
    var foliage := StandardMaterial3D.new()
    foliage.albedo_color = [Color("#2c7043"), Color("#397d4a"), Color("#4c8b4e")].pick_random()
    leaves.material_override = foliage
    add_child(leaves)

func _create_safe_zone() -> void:
    safe_zone = MeshInstance3D.new()
    var ring := TorusMesh.new()
    ring.inner_radius = safe_radius - 0.35
    ring.outer_radius = safe_radius
    ring.rings = 8
    ring.ring_segments = 96
    safe_zone.mesh = ring
    safe_zone.position.y = 0.12
    var material := StandardMaterial3D.new()
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.albedo_color = Color(0.1, 0.75, 1.0, 0.65)
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    safe_zone.material_override = material
    add_child(safe_zone)

func _create_player() -> void:
    player = player_scene.instantiate() as CharacterBody3D
    player.position = Vector3(0.0, 1.0, 12.0)
    add_child(player)

func _spawn_bots() -> void:
    for i in range(BOT_COUNT):
        var bot := CharacterBody3D.new()
        bot.set_script(bot_script)
        bot.name = "Adversario_%02d" % (i + 1)
        bot.position = Vector3(randf_range(-58.0, 58.0), 1.0, randf_range(-58.0, 58.0))
        var mesh := MeshInstance3D.new()
        var capsule := CapsuleMesh.new()
        capsule.radius = 0.42
        capsule.height = 1.8
        mesh.mesh = capsule
        mesh.position.y = 0.9
        var material := StandardMaterial3D.new()
        material.albedo_color = Color("#bd4354") if i % 2 == 0 else Color("#3e70b7")
        mesh.material_override = material
        bot.add_child(mesh)
        var collision := CollisionShape3D.new()
        var shape := CapsuleShape3D.new()
        shape.radius = 0.42
        shape.height = 1.8
        collision.shape = shape
        collision.position.y = 0.9
        bot.add_child(collision)
        add_child(bot)

func _create_hud() -> void:
    var layer := CanvasLayer.new()
    layer.layer = 5
    add_child(layer)
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(root)
    status_label = Label.new()
    status_label.position = Vector2(18.0, 14.0)
    status_label.add_theme_font_size_override("font_size", 20)
    status_label.add_theme_color_override("font_color", Color.WHITE)
    root.add_child(status_label)
    var back := Button.new()
    back.text = "SAIR"
    back.position = Vector2(18.0, 58.0)
    back.size = Vector2(100.0, 48.0)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
    root.add_child(back)

func _process(delta: float) -> void:
    elapsed += delta
    safe_radius = maxf(18.0, 72.0 - elapsed * 0.16)
    if safe_zone and safe_zone.mesh is TorusMesh:
        var ring := safe_zone.mesh as TorusMesh
        ring.inner_radius = safe_radius - 0.35
        ring.outer_radius = safe_radius
    if player:
        var outside := Vector2(player.global_position.x, player.global_position.z).length() > safe_radius
        if outside:
            player.take_damage(delta * 4.0)
    var remaining := get_tree().get_nodes_in_group("bots").size()
    status_label.text = "EGG FIRE  |  SOBREVIVENTES: %d  |  ZONA: %dm" % [remaining + 1, int(safe_radius)]
