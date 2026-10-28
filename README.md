# RPG Idle de Criaturas

Jogo independente em pré-produção para **Steam (PC)**, com foco em dungeon infinita idle, evolução ramificada de criaturas, cartas automáticas e Cartas de Assinatura que refletem o estilo do treinador.

> **Status:** organização inicial de design e direção visual. Ainda não há build jogável. O nome comercial não foi escolhido.

## Visão

- Equipe de **3 criaturas**; dungeon PvE é o centro e pode ser reiniciada voluntariamente sem reiniciar os monstros.
- Cada criatura treina **Força, Velocidade, Resistência e Inteligência** e pode desbloquear individualmente formas intercambiáveis em **4 graus**.
- Cada criatura usa **3 técnicas automáticas**; o treinador possui **1 Carta de Assinatura ativa** para a equipe.
- O **Potencial existe apenas no treinador**. O Sistema interpreta decisões relevantes e feitos da dungeon para despertar e refinar cartas pessoais.
- O rancho mantém registro permanente de **formas distintas**; o PvP terá limites competitivos.
- Plano comercial: **jogo pago com cosméticos opcionais**, sem venda de vantagem competitiva.

## Organização

- `docs/` — decisões, regras aprovadas, pendências matemáticas, produção visual e roadmap.
- `assets/` — conceitos, criaturas, cartas, efeitos, UI e cenários, com status explícito de produção.
- `game/` — reservado ao projeto Godot quando a implementação começar.

A direção artística é **pixel art 2D de fantasia arcana**. Não confundir imagens conceituais, extrações e GIFs de teste com assets finais prontos para o jogo.

## Protótipo visual navegável (v0.2)

Há um [protótipo de seis telas](prototypes/visual-slice-v02/README.md) para comparar dungeon, criaturas, evoluções, rancho, Sistema e arena antes de iniciar o projeto Godot. Rodar na raiz:

```bash
python3 -m http.server 8000
```

Depois abrir `http://localhost:8000/prototypes/visual-slice-v02/`. Os dados de batalha e status são **demonstrativos**.

## Laboratório nativo Godot — controles

O projeto `project.godot` fica na raiz e já abre um laboratório de interface em [Godot 4.6.1](game/README.md), com seis telas navegáveis, controles de mouse/teclado/gamepad, foco protegido fora da janela e modo compacto experimental. Nenhum combate, economia ou PvP foi implementado.

- [Contrato e testes de controle](docs/CONTROLS_TEST_PLAN.md)
- [Plano Steam Direct, demo, Playtest e release](docs/STEAM_RELEASE_PLAN.md)

## Referências e skill de produção

- [Pesquisa cruzada de skills, jogos, licenças e oportunidades](docs/REFERENCE_RESEARCH.md)
- [Skill local para agentes de código e arte](.agents/skills/rpgidle-production/SKILL.md)
- [Próxima sequência de produção e critérios de aceite](docs/PRODUCTION_PRIORITY.md)

Agentes devem começar por [AGENTS.md](AGENTS.md). Skills públicas são referências opcionais: a Godot do projeto continua em **4.6.1**, e **nenhum plugin externo foi instalado** nesta etapa.

## Próxima etapa

Fechar especificação de produção, organizar os primeiros assets do piloto **CR001** e validar uma animação consistente antes de expandir o bestiário. Não criar sistemas adicionais até a matemática de treinamento, evolução, dungeon e PvP estar definida.

**Nota:** os nomes apresentados nas pranchas conceituais são provisórios. O conteúdo é de pré-produção e não constitui uma licença pública de reutilização das artes.
