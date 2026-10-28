# Protótipo visual navegável — v0.2

**Não é o jogo jogável.** É uma revisão local e responsiva da experiência visual que poderá orientar a construção em Godot.

## Rodar localmente

Na raiz do repositório:

```bash
python3 -m http.server 8000
```

Abrir `http://localhost:8000/prototypes/visual-slice-v02/`.

## Telas e interações demonstrativas

- **Dungeon:** simular mudança de andar e reinício; o estado das criaturas não é alterado.
- **Criaturas:** escolher CR001–CR003 e visualizar quatro atributos e três espaços de técnicas (dados fictícios de UI).
- **Evoluções:** inspecionar uma árvore CR001 de quatro graus, com duas ramificações.
- **Rancho:** ver as três silhuetas e alternar três amostras cosméticas de tema.
- **Treinador:** consultar três famílias de assinatura; a carta é do treinador e afeta a equipe.
- **Arena:** comparar visualmente equipes 3v3 sem matchmaking ou resultados.
- **Desktop:** alternar uma faixa compacta; aperte Esc para expandir.
- **Navegação:** teclas 1 a 6 abrem cada tela.

**Não há** dano, RNG, ganho de atributos, inventário, PvP real, salvamento, compras, desbloqueio efetivo ou servidor. O protótipo não grava dados ou envia telemetria.

## Assets e implementação

- CR001: sprite PNG de conceito do piloto anterior.
- CR002 e CR003: SVGs de silhuetas provisórias feitos em pixel-grid.
- Carta de Assinatura: moldura SVG independente dos textos.
- UI: HTML/CSS editáveis (texto não rasterizado). Reutilizar a composição no Godot apenas após revisão.

## Validação

`python3 scripts/validate_visual_slice.py` checa integridade das referências do catálogo e existência dos arquivos. As capturas de tela e testes de uso continuam necessários antes de chamar a etapa de concluída.
