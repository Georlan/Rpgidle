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
