# EGG FIRE — Godot 4

O projeto Android é exportado pelo Godot 4.3.

- Motor: Godot 4.3
- Linguagem da lógica: GDScript
- Lobby: a imagem original do usuário é mantida sem edição.
- Personagem no lobby: imagem original numa placa 3D, verso preto, giro por arraste e respiração suave.
- Arena de protótipo: mapa 3D, câmera em terceira pessoa, joystick/toque, 15 adversários offline e zona segura que diminui.

**Limite atual:** os adversários e o jogador na arena usam cápsulas provisórias. A imagem do lobby não é um modelo 3D volumétrico. Para usar o personagem original como modelo 3D animado durante a partida, é necessário um arquivo GLB/GLTF com malha e rig.

O workflow GitHub Actions copia as imagens originais sem alterá-las, importa o projeto Godot e exporta um APK Android ARM64.
