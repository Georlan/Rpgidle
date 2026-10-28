# Contrato de controles — Laboratório Godot (v0.1)

O jogo é **idle e mobile não faz parte do escopo**: o controle principal será mouse/teclado, com gamepad habilitado desde o primeiro protótipo. Isto testa **navegação e experiência de interface**, não ação em tempo real.

| Ação | Teclado | Gamepad | Mouse |
|---|---|---|---|
| Trocar tela anterior | Q | LB | Clique na aba |
| Próxima tela | E | RB | Clique na aba |
| Selecionar / confirmar | Enter / Espaço | A | Clique |
| Voltar do compacto | Esc | B | — |
| Alternar modo compacto | F1 | Start/Menu | — |
| Reiniciar preview de dungeon | R (apenas Dungeon) | Y (apenas Dungeon) | Botão explícito |
| Navegação em widgets | Setas / Tab | D-pad / direcional, via UI nativa Godot | Clique |
| Acesso direto às telas | 1–6 | — | Clique na aba |

**Respeitar o foco:** gamepad deve ser ignorado quando outro programa está em primeiro plano. O modo desktop não pode reagir a comandos destinados a outro jogo. Nunca capturar globalmente teclado/mouse.

**Modo compacto:** agora apenas altera a apresentação e o tamanho da janela; sobreposição transparente, click-through e always-on-top **não estão implementados nem validados**. Não afirmar que este laboratório é o overlay final.

## Teste manual no Windows (obrigatório antes de suporte declarado)

- [ ] Abrir pela Godot 4.6.1, sem erros no debugger ou importação de arte.
- [ ] Mouse: alcançar todas as telas, ações e criaturas.
- [ ] Teclado: Q/E e 1–6 navegam; Enter e Tab operam foco; Esc sai de compacto.
- [ ] Gamepad Xbox/compatível: LB/RB, A, B, Y, Start; D-pad leva o foco até todos os controles importantes.
- [ ] Tirar o foco e trabalhar em outro programa: o controle **não** altera tela/andar de dungeon.
- [ ] Testar desconectar/reconectar controle sem travar a UI.
- [ ] Compactar/expandir 30 vezes, verificar que o botão de retorno continua acessível.
- [ ] Testar 1280×720 e 1920×1080, Windows com scaling 125% e 150%.
- [ ] Rodar durante outro jogo em fullscreen; janela compacta não deve interceptar comandos.
- [ ] Testar com Steam Input ligado e desligado para evitar **duplo evento**.
- [ ] Verificar teclado visual e prompts adequados antes de reivindicar suporte ao Steam Deck.
- [ ] Verificar CPU, memória, FPS e impacto no consumo de bateria em uso prolongado.

## Teste automatizado

```bash
godot --headless --path . --editor --import --quit
godot --headless --path . --script res://game/tests/input_smoke.gd
```

O teste executa no runtime do Godot e verifica o mapeamento básico e o estado do protótipo. **Não equivale a validar um gamepad físico**, Steam Input, Windows ou Steam Deck.

## Pontos de risco

- Controles em modo desktop e fora de foco.
- A perda de foco entre compactar/expandir.
- Repetição de eventos em combinações Steam Input + suporte nativo.
- Detecção de device, desconexão e ícones de botão.
- Legibilidade de ações em telas menores.

**Política:** não ativar tags "Full Controller Support" ou "Steam Deck Verified" sem validação em hardware real e requisitos oficiais atendidos.

Fontes:
- https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
- https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
- https://partner.steamgames.com/doc/features/steam_controller
- https://partner.steamgames.com/doc/steamhardware/compat
