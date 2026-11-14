extends Node3D
# EGG FIRE - lobby 3D inspirado diretamente na referência anime japonesa.
const STONE=Color("#77758e")
const STONE2=Color("#aaa0ae")
const WOOD=Color("#6f302d")
const RED=Color("#a52e3d")
const ROOF=Color("#252b49")
const GOLD=Color("#f4bd55")
const PINK=Color("#ff83c8")
const PALE=Color("#ffc1e5")

func _ready():
    _environment()
    _mountains()
    _courtyard()
    _shrine()
    _torii()
    _pagoda()
    _sakura()
    _clouds()
    _lanterns()
    _fence()
    _menu()
    var player=get_node_or_null("Player")
    if player:
        player.position=Vector3(0,0,8.5)
        var body=player.get_node_or_null("BodyMesh")
        if body: body.visible=false

func _mat(c):
    var m=StandardMaterial3D.new()
    m.albedo_color=c
    m.roughness=0.82
    return m

func _box(p,pos,size,color,rot=Vector3.ZERO):
    var mesh=BoxMesh.new()
    mesh.size=size
    var n=MeshInstance3D.new()
    n.mesh=mesh
    n.position=pos
    n.rotation_degrees=rot
    n.material_override=_mat(color)
    p.add_child(n)
    return n

func _cyl(p,pos,r,h,color,rot=Vector3.ZERO):
    var mesh=CylinderMesh.new()
    mesh.top_radius=r
    mesh.bottom_radius=r
    mesh.height=h
    mesh.radial_segments=12
    var n=MeshInstance3D.new()
    n.mesh=mesh
    n.position=pos
    n.rotation_degrees=rot
    n.material_override=_mat(color)
    p.add_child(n)
    return n

func _ball(p,pos,r,color,scale=Vector3.ONE):
    var mesh=SphereMesh.new()
    mesh.radius=r
    mesh.height=r*2
    var n=MeshInstance3D.new()
    n.mesh=mesh
    n.position=pos
    n.scale=scale
    n.material_override=_mat(color)
    p.add_child(n)
    return n

func _environment():
    var w=WorldEnvironment.new()
    var e=Environment.new()
    e.background_mode=Environment.BG_SKY
    var sky=Sky.new()
    var sm=ProceduralSkyMaterial.new()
    sm.sky_top_color=Color("#0869e8")
    sm.sky_horizon_color=Color("#b8dcff")
    sm.ground_bottom_color=Color("#4d617e")
    sm.ground_horizon_color=Color("#b8d8f4")
    sky.sky_material=sm
    e.sky=sky
    e.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
    e.ambient_light_color=Color("#d2ddff")
    e.ambient_light_energy=0.8
    e.tonemap_mode=Environment.TONE_MAPPER_FILMIC
    e.glow_enabled=true
    e.glow_intensity=0.35
    w.environment=e
    add_child(w)
    var sun=DirectionalLight3D.new()
    sun.rotation_degrees=Vector3(-48,-28,0)
    sun.light_color=Color("#ffe2d2")
    sun.light_energy=1.35
    sun.shadow_enabled=true
    add_child(sun)

func _mountains():
    for i in range(8):
        var x=-19.0+i*5.4
        var h=7.0+float((i*13)%5)*1.25
        var mesh=PrismMesh.new()
        mesh.size=Vector3(7,h,4)
        var n=MeshInstance3D.new()
        n.mesh=mesh
        n.position=Vector3(x,h*0.48,-22.0-float(i%3)*2)
        n.rotation_degrees.y=45
        n.material_override=_mat(Color("#7893c2") if i%2==0 else Color("#526f9d"))
        add_child(n)
    for i in range(7):
        _ball(self,Vector3(-16+i*5.2,5.4+(i%3),-15.5),1.4,Color("#e7f2ff"),Vector3(1.8,0.45,0.8))

