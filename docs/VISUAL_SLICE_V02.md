# Visual vertical slice — v0.2

> **Objetivo:** validar aparência, hierarquia e interações antes de expandir o bestiário ou programar combate. Tudo que apresentar poderes, patentes ou progressão deve ser rotulado como **exemplo de UI**, não fórmula aprovada.

## Ordem de produção aprovada para esta iteração

1. **Contrato visual:** dimensão do sprite, IDs, paleta, transparência, nomenclatura e manifesto.
2. **Telas de navegação:** dungeon, criaturas, evolução, rancho, treinador/Sistema e arena — com estados demonstrativos e sem servidor.
3. **Três silhuetas iniciais:** CR001 (piloto existente), CR002 (anfíbio/musgo), CR003 (besouro/armadura).
4. **Evolução ramificada:** montar grafo da CR001 com quatro graus como conteúdo ilustrativo. Requisitos e números permanecem não aprovados.
5. **Animação e FX:** manter GIF idle experimental da CR001; adicionar elementos vetoriais editáveis (corte, escudo, despertar). Não fingir ciclos completos sem arte frame-a-frame.
6. **Teste de usabilidade:** validar clique, foco de teclado, telas pequenas, leitura do desktop compacto e redução de movimento.

## Decisões de produção

- **Apenas CR001 tem sprite extraído e preview de idle**; os outros dois são **silhuetas vetoriais de pixel art geradas por código**, com intenção de substituir por sprites curados.
- As telas funcionam como **protótipo HTML local**, não substituem o projeto Godot para publicação na Steam.
- Não inserir battle RNG, matchmaking, progressão real, moedas, preços ou fatos fictícios do jogador.
- As cartas do treinador são **uma por equipe**, originadas de comportamento relevante, e não vendidas.
- Em arte comercial: formas superiores partem de base maior, mas precisamos provar que formas anteriores ainda têm utilidade; não aprovar números por screenshot.

## Próximo gate

1. Avaliar as três silhuetas a 1× e 3×; rejeitar se pouco distinguíveis.
2. Refinar animações CR001 sem hopping/morph arbitrário.
3. Aprovar UI navegável antes de abrir mais linhagens.
4. Só então introduzir catálogo de técnicas e testes de combate com matemática formal.

