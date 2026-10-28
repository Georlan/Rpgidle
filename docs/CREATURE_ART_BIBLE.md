# Rpgidle — contrato visual de criaturas

**Referência:** CR001 Lunaro G1, atlas em uso. É uma âncora visual de prévia, não aprovação automática para lançamento. Este contrato orienta a produção e a revisão de todas as espécies e formas; não define mecânicas.

## Produção

- **Linguagem:** pixel art de fantasia artesanal, silhueta legível e clusters de cor deliberados. Priorizar a leitura de Lunaro; retirar ruído antes de acrescentar textura.
- **Grade e exportação:** pixels alinhados à grade, sem suavização por reamostragem; transparência limpa e filtro nearest. A referência atual usa células 64 × 48; os atlas em uso de CR002/CR003 usam 96 × 80. Dimensões diferentes são permitidas quando documentadas, mas não devem determinar o tamanho aparente em cena. Não ampliar imagens e chamar isso de detalhe novo.
- **Pivô e chão:** pivô horizontal no centro da célula e referência vertical nos pés; manter o ponto de contato estável entre poses, salvo movimentos intencionais. Registrar dimensões e baseline por atlas. Conferir também o deslocamento visível dos pés: a caixa transparente sozinha não comprova estabilidade.
- **Luz e sombra:** orientar a luz principal de cima, levemente à esquerda, e manter sua direção em todas as poses. Usar poucos planos de sombra coerentes com a forma; sombra de contato discreta, não um halo que aumente artificialmente a silhueta. Essa direção é uma meta de produção, não uma medição comprovada de todos os sprites atuais.
- **Bordas:** sem contorno externo pesado, contínuo ou preto estilo adesivo. Definir bordas com cores escuras relacionadas ao material e à sombra, alternando intensidade com a luz; separar formas internas apenas quando necessário. Evitar franjas semitransparentes e antialias automático; transições devem ser pixels intencionais.
- **Cor e contraste:** paleta compacta por material, com sombras coloridas e pontos de luz reservados às áreas importantes. Trabalhar no contraste da cena, evitando pretos dominantes, branco estourado e pixels isolados que disputem atenção. A contagem de cores é diagnóstico, não limite de aprovação.
- **Materiais:** pelo em massas e tufos grandes, não fios; planta em folhas legíveis e poucos acentos orgânicos; pedra em planos e fissuras seletivas; metal em planos mais lisos, com brilho pequeno e controlado. O material deve ser reconhecível sem depender de partículas.
- **Proporção e footprint:** preservar a identidade de cada criatura, mas comparar largura, altura e massa percebida em idle na mesma linha de chão e na mesma escala de exibição. A silhueta deve ser reconhecível em 1× e 2×; efeitos de ataque não podem redefinir a escala do corpo.

## Movimento e revisão

- **Idle:** respiração sutil com retorno contínuo; **walk:** apoios e deslocamento claros; **attack:** antecipação, ação e recuperação; **hurt:** reação breve legível; **skill:** pose identificável e efeito contido. Manter identidade, volumes e luz entre quadros. Se houver apenas poses ou Tween, chamá-los de prévia, não de animação final.
- Conferir transparência, limites da célula, pés, recorte, sequência, duração e transição do loop; nenhuma pose deve piscar ou mudar de anatomia involuntariamente. Separar efeitos do corpo quando viável.
- Aprovar lado a lado com Lunaro em Dungeon, Criaturas e compacto, em 1× e 2×, com cenário claro e escuro. Verificar silhueta, materiais, contraste, escala e movimento; screenshot isolado, testes headless ou CI verde não substituem revisão visual em Godot.
- Evoluções herdam luz, tratamento de borda, material e família de formas da G1; complexidade cresce por massas reconhecíveis, não por ruído ou efeitos. Formas candidatas continuam conceitos; requisitos, desbloqueios e mecânicas não são definidos por esta bíblia.

## Diagnóstico da tríade atual

| Critério | Lunaro CR001 | Brumelo CR002 | Ferru CR003 |
| --- | --- | --- | --- |
| Silhueta e proporção | Corpo pequeno, cauda e orelhas identificáveis; leitura leve. | Corpo mais largo com copa e folhas; silhueta fragmentada por pequenos detalhes. | Corpo arredondado e braços largos; grande massa simétrica. |
| Material e detalhe | Pelo em massas claras com acentos quentes; detalhes concentrados. | Planta e pedra com muitos pequenos acentos claros e escuros. | Placas e juntas com brilho forte e muitas divisões internas. |
| Luz, borda e contraste | Predominância clara, sombra azul escura descontínua; borda irregular. | Sombras profundas e contornos mais densos, com luz amarela. | Bordas e juntas escuras mais marcadas, pontos de luz ciano e creme. |
| Peso e leitura | Idle ocupa 34 × 31 pixels em célula 64 × 48. | Idle ocupa 68 × 67 em 96 × 80, incluindo folhas soltas. | Idle ocupa 83 × 66 em 96 × 80. |
| Movimento e efeitos | Seis poses de estudo, algumas com efeitos na própria imagem. | Seis poses ilustradas, ataque e habilidade com folhas/arcos. | Seis poses ilustradas, ataque e habilidade com detritos/raios. |

As caixas são limites de pixels não transparentes do primeiro quadro, não medidas do corpo nem prova de proporção em tela. Os atlas usam transparência binária; isso não garante ausência de antialias desenhado na cor. Em termos visuais, CR002/CR003 pedem redução de ruído, de escuros e de efeitos integrados, preservando planta e pedra/metal; a direção de luz e o acabamento ainda precisam ser unificados com Lunaro. A captura fornecida mostra a Dungeon, mas não comprova leitura em movimento, aba Criaturas ou compacto. As animações atuais permanecem prévias e exigem revisão quadro a quadro em contexto.
