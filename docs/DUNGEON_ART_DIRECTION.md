# Ruínas do Primeiro Eco — cenário v0.7
Arte **original**, criada para Rpgidle e sem arquivos de terceiros. Fundo indexado 448 × 160 (64 cores), PNG otimizado, inspirado na direção geral de fantasia arcana estabelecida no projeto.

## Composição
- Valor tonal concentrado nos pilares e parede posterior; contraste preservado para três sprites do primeiro plano.
- Portal à direita como destino narrativo da exploração, com acentos ouro/jade; não representa inimigo ou objetivo de combate implementado.
- Paredes e vinha em silhueta, luz difusa suave, piso em perspectiva e sombras dos pets.
- O arquivo de produção foi gerado com desenho pixel a pixel de polígonos e linhas em Pillow, com seed determinística, sem material protegido de outro jogo.

## Implementação
`game/scripts/dungeon_stage.gd` desenha a textura com nearest-neighbor e usa sombras no chão, mantendo o FX temporário (sem lógica de dano). A imagem ocupa o palco; a cena segue pausando quando fora de foco da aba, modo compacto ou animações desativadas.

## QA obrigatório
- Verificar escala e suavidade da textura em 1100×660 e 1280×720.
- Verificar criaturas contra o piso em 1x/2x, principalmente patas/baseline de Lunaro.
- Evitar halos ou excesso de brilho no portal.
- Não considerar arte aprovada até screenshot real da Godot e inspeção visual.

Não divulgar o cenário como screenshot de gameplay já implementado.
