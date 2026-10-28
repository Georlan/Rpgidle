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

## Laboratório de animações v0.5

Na tela **Criaturas**, selecione **Lunaro / CR001**. A sequência de demonstração inicia automaticamente (idle → caminhada → idle → ataque → idle → habilidade → idle). Você pode interrompê-la pelos botões de movimento e reativá-la em **Auto: parado**. O botão **Pausar/retomar movimento** suspende a reprodução inclusive ao compactar a janela.

O modo compacto mantém os três pets em idle e só executa a demonstração completa na tela expandida da CR001. Brumelo e Ferru usam atlas de seis poses com respiração por Tween; são estudos de animação, ainda sem entrequadros finais.

**Status:** prévia visual, não animações finais de gameplay.

## Dungeon visual v0.6

Na tela **1 · Dungeon**, observe três criaturas atravessando uma faixa de ruínas com portal, piso e um pequeno efeito de ataque ilustrativo. Use **Próximo andar (simulação)** para disparar a reação; **Reiniciar andar** altera apenas o número de preview.

A cena para ao mudar de tela, ao usar F1 no compacto ou ao reduzir movimento. Isso **não é combate jogável**, apenas composição visual/ritmo.

## Dungeon idle-first — v0.9

A Dungeon agora apresenta uma **simulação visual automática** (exploração → ação → conclusão → avanço) e atualização do andar ilustrativo a cada ciclo. **P** ou o botão principal pausam/retomam; **V** alterna 1x e 2x; **R** reinicia somente a prévia. A equipe e as formas não são reiniciadas. Não há combate real, drops ou treinamento.

Ver [contrato do ciclo](../docs/IDLE_PREVIEW_V09.md) para estados e testes.
