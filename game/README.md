# Protótipo nativo Godot — controles e interface (pré-produção)

A raiz do repositório contém `project.godot`, abrível pela **Godot 4.6.1** (GDScript, sem C#). Este laboratório **não é o jogo nem uma build de Steam**: serve para verificar interface, foco e mapeamento antes de implementar combate/dungeon.

## Iniciar

1. Instalar Godot 4.6.1 Standard (Windows/Linux).
2. Abrir a **raiz do repositório** no Project Manager da Godot.
3. Executar `F6` na cena `game/scenes/main.tscn` ou `F5` no projeto.
4. Testar `Q/E`, `1–6`, `F1`, `R`, Tab/Enter e gamepad, conforme [Contrato](../../docs/CONTROLS_TEST_PLAN.md).

O jogo usa os PNG/SVG conceituais versionados em `assets/`. Ainda não há sistema de salvar, dano, economia, servidor, assinatura real ou sobreposição transparente click-through.

## CI

Um teste automatizado de importação + smoke test em runtime foi incluído para detectar erros de cena/script/input. Validar manualmente no Windows e com controle físico continua obrigatório.

## Próximo gate

Separar o loop visual mínimo, revisão das animações CR001 e interação entre evolução/treinamento somente depois de aprovar os cálculos de combate e as regras de progressão. Não aumentar o escopo para Steamworks SDK antes de uma build jogável confiável.

## Prévia do modo desktop e dos movimentos CR001

No laboratório nativo, `F1` abre uma faixa compacta com os três pets ainda visíveis, status de andar e botão **Expandir**, sem precisar adivinhar atalhos para retornar. Esta faixa é **uma janela comum**: transparência, click-through e always-on-top ainda não foram homologados.

Na tela **2 · Criaturas**, selecione a CR001 (Lunaro) e experimente os botões `Idle`, `Caminhar`, `Atacar`, `Dano`, `Habilidade` e `Pausar/retomar movimento`.

**Estes são movimentos programáticos de uma imagem conceitual**, não ciclos de sprite sheets finais. O objetivo é validar ritmo, legibilidade e custo antes da curadoria artística final.
