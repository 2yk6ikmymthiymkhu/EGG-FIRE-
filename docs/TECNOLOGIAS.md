# Tecnologias oficiais do EGG FIRE

## Decisão técnica inicial

O EGG FIRE será desenvolvido como um jogo 3D para Android, priorizando desempenho em celulares e ferramentas gratuitas.

**Engine escolhida para a primeira implementação: Godot 4.**

A escolha é prática para este projeto porque é gratuita, de código aberto, exporta para Android e permite combinar uma linguagem simples para gameplay com C++ nos sistemas que realmente precisarem de alto desempenho.

## Linguagens e funções

| Tecnologia | Uso no EGG FIRE |
|---|---|
| **GDScript** | Gameplay, personagens, câmera em terceira pessoa, controles, interface, inventário, armas, bots e lógica das partidas. |
| **C++** | Módulos nativos de alto desempenho, otimizações e sistemas pesados quando necessário, por meio de GDExtension ou módulos do engine. |
| **Godot Shader Language** | Materiais, água, iluminação estilizada, efeitos de tiro, fumaça, brilho e efeitos visuais. É a linguagem de shaders própria do Godot, com sintaxe semelhante a GLSL. |
| **Java/Kotlin** | Somente integração Android específica, se algum recurso nativo do celular exigir. Não será a linguagem principal do jogo. |

Não vamos adicionar C#, HLSL ou várias linguagens sem necessidade. Isso aumentaria a complexidade sem benefício garantido para a versão Android.

## Configuração gráfica inicial

- Jogo em 3D e câmera em terceira pessoa.
- Renderizador inicial: **Mobile** do Godot 4; testar também Compatibility em aparelhos Android mais limitados.
- Modelos e cenários com níveis de detalhe (LOD).
- Sombras, partículas e pós-processamento ajustáveis por qualidade.
- Controles de toque configuráveis.
- Meta de desempenho: estabilidade e boa taxa de quadros, ajustadas após testes em aparelhos reais.

## Arquitetura planejada

1. game/ — cenas e lógica do jogo.
2. characters/ — personagens, animações e atributos.
3. combat/ — armas, dano, projéteis e colisões.
4. world/ — mapa, zona segura, loot e ambiente.
5. ai/ — bots e comportamento.
6. ui/ — lobby, menus, HUD e inventário.
7. native/ — extensões C++ somente quando justificadas.
8. android/ — configurações e integração de exportação Android.

## Ordem de desenvolvimento

1. Preparar o projeto Godot 4 e a exportação Android.
2. Criar um protótipo 3D com movimentação e câmera em terceira pessoa.
3. Implementar controles de toque.
4. Criar mapa de teste, colisões e zona segura.
5. Implementar armas, vida, inventário e bots.
6. Otimizar e testar em celulares reais.
7. Integrar o lobby aprovado e gerar novas versões APK.

## Estado atual e observação importante

O APK que já foi compilado é apenas um aplicativo Android com WebView para mostrar o lobby. **Ele ainda não contém o motor Godot, o mapa 3D nem uma partida jogável.**

Esta decisão registra a base tecnológica do projeto; ela não significa que a engine ou os sistemas de jogo já estejam implementados. A próxima etapa é criar o projeto Godot e integrá-lo ao fluxo de compilação Android.
