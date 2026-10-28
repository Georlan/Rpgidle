# Arte G1 de Brumelo e Ferru — Estudos v0.10

Dois atlas **originais e específicos do Rpgidle**, desenhados com primitivas de pixel art e exportados em PNG RGBA, complementam o atlas já existente de Lunaro (CR001).

| Item | Brumelo CR002 | Ferru CR003 |
|---|---|---|
| Linguagem | anfíbio de bosque com coroa de musgo | criatura de armadura oxidada e núcleo de jade |
| Silhueta | larga e baixa, duas orelhas assimétricas | hexágono/escudo, antena e braços laterais |
| Material | musgo, barriga suave, olhos âmbar | metal e pedra, gravações ouro e núcleo ciano |
| Grade | 6 × (64 × 48), 384 × 48 RGBA | 6 × (64 × 48), 384 × 48 RGBA |
| Poses | idle, passada, preparação, ação, dano, habilidade | idle, passada, preparação, ação, dano, habilidade |
| Status | animation_preview / in review | animation_preview / in review |

## Integração

`CreatureMotion` recebe ID estável, escolhe um atlas por espécie e usa `AnimatedSprite2D` + `SpriteFrames`. Todos compartilham o mesmo contrato de estados (`idle/walk/attack/hurt/skill`) e filtro nearest.

Os desenhos originais em SVG foram preservados como referências, sem sobrescrever arquivos anteriores. A cena Dungeon reutiliza os mesmos sprites, com **movimentos ilustrativos** durante o ciclo idle. Não existem técnicas, dano, energia ou atributos novos.

## Restrições de arte

- Os quadros 2–3 representam apenas um esboço de ataque; **não** são animações finalizadas.
- A integração dos três personagens em um cenário real precisa de avaliação de tamanho 1x/2x e sombras de contato.
- Não usar a aparência atual para definir automaticamente uma família evolutiva nem aprovar cores oficiais antes de comparação.
- Os PNGs foram gerados por desenho programático autoral, não cópia de outras franquias.
- FPS e duração são parâmetros de preview, não de combate.

## Testes

Validador Python sem dependências externas: PNG chunks/CRC, zlib, dimensões, transparência, quadros distintos, baseline e SHA256 de novas fontes. Smoke test Godot 4.6.1: carregamento, 5 estados, pausa e retorno ao idle.

**Próximo passe de arte:** revisar coerência das três silhuetas e desenhar quadros intermediários de caminhada, sem multiplicar espécies.
