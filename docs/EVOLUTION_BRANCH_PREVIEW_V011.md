# Prévia de evolução ramificada e Bestiário — Godot v0.11

A tela **Evoluções** mostra caminhos múltiplos em **4 graus**, com conexão entre formas; não existe uma sequência obrigatória G1→G2→G3→G4 única. Como nos sistemas de evolução condicional de criaturas, mais de um caminho pode chegar à mesma forma e uma forma pode permitir destinos distintos. Não são personagens de outras franquias nem uma reprodução de interface existente.

## Separações obrigatórias
- **Bestiário no Rancho:** catálogo global de espécies e formas conhecidas pelo jogo, sem simular descoberta do jogador; não substitui o registro pessoal.
- **Prévia evolutiva:** arquivo `assets/metadata/evolution_preview.json` com caminhos *candidatos* e rótulos provisórios. Não define desbloqueio, progressão ou vantagem entre graus.
- **Criatura individual (futuro):** suas formas liberadas são intercambiáveis fora de combate, porém exclusivas desse indivíduo.
- **Registro permanente no rancho (futuro):** contabiliza a primeira descoberta de formas distintas; registro não concede automaticamente a forma a outras criaturas.

## Arte
As pranchas de Brumelo/Ferru geradas no chat em 28/10/2026 inspiram prévias estáticas G2 e G3; qualquer retrato recortado é **concept_crop** de fundo incluso, não PNG transparente, não sprite jogável e não evolução definitiva. G1 utiliza as artes jogáveis existentes. Graus/caminhos sem concept art mostram **Sem arte**, sem inventar sprites G4.

## Navegação
Tela 3: alternar espécie, clicar/selecionar um nó G1–G4 e inspecionar a ficha do candidato; conexões são apenas visuais. Tela 4: consultar espécies do catálogo. A Dungeon não muda forma nem usa candidatos. Não existe botão desbloquear ou evoluir, nem salvamento do grafo.

## Futuro
Estabelecer requisitos reais por jogo/feito, validação por indivíduo e save versionado só depois das decisões matemáticas. Evitar tratamento de formas do mesmo grau como equivalentes em combate por padrão.