func _courtyard():
    _box(self,Vector3(0,-0.45,-4),Vector3(38,0.9,42),Color("#496f59"))
    _box(self,Vector3(0,0,3.4),Vector3(29,0.22,22),STONE)
    for x in range(-14,15,2):
        for z in range(-7,14,2):
            _box(self,Vector3(x,0.15,z),Vector3(1.92,0.09,1.92),STONE2 if (x*3+z)%5==0 else STONE)
    for i in range(24):
        _ball(self,Vector3(randf_range(-13,13),0.23,randf_range(-6,12)),0.07,PINK,Vector3(1.8,0.18,0.8))

func _shrine():
    var x=-8.4
    _box(self,Vector3(x,0.32,-3.8),Vector3(7,0.55,5.6),STONE2)
    _box(self,Vector3(x,1.55,-5),Vector3(6,2.7,3.5),WOOD)
    _box(self,Vector3(x,1.6,-3.18),Vector3(4.5,2.35,0.16),Color("#3b293d"))
    _box(self,Vector3(x,1.15,-3.06),Vector3(1.25,1.8,0.18),GOLD)
    for side in [-1.0,1.0]:
        _box(self,Vector3(x+side*2.75,1.55,-2.95),Vector3(0.3,2.9,0.34),RED)
        _box(self,Vector3(x+side*3.15,1.7,-4.9),Vector3(0.28,3,0.32),RED)
        _box(self,Vector3(x+side*3.65,2.95,-4.9),Vector3(0.22,0.75,0.22),RED,Vector3(0,0,-side*22))
    _box(self,Vector3(x,3,-4.9),Vector3(8.4,0.28,5.8),ROOF,Vector3(0,0,-2))
    _box(self,Vector3(x,3.2,-4.9),Vector3(7.5,0.18,5.1),RED)
    _box(self,Vector3(x,3.38,-4.9),Vector3(6.4,0.16,4.4),ROOF)
    for i in range(4):
        _box(self,Vector3(x,0.32+i*0.18,-1.9+i*0.48),Vector3(4.6-i*0.25,0.22,0.9),STONE2)

func _torii():
    var x=8.0
    for side in [-1.0,1.0]:
        _box(self,Vector3(x+side*2.55,2.15,-1.7),Vector3(0.52,4.3,0.62),RED)
        _box(self,Vector3(x+side*2.55,0.22,-1.7),Vector3(0.95,0.44,1),ROOF)
        _box(self,Vector3(x+side*2.55,4.25,-1.7),Vector3(0.8,0.18,0.85),GOLD)
    _box(self,Vector3(x,4.35,-1.7),Vector3(7.2,0.55,0.82),RED)
    _box(self,Vector3(x,4.72,-1.7),Vector3(7.8,0.24,1),ROOF)
    _box(self,Vector3(x,3.42,-1.7),Vector3(5.3,0.28,0.58),RED)

func _pagoda():
    var b=Vector3(0,0,-17)
    _box(self,b+Vector3(0,0.45,0),Vector3(4.5,0.9,4.5),STONE2)
    for i in range(4):
        var y=1.25+i*1.48
        var width=4.2-i*0.62
        _box(self,b+Vector3(0,y,0),Vector3(width*0.62,1.12,width*0.62),RED)
        _box(self,b+Vector3(0,y+0.48,width*0.32),Vector3(width*0.36,0.55,0.08),Color("#342b46"))
        _box(self,b+Vector3(0,y+0.65,0),Vector3(width+0.9,0.2,width+0.9),ROOF)
        _box(self,b+Vector3(0,y+0.79,0),Vector3(width+0.35,0.12,width+0.35),GOLD)
        _box(self,b+Vector3(0,y+0.91,0),Vector3(width*0.78,0.12,width*0.78),ROOF)
    _cyl(self,b+Vector3(0,7.7,0),0.11,1.9,GOLD)

