# Relação e conexão das artes — Ruínas do Primeiro Eco

## Situação do pacote
Em 28/10/2026 foram geradas **duas imagens originais por IA**: cenário completo RGB (2098×750) e folha transparente de objetos (1448×1086). Estão versionadas **sem perda** em `source/`, com exports compactos em `exports/`. A proveniência está explícita; não afirmar que a arte foi desenhada manualmente nem que foi aprovada comercialmente.

**Mestre visual** → composição, luz, atmosfera e exemplo de colocação de objetos.

**Atlas mestre de props** → portal, pilares, bandeira, vinha, pedras e piso. É uma *folha irregular de objetos*, não um TileSet em grade. O preto visto em visualizadores é principalmente transparência; não substituir o alpha por preto sólido.

## Relações atuais na Godot
`DungeonStage` usa `exports/ruins_backdrop_448x160.png` como fundo **achatado** por enquanto. Mantemos a cena/ações/sprites existentes, sem inventar gameplay.
- Render: `draw_texture_rect_region` com *aspect-cover*, encaixe na base, textura nearest-neighbor e recorte apenas quando a proporção da janela exigir. Não esticar o pixel art em eixos diferentes.
- Personagens: continuam como `CreatureMotion`, CR001–CR003 à frente; baseline normalizado 0,82, sombras de contato.
- FX: somente animação indicativa no portal; não implementa teleportar, combate ou loot.
- Códice: UI permanece fora da arte, com texto verdadeiro em controles da Godot.

## Evolução para modularidade sem duplicações
Primeiro, separar do atlas o portal, pilares, bandeira, piso, pedras e cipós em PNGs transparentes com padding limpo e pivôs. O arquivo `art_map.json` guarda regiões candidatas para revisão; **não considerar os retângulos manualmente aprovados**.

Depois substituir o fundo achatado por planos de parede distantes, arcos/pilares médios, piso modular e props. Quando o portal for uma instância própria, **remover a imagem dele do plano de fundo**, evitando dois portais sobrepostos. A cena pode então variar mantendo o mesmo vocabulário visual.

Os planos de parallax sugeridos são 0,15 / 0,45 / 0,80 / 1,0 (distante → chão), mas **ainda não estão implementados**. O contrato define ordem e relacionamento, não regras de dungeon.

## Consistência com os pets
O cenário de IA tem uma densidade de detalhe maior que Lunaro (sprite de 64×48 com seis poses), e CR002/CR003 ainda são silhuetas. O export 16 cores ajuda a limitar ruído, mas **não resolve sozinho a diferença de artista**. Próximo gate estético: comparar os três em tamanho jogável e redesenhar bordas, sombras e materiais até compartilharem grid e direção de luz.

Não aumentar o bestiário nem produzir evoluções finais antes desta revisão.

## Contrato de produção
- Fontes: manter resolução e alpha originais; hashes verificáveis no CI.
- Exports: 448×160 e 384×288, 16 cores/PNG; geráveis por `python3 scripts/prepare_world_art.py` com Pillow instalado somente no ambiente de produção.
- Alpha: arte de props deve conservar transparência; efeitos ou fundos pretos não podem aparecer nas bordas dos objetos.
- QA: Godot 4.6.1 em Linux, 1100×660, 1280×720, janela compacta F1; testar sem movimento e mudança de abas.
- Verificar `art_map.json` como mapa canônico de caminhos, planos, pivôs e regiões candidatas.
- Mudanças de cena precisam passar por importação e smoke test; aprovação visual requer captura real.

Licença e direitos comerciais de outputs gerados por IA devem ser verificados antes do lançamento Steam, além de originalidade/semelhança com IPs.
