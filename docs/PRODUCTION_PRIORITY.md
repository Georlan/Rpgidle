# Próxima sequência de produção — otimização

1. **Higienização da CR001**: revisar o PNG e o GIF existentes; criar sprite-base coerente, pivot comum e uma amostra de idle real (não apenas alternância de poses).
2. **Padrão de animação**: declarar grade lógica, duração, anchor, atlas e estados (idle/walk/attack/hurt) em metadados, validar por script e visualmente.
3. **Tela de dungeon mínima**: composição sem painéis vazios, personagens legíveis, progresso e 1 ação contextual.
4. **Combate de uma formação**: sistema determinístico simples após aprovar matemática; registrar eventos para posterior Carta de Assinatura.
5. **Primeiro despertar**: evidências no log de eventos → uma assinatura conhecida → efeito na equipe.
6. **Ampliação**: somente então fazer CR002 e CR003 com a mesma qualidade e custo medido.
7. **Testes comerciais**: desktop leve, demo pequena com gameplay real, página Steam e playtest sob critérios de release.

Adoção de skills:
- Começar com `.agents/skills/rpgidle-production/SKILL.md`, sem dependências.
- Para cada tarefa, consultar no máximo 1–2 skills públicas pertinentes.
- Revisar compatibilidade na Godot 4.6.1 antes de codificar.
- Não usar gacha pago, fusion/reprodução ou classes extras como atalho para retenção.

Critérios de aceite por entrega:
- Existe um arquivo concreto no repo;
- Foi executado teste objetivo em Godot ou script equivalente;
- Foi inspecionada a apresentação no modo compacto e na tela expandida (quando visual);
- Origem, licença e estado do asset estão documentados;
- O PR é pequeno e possui CI verde.

O limite é **uma melhoria de experiência demonstrável por PR**. A quantidade de criaturas ou pastas adicionadas não será indicador de progresso.
