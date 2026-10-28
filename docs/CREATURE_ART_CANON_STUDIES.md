# Estudos G1 alinhados ao cânone — 28/10/2026

CR001 permanece a referência. CR002 e CR003 usam novos estudos de seis poses no runtime; os atlas anteriores de 96×80 e 64×48 foram mantidos. As imagens são prévias geradas, não sprites finais nem animações com entrequadros produzidos manualmente. O acabamento, a borda, a continuidade do movimento e a coesão com Lunaro continuam em revisão.

As pranchas foram geradas com OpenAI a partir dos atlas de Lunaro e da respectiva criatura. As fontes completas estão em `assets/01_creatures/CR002_Brumelo/source/` e `CR003_Ferru/source/`; os exports estão em `sprite_sheets/*canon_study_96x80.png`. O script `scripts/build_canon_pose_studies.py` requer Pillow e usa recortes explícitos, alpha binário, escala nearest-neighbor e pés alinhados na linha 76. Ele não cria entrequadros nem corrige anatomia. Uma revisão adicional deve olhar todas as poses em movimento e em fundos claros e escuros.

| Arquivo | SHA-256 |
| --- | --- |
| CR002 fonte | `ac90e7915da8c7eda5fb004086c984cbc279d1364a0b8dab026963f6ef382f68` |
| CR003 fonte | `5a4195307b51c91578750be596ad481f5626bff3289669efe615a924595c9355` |
| CR002 atlas | `e69159f7733647f3035d05428acf6093ed32d80f0276f9b3014f7fb1b68ff60e` |
| CR003 atlas | `813f471632fa29b48f496037ad05004319a66f62cb860c53bef4ba3364b381ac` |

O projeto usa as mesmas seis posições de atlas: idle, walk, variante de idle, attack, hurt e skill. A renderização de dungeon e de criaturas foi examinada na Godot; o teste automatizado verifica carregamento e presença das seis células. A captura estática não demonstra estabilidade do loop nem constitui aprovação artística final. O modo compacto usa o mesmo componente, mas ainda precisa de inspeção visual em uma janela compacta real e revisão em movimento.
