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
