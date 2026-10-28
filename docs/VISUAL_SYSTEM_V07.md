# Sistema visual Códice — UI v0.7

A interface é um sistema reutilizável na Godot, não um conjunto de imagens de telas. Fonte principal: `game/scripts/visual_theme.gd`.

## Identidade

- Base escura e sólida; leitura de janela desktop contínua em segundo plano.
- Texto principal **marfim** `#ECE3D2`; texto secundário **jade-claro** `#A9C0BB`.
- Chamada de ação pontual em **ouro** `#C69D66`; seleção e foco em **jade** `#6AAE9F`.
- Delimitação suave em `#395259`, sem excesso de painéis aninhados ou glow genérico.
- Ícones são símbolos discretos, não substituem rótulos. Não inserir microcopy decorativa.

## Componentes já implementados

| Elemento | Uso | Regra |
|---|---|---|
| Painel | Conteúdo de detalhe | Fundo quase preto, borda sutil e raio 10 |
| Botão secundário | Navegação contextual | Fundo profundo, contorno, contraste alto |
| Botão primário | Ação principal da tela | Ouro com tinta escura, apenas um destacado |
| Aba | Navegação entre 6 telas | Ativo jade e texto marfim |
| Foco | Acessibilidade teclado/gamepad | Linha jade 2 px, nunca apenas mudança de cor |
| Capa de carta | Sistema/Treinador | SVG existente e texto real sobre componente, nunca texto rasterizado na arte |

## Hierarquia

1. Nome da tela (1 linha).
2. Estado/objetivo mínimo (1–2 linhas).
3. Área visual principal ou carta.
4. Ação relevante.
5. Ajuda de controles discreta.

Na Dungeon, a arte deve predominar. Em Criaturas, a personagem é herói; atributos e slots substituem a área livre **quando gameplay real existir**. Não fingir valores em UI ilustrativa.

## Teste visual

- [ ] 1100×660 e 1280×720 sem corte de botão/texto.
- [ ] Botões por mouse, tab e gamepad; foco visível.
- [ ] Usar F1 para checar modo desktop sem barra de gameplay indevida.
- [ ] A tela Sistema mostra carta sem clipping e sem alterar Potencial real.
- [ ] Conferir contrastes e leitura em monitor com brilho reduzido.
- [ ] Validar captura real Godot antes de marcar o layout como arte final.

Nenhuma fonte paga ou de terceiros foi incorporada. O nome do jogo e a tipografia de marca ainda são provisórios.
