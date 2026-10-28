# CR001 — criatura piloto

**Nome provisório:** Lunaro. **Status:** arte conceitual, não asset final aprovado. A identidade e as formas podem mudar.

Estrutura planejada (compatível com o kit visual v0.1):

- `concept_forms/`: quatro graus de conceito.
- `animation_source/`: poses extraídas para estudo.
- `sprite_sheets/`: folhas de poses, não animações finais.
- `animations/`: GIFs/APNGs demonstrativos de idle, walk, attack, hurt e skill.

O registro do rancho contabilizará **formas distintas**, mas cada indivíduo só poderá utilizar formas que ele próprio desbloqueou. As artes de Grau I–IV neste piloto não são a árvore de evolução final.

Para integração futura: limpar sprite, padronizar grid/pivot, desenhar inbetweens reais e validar loop no Godot.

## Preview de animação nativa (v0.3)
- `sprite_sheets/CR001_G1_6poses_64x48.png`: atlas indexado, 6 poses diferentes, fundo transparente.
- `game/scripts/creature_motion.gd`: SpriteFrames nativos e Tweens leves; usado nas telas de Criaturas e faixa desktop.
- O sprite anterior de conceito e o GIF original são preservados como referências, mas não são mais a única fonte de movimento.
- Ainda **não finalizado**: inbetweens reais, ajuste de silhueta, sprites HD, FX e timing de combate.