func _sakura():
    var spots=[Vector3(-13,0,-6),Vector3(-13,0,3),Vector3(13,0,-7),Vector3(14,0,4)]
    for p in spots:
        _cyl(self,p+Vector3(0,2.35,0),0.3,4.7,Color("#49303b"),Vector3(0,0,-5))
        for j in range(4):
            var side=-1.0 if j%2==0 else 1.0
            _cyl(self,p+Vector3(side*(0.8+j%2),3.3+(j%3)*0.3,0),0.13,2.6,Color("#49303b"),Vector3(0,0,side*-38))
        for i in range(13):
            var a=float(i)*TAU/13
            _ball(self,p+Vector3(cos(a)*2,3.7+sin(a*2)*0.55,sin(a)*1.45),1.28,PINK if i%3!=0 else PALE,Vector3(1.25,0.72,0.95))
        for j in range(18):
            _ball(self,p+Vector3(randf_range(-3,3),randf_range(2.2,5.2),randf_range(-2,2)),0.09,PALE,Vector3(1.7,0.22,0.8))

func _clouds():
    for i in range(6):
        var x=-18.0+i*7
        for j in range(4):
            _ball(self,Vector3(x+j*0.9,7.0+(i%2)*1.2+sin(float(j))*0.35,-13.0-(i%3)*2),0.8,Color("#e8f3ff"),Vector3(1.5,0.55,0.9))

func _lanterns():
    for p in [Vector3(-4.8,2.2,-1.8),Vector3(4.8,2.2,-1.8),Vector3(-11.2,2.3,-1.5),Vector3(11.2,2.3,-1.5)]:
        _cyl(self,p+Vector3(0,0.62,0),0.045,0.55,ROOF)
        _box(self,p,Vector3(0.78,0.92,0.78),GOLD)
        _box(self,p+Vector3(0,0.52,0),Vector3(0.96,0.12,0.96),ROOF)
        _box(self,p+Vector3(0,-0.52,0),Vector3(0.96,0.12,0.96),RED)
        var light=OmniLight3D.new()
        light.position=p
        light.light_color=Color("#ffad50")
        light.light_energy=0.75
        light.omni_range=4.5
        add_child(light)

func _fence():
    for x in range(-11,12,2):
        _box(self,Vector3(x,0.82,-8.4),Vector3(0.22,1.64,0.28),RED)
        _box(self,Vector3(x,1.55,-8.4),Vector3(0.38,0.18,0.4),GOLD)
    _box(self,Vector3(0,1.32,-8.4),Vector3(23,0.22,0.36),RED)
    _box(self,Vector3(0,0.55,-8.4),Vector3(23,0.2,0.36),WOOD)

func _menu():
    var layer=CanvasLayer.new()
    add_child(layer)
    var ui=Control.new()
    ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(ui)
    _button(ui,"PERFIL",Vector2(28,22),Vector2(112,72),Color("#0875ed"))
    _button(ui,"LOJA",Vector2(150,22),Vector2(112,72),Color("#f3a51d"))
    _button(ui,"PERSONAGENS",Vector2(28,-94),Vector2(245,72),Color("#0875ed"),true)
    _button(ui,"▶  COMEÇAR",Vector2(-270,-94),Vector2(242,72),Color("#f3a51d"),false,true)

func _button(parent,label,pos,size,color,bottom=false,right=false):
    var b=Button.new()
    b.text=label
    b.add_theme_font_size_override("font_size",22)
    b.add_theme_color_override("font_color",Color.WHITE)
    b.add_theme_color_override("font_outline_color",Color("#20243a"))
    b.add_theme_constant_override("outline_size",4)
    b.custom_minimum_size=size
    b.position=pos
    if bottom:
        b.anchor_top=1.0
        b.anchor_bottom=1.0
    if right:
        b.anchor_left=1.0
        b.anchor_right=1.0
    var style=StyleBoxFlat.new()
    style.bg_color=color
    style.border_color=Color("#17213c")
    style.set_border_width_all(3)
    style.set_corner_radius_all(15)
    style.shadow_color=Color(0,0,0,0.38)
    style.shadow_size=5
    b.add_theme_stylebox_override("normal",style)
    var hover=style.duplicate()
    hover.bg_color=color.lightened(0.16)
    b.add_theme_stylebox_override("hover",hover)
    b.pressed.connect(func(): print("EGG FIRE menu: ",label))
    parent.add_child(b)
