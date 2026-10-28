# Plano de publicação e teste na Steam — estado: pré-produção (28/10/2026)

> Esta página não substitui o painel privado Steamworks. **Nenhuma taxa foi paga e nenhum AppID, build, Playtest ou página foi criado por este repositório.** Conferir valores, prazos e checklist no Steamworks antes de gastar.

## Estratégia comercial

**Jogo premium acessível + cosméticos opcionais**, sem atributos, cartas exclusivas ou progressão de treinador pagos. O PvE é o centro; o PvP permanece subordinado ao balanceamento e não deve bloquear o MVP.

### Passos sequenciais

1. **Validação local:** protótipo Godot, controles, modo compacto, UI, ciclo simples, arte revisada e estabilidade. Ainda não há jogo.
2. **Prova de valor:** uma criatura verdadeiramente jogável, uma dungeon curta, uma árvore condicionada e uma assinatura de treinador funcionando; validar retenção e disposição a pagar.
3. **Cadastro Steamworks/Steam Direct:** completar dados legais, bancários e fiscais; pagar a taxa de **US$ 100 por aplicativo**, vigente na consulta. A Valve indica que a restitui no pagamento após alcançar US$ 1.000 de receita bruta ajustada. Não cadastrar antes de ter plano de comercialização e um nome coerente.
4. **Página Coming Soon:** arte original, identidade definitiva, descrição precisa, screenshots de gameplay real, idiomas e requisitos mínimos medidos. Enviar checklist para revisão da Valve; a página deve ficar pública por pelo menos **duas semanas antes de lançar**. O programa Steamworks informa **30 dias após a taxa** para primeiros lançamentos; confirmar no painel individual.
5. **Demo gratuita vinculada:** aplicativo filho com escopo contido, sem prometer mecânicas ainda não prontas. Usar a demo para que jogadores entendam o diferencial da assinatura e das evoluções.
6. **Steam Playtest:** outra opção de aplicativo filho, sem compras ou monetização dentro dele; entrada gratuita controlável, sem afetar reviews e wishlists do jogo base. Usar mais tarde para testar arena, usabilidade e distribuição de controles.
7. **Build candidata:** exportar Windows x86_64 pela Godot, com templates corretos, verificar inicialização limpa e salvar/retomar progresso. Revisão de build e loja pela Valve; a descrição não pode prometer recursos inexistentes.
8. **SteamPipe/SteamCMD:** criar depots e builds no Steamworks, testar primeiro numa branch beta privada e só publicar na branch default após validação. Nunca guardar credenciais Steam em Git.
9. **Lançamento premium e suporte:** métricas de retenção/bugs, feedback de compra, crashes e compatibilidade de hardware; cosméticos apenas após o loop ser convincente.

## Demos vs Playtest

| Modalidade | Objetivo | Acesso | Monetização |
|---|---|---|---|
| Build local / chave de desenvolvimento | Validação técnica interna | Equipe/testadores | Não |
| **Demo** | Converter interesse em wishlist/compra | Gratuito, público | Não vender vantagem |
| **Steam Playtest** | Testar escala/UX/balanceamento | Gratuito, com inscrições/convites | **Proibido vender acesso e microtransações no Playtest** |
| Jogo premium | Produto comercial | Pago | Cosméticos opcionais |

**Importante:** o Playtest não tem loja própria; a inscrição aparece na página do jogo base. A demo usa AppID separado associado.

## Checkpoints de marketing sem promessas falsas

- [ ] Nome e marca aprovados, sem confundir com IPs existentes.
- [ ] Capa da Steam e screenshots do jogo **real**, não apenas moodboards.
- [ ] Loop jogável e vídeo de gameplay honesto.
- [ ] Requisitos e sistemas operacionais demonstrados com testes.
- [ ] Informações sobre IA e direitos de uso revisadas conforme a política atual do Steam.
- [ ] Descrição de cada recurso condizente com a build enviada à Valve.
- [ ] Plano de suporte, políticas de privacidade quando houver contas/telemetria.
- [ ] Não declarar suporte completo a controle ou verificação Steam Deck sem testes reais.

## Publicação técnica (planejamento, não automação habilitada)

- **Godot:** export preset para Windows 64-bit com templates de exportação adequados.
- **Steamworks:** associar build a depots/branch beta via SteamPipe. Credenciais, AppIDs e tokens **fora do Git**.
- **Testes:** instalação limpa, inicialização pela biblioteca Steam, overlay, troca de idioma, alt-tab, gamepad, perda de foco, janela compacta, suspensão e reabertura.
- **Release:** passar por revisão, janela Coming Soon e critérios de aprovação antes de disponibilizar o jogo.

## Fontes oficiais (consultadas em outubro de 2026)

- Steam Direct e taxa: https://partner.steamgames.com/doc/gettingstarted/appfee
- Steamworks Partner Program: https://partner.steamgames.com/steamdirect/
- Coming Soon: https://partner.steamgames.com/doc/store/coming_soon
- Revisão de loja e build: https://partner.steamgames.com/doc/store/review_process
- Demo: https://partner.steamgames.com/doc/store/application/demos
- Steam Playtest: https://partner.steamgames.com/doc/features/playtest
- SteamPipe: https://partner.steamgames.com/doc/sdk/uploading
- Steam Input: https://partner.steamgames.com/doc/features/steam_controller
- Steam Deck/Steam Machine: https://partner.steamgames.com/doc/steamhardware/compat
- Godot Windows export: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_windows.html
