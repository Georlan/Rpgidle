# Dungeon idle-first — contrato de prévia v0.9

Esta etapa aprimora **apenas a simulação visual** da dungeon para demonstrar o comportamento idle da equipe de três criaturas. Não há sistema de dano, cartas operacionais, inimigos, drops, progresso persistido ou treinamento real. Nenhum contador de andar de demonstração significa progresso salvo.

## Arquivos e responsabilidades

| Arquivo | Responsabilidade |
|---|---|
| `game/scripts/dungeon_stage.gd` | Estado do ciclo visual, tempo, 1x/2x, pausa, formação, sombras e sinal de volta concluída |
| `game/scripts/main.gd` | Controles da tela, estado de andar de preview, status do ciclo e preservação do modo compacto |
| `game/scripts/creature_motion.gd` | SpriteFrames/Tweens individuais; velocidade sincronizada com a simulação |
| `game/scripts/visual_theme.gd` | Tema Códice existente; sem duplicação de estilo ou temas adicionais |
| `game/tests/input_smoke.gd` | Testes de regressão de input, ciclo, pausa, velocidade, reset e troca de tela |

## Sequência e dados

Uma volta de **8 segundos a 1x** representa `explore → engage → resolve → advance`; a `2x` dura metade desse tempo. Isso é *timing de apresentação*, **não fórmula de batalha**.

- A progress bar representa somente o relógio do ciclo.
- A cada volta visual completa, o contador de andar da prévia aumenta uma unidade automaticamente.
- Pausar congela o relógio e coloca os pets em pose fixa; retomar continua do instante anterior.
- Reiniciar a prévia define o andar para 1 e o relógio para zero, mas preserva a equipe e os graus selecionados.
- Sair da Dungeon ou compactar a janela suspende o processamento do cenário. A pausa voluntária é mantida ao voltar.
- Desativar movimento no laboratório suspende a prévia, sem simular expedição em background.
- A velocidade 2x afeta tanto o relógio quanto o SpriteFrames e Tween dos atores do palco.

## Composição

- Ordem interna dos atores: CR001, CR002, CR003.
- Posição de referência horizontal no palco: CR001=37,5% (à frente), CR002=25,5%, CR003=14,5%, antes do deslocamento de até 28 px.
- Ponto vertical de contato: aproximadamente 80,5% da altura, compensado por offsets mínimos por criatura.
- A sombra é uma elipse muito achatada centrada no pé real do ator, sem duplicar a fórmula de formação.
- FX de ação acompanha Lunaro, não fica solto na porta ao fundo.

## Testar no Linux

```bash
git status --short
git stash push -u -m "Backup local antes do idle-first"
git pull --ff-only origin main
```

Abrir a Godot 4.6.1, apertar F5 e testar Dungeon: ciclo automático, número do andar aumentando, tecla P/ botão Pausar, tecla V/ botão Velocidade, R/ reset de prévia e F1/ compacto.

No CI: `godot --headless --path . --editor --import --quit` e `godot --headless --path . --script res://game/tests/input_smoke.gd`.

**QA ainda necessária**: capturas 1100×660 e 1280×720, legibilidade do avanço, ausência de salto ao retomar, estabilidade de sombra sob a CR001 e custos CPU/GPU durante uma janela compacta aberta junto a outro aplicativo.
