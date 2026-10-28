# Game Design — estado consolidado (v0.4)

> Este arquivo documenta **decisões de conceito**, não fórmulas nem promessas de conteúdo. Data-base: 2026-10-28.

## Visão

RPG idle de criaturas para Steam, com exploração PvE em dungeon infinita, evolução condicional ramificada e estratégia automática por cartas. O diferencial é o **Sistema do Treinador**, que observa decisões relevantes e concede Cartas de Assinatura derivadas do estilo de jogo.

## Laço principal

1. Organizar **3 criaturas ativas** no rancho, selecionar suas formas e técnicas.
2. Explorar dungeons com combate automático e escolhas pontuais.
3. Receber progresso de treinamento, distribuído pelo jogador entre atributos.
4. Cumprir requisitos individuais de evolução e descobrir novas formas.
5. Registrar formas distintas no rancho e avançar marcos do Potencial do treinador.
6. Despertar/refinar uma Carta de Assinatura; alterar a composição e continuar ou reiniciar a dungeon voluntariamente.

## Criaturas

- **4 atributos de combate:** Força, Velocidade, Resistência e Inteligência.
- **Potencial não é atributo de criatura:** pertence exclusivamente ao treinador.
- Treinamento é **persistente por indivíduo** e **compartilhado entre suas formas**.
- **4 graus evolutivos**; cada forma possui base e especialização próprias.
- Formas desbloqueadas são intercambiáveis **fora de combate**, mas o desbloqueio é **individual**: outro indivíduo da mesma espécie precisa cumprir seus próprios requisitos.
- Grau superior começa com vantagem, mas não garante vencer uma forma inferior bem treinada ou estrategicamente adequada.
- A exibição de status por letras é desejada; escala e conversão **ainda não estão definidas**.

## Técnicas e equipes

- Equipe ativa de **3 criaturas**.
- Cada criatura equipa **3 cartas de técnicas automáticas**. Execução condicionada a prioridades e regras determinísticas; detalhes ainda em estudo.
- O treinador equipa **1 Carta de Assinatura ativa**, com efeito sobre a equipe inteira.

## Dungeon, rancho e PvP

- Dungeon **infinita**, reinício **voluntário**; reiniciar afeta apenas o progresso da dungeon, **não o treinamento, os indivíduos ou suas formas**.
- O rancho possui registro permanente de **formas distintas**, mesmo quando a criatura troca de forma. Duplicatas não aumentam a contagem de formas únicas.
- O registro do rancho participa da progressão do Potencial do treinador; os antigos bônus cumulativos de treinador foram incorporados ao Sistema de Assinatura.
- PvP com normalização competitiva; teto de PvE maior que o limite competitivo da arena.
- Combate competitivo deve premiar composição, técnicas e decisões, não vantagens pagas ou crescimento numérico ilimitado.

## Negócio e produto

- **Steam / PC; jogo pago + cosméticos opcionais**.
- Cosméticos possíveis: variantes das criaturas, visual das assinaturas/cartas, temas do Sistema e do rancho.
- Não vender poder, progressão de treinador ou probabilidades de despertar.
- Prioridade à leveza: modo desktop discreto, animação limitada e interface expandida separada.
- Sem PvP em tempo real na primeira validação; PvP assíncrono é candidato, mas detalhes técnicos permanecem pendentes.

## Fora de escopo por enquanto

Reprodução genética, mercado entre jogadores, guildas, equipamentos paralelos, moedas de prestígio, crafting complexo, gacha pago, status aleatórios injustos e geração livre de cartas por IA.

Ver [Sistema do Treinador](SYSTEM_SIGNATURE.md), [Pendências](OPEN_DECISIONS.md) e [Roteiro](TRACKER.md).
