# Bestiário do Sistema — arquitetura futura (v0.10)

Inspirado no **princípio de descoberta e consulta de um catálogo de criaturas**, não na interface, nomenclatura, personagens ou conteúdo de Pokémon. Esta etapa constrói **somente metadados estáticos**, não uma tela nem progresso de coleção fictício.

## Separar três coisas que parecem iguais, mas não são

1. **Catálogo global (dados do jogo):** espécies e formas que o software conhece. Arquivo `assets/metadata/bestiary_catalog.json`. IDs: `CR001`, `CR002`, `CR003`; forma-base `CR001_G1`. Não diz que o jogador encontrou algo.
2. **Indivíduo (futuro estado do save):** identificador único da criatura do jogador, `species_id`, treinamento persistente e `unlocked_form_ids`. Uma forma descoberta por indivíduo A **não é automaticamente liberada** para indivíduo B.
3. **Registro do rancho (futuro estado permanente do save):** conjunto de `form_id` distintos descobertos por pelo menos um indivíduo. Registrar duplicatas da mesma forma **não aumenta** contagem do rancho. O registro não concede acesso irrestrito às formas de indivíduos diferentes.

Sem implementar essas estruturas de save ainda; são contratos para as fases posteriores. Evitar confundir “total no catálogo”, “formas liberadas por indivíduo” e “formas descobertas globalmente”.

## Visibilidade futura do bestiário

Sugestão de UX para avaliação posterior, não implementação aprovada:
- Não vista: silhueta e identificação limitada, sem revelar condições secretas.
- Vista: identidade visual básica, data/região de observação quando esses dados existirem.
- Registrada no rancho: forma e grau conhecidos, com detalhes suficientes para comparação.
- Desbloqueada no indivíduo ativo: ação para alternar forma **fora do combate**.

Nunca usar estes estados como sistema paralelo de XP, gacha, poder comprado ou pontuação vertical automática.

## Contratos técnicos

| Campo | Invariante |
|---|---|
| `species_id` | estável por espécie, não por monstro capturado |
| `form_id` | estável por forma e ramo, não por usuário |
| `grade` | inteiro 1–4 |
| `branch_key` | somente `base` atualmente; futuros ramos exigem aprovação |
| `asset` | caminho de arquivo real do repo; pode ser arte em revisão |
| `name_status/art_status` | não confundir conceitos com conteúdo final |

Apenas G1 está cadastrado neste momento. **Não foram inventadas evoluções G2/G3/G4, requisitos, chances ou atributos**.

## Integração com Godot

`game/scripts/bestiary_catalog.gd` consulta o JSON por espécie e forma. É estritamente **read-only**. O futuro Códice/Bestiário pode consumir esse catálogo, enquanto uma camada separada consulta o save individual e registro do rancho. Não armazenar progresso no catálogo.

## Gates de qualidade

- [x] Validar IDs únicos, graus, caminhos reais e ausência de campos de jogador.
- [x] Testar carregamento da metadata em Godot headless.
- [ ] Aprovar apresentação visual da tela futura.
- [ ] Definir formato de save e migração com versões.
- [ ] Definir gatilhos de descoberta e progressão do Sistema; sem explorar repetição automática.
