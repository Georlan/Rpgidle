# Convenções de animação — CR001 piloto

Estados pretendidos: `idle`, `walk`, `attack`, `hurt`, `skill`. O primeiro lote contém **GIF/APNG de prévia**, com alternância de poses extraídas, e não quadros finalizados.

- Produzir primeiro uma forma base em pixel grid consistente.
- Definir o pivô do sprite próximo ao contato dos pés no solo e preservar entre quadros.
- Guardar `source` e `preview` separados.
- Não assumir que tamanho de imagem recortada é tamanho oficial do jogo.
- Validar ritmo no desktop em FPS reduzido e testar com zoom inteiro.
- Testar transparência e fundo claro/escuro; evitar halos.
- Reutilizar FX e lógica de ataque quando fizer sentido, sem padronizar poses de espécies diferentes.
- Preferir animações curtas para preservar CPU e bateria.

**Pendente:** resolução lógica final por grau, FPS por ação, hit timings, sprite atlas exportado para Godot e orçamento de renderização.

## Produção nativa — etapa de movimento v0.2

- O componente `game/scripts/creature_motion.gd` permite inspecionar `idle`, `walk`, `attack`, `hurt` e `skill` no laboratório Godot. **Atualmente usa transformações sutis de uma única imagem CR001**, e não quadros finais de animação.
- As outras criaturas permanecem estáticas por serem silhuetas conceituais.
- A janela compacta mantém os três pets visíveis e um botão para retornar à interface expandida.
- Os `Tween`s são vinculados ao nó e cancelados ao trocar de estado. Quando o componente é removido, a animação deixa de ser processada.
- A opção de reduzir movimento pausa os proxies; os efeitos não correspondem a dano, combate ou ganho real.
- Fonte da API de Tween: https://docs.godotengine.org/en/4.6/classes/class_tween.html
- Próximo gate: substituir os proxies por sprites com quadros desenhados consistentes e validar pivô/atlas na Godot 4.6.1.

## Atlas de poses integrado no Godot — v0.3

Arquivo: `assets/01_creatures/CR001_Lunaro/sprite_sheets/CR001_G1_6poses_64x48.png`. Dimensões totais **384 × 48 px**; **seis células de 64 × 48 px**; 32 cores indexadas com transparência. Ordem: idle, walk, attack_01, attack_02, hurt, skill. Extraído do kit piloto da própria conversa e reduzido por nearest-neighbor. Não é uma animação profissional quadro a quadro nem o atlas master de produção.

Na `game/scripts/creature_motion.gd`, `AnimatedSprite2D` + `SpriteFrames` criam cinco animações a partir dessas poses, com tempos curtos e pequenos Tweens nativos para amenizar a transição. Todas as poses compartilham uma linha de chão no atlas. A paleta e a escala ainda exigem aprovação em monitor.

- `idle`: pose inicial + variação de passada; não simula movimento anatômico completo.
- `walk`: alterna duas poses; ainda precisa de quadros intermediários próprios.
- `attack`: pose inicial → golpe → recuperação → inicial.
- `hurt`: reação → restauração.
- `skill`: pose de habilidade → restauração.

No modo compacto o atlas também é utilizado, sem executar lógicas de combate. **Animar mais quadros não significa automaticamente animação mais suave:** não interpolar sprites pixelados arbitrariamente, pois isso cria borrões e artefatos.

Testes: `python3 scripts/validate_pose_atlas.py` confere integridade PNG/dimensões e o smoke test Godot verifica cada estado de SpriteFrames, desligamento de movimento e retorno à UI.

## Laboratório de sequência automática — v0.5

O componente `CreatureMotion` tem um *autoplay de demonstração*, **sem lógica de combate**:
`idle → walk → idle → attack → idle → skill → idle`, repetindo enquanto a prévia da CR001 estiver visível.

- Estados de curta duração usam pose inicial, ataque ou habilidade já existentes no atlas 64×48; nenhum frame novo foi fabricado.
- O autoplay tem relógio próprio por sprite e para quando o usuário escolhe um movimento manual, desativa movimento, sai da tela ou entra em modo compacto.
- O dock compacto **mantém as criaturas com idle leve**, mas não roda a sequência inteira de demonstração.
- Brumelo/CR002 e Ferru/CR003 usam respiração em cadências diferentes, somente transformação leve de SVGs estáticos — não são ciclos completos.
- O painel de botões agora quebra linha para não transbordar em janelas menores.
- O teste Godot verifica que o autoplay chega até a caminhada, pode ser interrompido por comando manual, é suspenso ao compactar e retomado ao expandir.

**Pendente:** validação visual em monitor real, quadros intermediários desenhados para passos e cauda, verificação de microtravamentos de animação; os números de duração deste protótipo **não** fixam timings futuros de combate.
