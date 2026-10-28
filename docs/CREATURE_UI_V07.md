# Componentes de criaturas e evolução — v0.7

O bloco de ficha da tela Criaturas usa `PanelContainer`, `VBoxContainer` e `HFlowContainer`, em vez de imagens de interface. As cores e estilos vêm de `game/scripts/visual_theme.gd`.

- A equipe visual e as animações existentes continuam funcionando.
- O nome do indivíduo selecionado recebe destaque ouro; seleção feita pelos controles existentes.
- Quatro atributos sempre aparecem, mas sem números inventados ou letras de status não aprovadas.
- Três espaços de cartas são exibidos como **vazios**, porque efeitos/seleção ainda dependem do design matemático.
- Evoluções exibem **quatro graus** como contêineres sem criaturas, requisitos e ramificações fictícias.
- O grau selecionado aparece com um título diferenciado. Nenhuma forma é realmente desbloqueada.

## Limites e teste
- [ ] Captura Godot 1100×660: ficha e botões sem clipping.
- [ ] Captura Godot 1280×720: cards usam o espaço sem ficarem exageradamente grandes.
- [ ] Verificar rótulos com mouse, Tab, Enter e gamepad.
- [ ] O sprite CR001 segue animando; as demais silhuetas mantêm suas prévias.
- [ ] A mudança de telas não deixa cards duplicados ou invisíveis.

Nenhuma lógica de XP, treinamento, combate, progresso ou monetização foi introduzida.
