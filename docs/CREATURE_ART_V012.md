# Rpgidle — CR002/CR003: artes G1 revisadas para Godot (v0.12)

**Status:** animação de prévia, não arte final. Duas imagens geradas por OpenAI em 28/10/2026 foram aprovadas visualmente pelo usuário e convertidas para atlases compactos.

| Criatura | Fonte de conceito original (conversa) | SHA256 original |
|---|---|---|
| Brumelo CR002 | conjunto_de_sprites_do_guardião_musgoso.png, 1448×1086 RGBA | dbe61769b5023d7491967a76c7c68b6b9ad206c8fb4f15ec6e0515d74b66e986 |
| Ferru CR003 | folha_de_sprites_do_golem_cristalino.png, 1448×1086 RGBA | 04a74373e9a48fa4a58512c1524aa9a78e837901efebe21a014d2c71b195af27 |

**Os originais completos permanecem nos anexos da conversa**, sem perdas ou alterações. Os exports leves foram versionados no repositório, e os atlas 64×48 anteriores continuam disponíveis para reversão.

## Pipeline de integração

- Folha original 3 colunas × 2 linhas; 6 poses de origem.
- Recorte do corpo com janela constante por estado; efeitos grandes ficam parcialmente recortados, pois no futuro serão FX independentes.
- Resolução de cada pose: **96×80**, atlas horizontal **576×80**. Paleta limitada a 63 cores, PNG indexado com pixels totalmente transparentes, sem dither.
- Posições: 0 idle, 1 walk, 2 idle_alternate, 3 attack, 4 hurt, 5 skill.
- Os três primeiros quadros alternam no idle/walk; os demais ficam sob controle dos estados do Godot.
- A seleção do grid é **por ID**: CR001 permanece 64×48; CR002/CR003 usam 96×80 com o mesmo pivô do pé no `creature_motion.gd`.
- O bestiário usa os novos caminhos G1, mas evoluções candidatas G2/G3/G4, ranch, cartas e matemática não mudam.

## Validação e limites

- [x] Imagens com seis poses distintas, CRC e transparência real.
- [x] Validação automatizada dos hashes dos exports.
- [ ] Aprovação estética em Godot 4.6.1 na Dungeon, Criaturas e dock compacto.
- [ ] Verificar tremores entre quadros (principalmente ataque/hurt).
- [ ] Refazer manualmente quadros intermediários e limpar os efeitos fundidos às poses.
- [ ] Separar efeitos das artes e rever escala relativa à Lunaro.

Não interpretar mudança visual como unlock de evolução ou bônus de raridade; nenhuma mecânica nova foi incluída.
