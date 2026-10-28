# Rpgidle — Pesquisa cruzada de referências (28/10/2026)

**Objetivo:** acelerar a criação **sem transformar o jogo em um amontoado de sistemas**. São referências externas, não requisitos de implementação. URLs e licenças devem ser verificadas novamente antes de importar código, assets ou plugins.

## Jogos e aprendizados transferíveis

| Referência | Evidência pública | Aprendizado útil para Rpgidle | O que não copiar / custo oculto |
|---|---|---|---|
| [Whimside](https://store.steampowered.com/app/3064030/Whimside/) | Criaturas na parte inferior do desktop, captura, cruzamento e decoração. | Presença discreta, ritual de olhar o pet, multitarefa, legibilidade em janela reduzida. | Criaturas, UI, paleta, reprodução ou coleções específicas. |
| [Rusty's Retirement](https://store.steampowered.com/app/2666510/Rustys_Retirement/) | Farming idle na parte inferior da tela. | Baixa interferência, ações e progresso compreensíveis em poucos segundos. | Fazendas, robôs, máquinas, identidade visual e complexidade de automação. |
| [Monster Sanctuary](https://monster-sanctuary.com/) | Sinergias de equipes e combate com três monstros; árvore de skills e PvP. | Ler funções de três criaturas, composição e contrajogo, informação clara no combate. | Árvores enormes, inventário/equipamento paralelo, sistemas e monstros proprietários. |
| [Siralim Ultimate](https://store.steampowered.com/app/1289810/Siralim_Ultimate/) | Dungeons, milhares de criaturas e especializações do personagem que modificam combate. | O treinador ter uma identidade de equipe, aumentar replayabilidade via combinações. | 1200 criaturas, fusão massiva, dezenas de especializações e excesso de interfaces. |
| [Cassette Beasts](https://www.cassettebeasts.com/2022/09/16/show-your-moves/) | Técnicas equipáveis por adesivos/stickers, algumas passivas e condicionais. | Cartas que representam comportamentos, gatilhos e restrições inteligíveis. | Sistema de fusão, personagens, stickers visuais e turnos de AP. |
| [Backpack Battles](https://steamcommunity.com/app/2427700/discussions/0/4363502241742993489/) | PvP contra builds de outros jogadores, de forma assíncrona. | Arena assíncrona, snapshot de composição e replay futuro (somente após PvE validado). | Copiar sua economia, ranking, regras ou UX da mochila. |

## Interseção original que buscamos

**Um treinador é moldado por decisões relevantes em dungeons idle, recebe uma Carta de Assinatura pessoal que afeta sua equipe de 3 e explora evoluções condicionais de criaturas.** Diferenciar-se por *trajetória → assinatura → composição*; não por quantidade de monstros, gacha ou efeitos infinitos.

## Skill pública / framework / ferramenta

| Projeto | Papel | Compatibilidade/licença declarada | Adoção |
|---|---|---|---|
| [awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) | Router e skills Godot, art assets, UI, input, testes, Steam. | MIT; catálogo atual prioriza **Godot 4.7**. | **Ler seletivamente e adaptar para 4.6.1**, não instalar em massa. |
| [Scenario Godot skills](https://github.com/scenario-labs/skills/tree/main/skills/game-engines/godot) | Referências detalhadas de 2D, animação, UI, pipeline, VFX, performance. | Testado pelo projeto em Godot **4.7.2**; verificar termos de cada dependência. | Referência técnica opcional; sem instalar serviço/MCP. |
| [godot-demo-projects](https://github.com/godotengine/godot-demo-projects) | Exemplos executáveis de cenas e sistemas na Godot. | Código/demo MIT conforme README; verificar assets e branch específica. | Estudar padrões e testar exemplos isolados; não puxar o repositório inteiro. |
| [GUT](https://github.com/bitwes/Gut) | Testes GDScript com runner CLI. | MIT; série **9.6.x** é compatível com Godot 4.6. | Opcional após crescer a matemática; hoje smoke tests próprios bastam. |
| [gdUnit4](https://github.com/godot-gdunit-labs/gdUnit4) | Testes unitários/cenas. | MIT; série **6.2.x** declara compatibilidade com Godot 4.6.1. | Alternativa ao GUT, não instalar os dois. |
| [Pixelorama](https://github.com/Orama-Interactive/Pixelorama) | Edição e animação pixel art no Linux. | Software open source; conferir licença do pacote/versionamento escolhido. | Ferramenta de produção externa, não dependência do jogo. |
| [Sprite Fusion Godot](https://github.com/Hugo-Dz/spritefusion-godot) | Plugin de geração de pixel art/animações. | Plugin declara MIT e requer conta no serviço. | Apenas avaliar preço/direitos/qualidade depois; **não instalar agora**. |

**Cuidado:** a licença da ferramenta não equivale automaticamente à licença de todo asset produzido ou fornecido por terceiros. Para art assets gerados por IA, guardar modelo/ferramenta, data, termos aplicáveis, versão de prompt/ref e revisão de originalidade.

## Prioridades derivadas para um projeto comercial pequeno

| Ordem | Experimento | Evidência necessária | Fora de escopo |
|---|---|---|---|
| 1 | Uma CR001 com sprites e idle/walk/attack consistentes | Pivot estável, loops, visual 1x/3x, Godot, custo de produção por forma | Criar muitas espécies |
| 2 | Desktop compacto sem interferir no PC | Teste Linux/Windows, clique/foco, impacto CPU/RAM, alt-tab | Overlay global antes dos testes |
| 3 | Uma composição de 3 criaturas em dungeon | Batalha de regras simples e observável, automação de cartas | PvP online |
| 4 | Primeiro desbloqueio condicionado | Requisito reproduzível e comunicação ao jogador | Árvores gigantes |
| 5 | Um despertar de treinador que espelha decisões | Evidências verificáveis, gatilho/efeito, alternativa e contrajogo | Geração livre de habilidades |
| 6 | Demo Steam e Playtest | Loop validado, arte de loja fiel, build estável e checklists | Monetização precoce |

## Licenciamento e risco operacional

- Jogos comerciais acima: **somente análise de mecânicas, UX e ritmo**; sprites, sons, personagens, nomenclaturas, telas e marcas permanecem propriedade dos titulares.
- Skills em Markdown: inspiração técnica e procedimentos; se copiar conteúdo, manter licença e atribuição aplicáveis. Esta skill `rpgidle-production` é **original e específica do projeto**.
- Projetos MIT podem ser comercialmente úteis, mas precisam preservar avisos e verificar **arquivos e assets externos**.
- Nenhum terceiro foi instalado/adicionado ao repositório nesta etapa.
- Não mudar `project.godot` ou API de produção com receita de Godot 4.7 sem teste no 4.6.1.

## Fontes de verificação

- https://github.com/gamedev-skills/awesome-gamedev-agent-skills
- https://github.com/gamedev-skills/awesome-gamedev-agent-skills/blob/main/router/SKILL.md
- https://github.com/scenario-labs/skills/blob/main/skills/game-engines/godot/README.md
- https://github.com/godotengine/godot-demo-projects
- https://github.com/bitwes/Gut
- https://github.com/godot-gdunit-labs/gdUnit4
- https://github.com/Orama-Interactive/Pixelorama
- https://monster-sanctuary.com/
- https://store.steampowered.com/app/1289810/Siralim_Ultimate/
- https://www.cassettebeasts.com/2022/09/16/show-your-moves/
- https://steamcommunity.com/app/2427700/discussions/0/4363502241742993489/
- https://store.steampowered.com/app/3064030/Whimside/
