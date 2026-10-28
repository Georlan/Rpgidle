"use strict";

// Protótipo local: este arquivo não implementa combate, economia ou progresso real.
// Dados e nomes são amostras de UI até a matemática ser aprovada.
let catalog;
const state = {
  tab: "dungeon",
  floor: 36,
  selectedCreature: "CR001",
  selectedForm: "CR001_G1",
  theme: "forest",
  signature: "Proteção",
  compact: false,
  mockTraining: {forca:"B",velocidade:"A",resistencia:"C",inteligencia:"B"}
};
const tabs = {
  dungeon: ["Dungeon", "Expedição infinita com progresso ilustrativo. A batalha não está simulada."],
  creatures: ["Criaturas", "Três linhagens-piloto. Apenas CR001 tem sprite extraído; CR002 e CR003 são silhuetas de teste."],
  evolutions: ["Evoluções", "Uma árvore ilustrativa de quatro graus, com ramificações. Requisitos ainda não aprovados."],
  ranch: ["Rancho", "Registro de formas distintas e uma área de personalização meramente visual."],
  trainer: ["Sistema do Treinador", "O Potencial é exclusivo do treinador; a assinatura representa sua trajetória."],
  arena: ["Arena", "Prévia da leitura de uma batalha 3v3. Sem oponente real, matchmaking ou resultado."],
};
const $ = (s) => document.querySelector(s);
const safe = (text) => String(text).replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;");
const creature = (id) => catalog.creatures.find(c=>c.id===id) || catalog.creatures[0];
const sprite = (id, title="") => {
  const c=creature(id);
  const src=id==="CR001"?"../../assets/01_creatures/CR001_Lunaro/animations/CR001_G1_idle_preview.gif":c.art;
  return `<img src="${safe(src)}" alt="${safe(title || c.name)}" loading="lazy">`;
};
const partySprites = () => `<div class="party">${catalog.creatures.map(c=>sprite(c.id)).join("")}</div>`;
const pageHeading = (tab) => `<div class="topline"><div><span class="eyebrow">PROTÓTIPO / ${safe(tab.toUpperCase())}</span><h1>${safe(tabs[tab][0])}</h1><p>${safe(tabs[tab][1])}</p></div><span class="tag muted">Dados de demonstração</span></div>`;
const button = (action,label,kind="") => `<button class="btn ${kind}" data-action="${action}" type="button">${label}</button>`;

function renderDungeon() {
  return `${pageHeading("dungeon")}
  <div class="layout">
    <section class="panel">
      <div class="scene" role="img" aria-label="Cena de referência de dungeon com três criaturas e arco ao fundo">
        <div class="door"></div>
        <div class="scene-title"><div><span class="mini-label">DOMÍNIO / PROTÓTIPO</span><h2>Ruínas do Primeiro Eco</h2></div><span>Andar ${state.floor}</span></div>
        ${partySprites()}
      </div>
      <div class="actions">
        ${button("advance","Simular próximo andar","primary")}
        ${button("reset","Simular reinício")}
      </div>
      <div class="callout" style="margin-top:17px">O reinício altera somente o andar nesta prévia. Criaturas, formas e treinamento permanecem inalterados.</div>
    </section>
    <div class="stack">
      <section class="panel">
        <span class="eyebrow">EQUIPE ATIVA</span><h2>Três criaturas</h2>
        <div class="rack">${catalog.creatures.map(c=>`<button class="pet-option" data-creature="${c.id}">${sprite(c.id)}<span><strong>${safe(c.name)}</strong><small>${safe(c.kind)}</small></span></button>`).join("")}</div>
        <div class="actions">${button("open-creatures","Gerenciar equipe")}</div>
      </section>
      <section class="panel">
        <span class="eyebrow">ESTADO DA EXPEDIÇÃO</span><h2>Progresso local</h2>
        <div class="metric-grid">
          <div class="metric"><strong>${state.floor}</strong><small>Andar ilustrativo</small></div>
          <div class="metric"><strong>3/3</strong><small>Vagas de equipe</small></div>
        </div>
        <p style="margin-top:14px">Não há cálculos de loot, dano, chefes ou recompensas neste protótipo.</p>
      </section>
    </div>
  </div>`;
}
function renderCreatures() {
 const c=creature(state.selectedCreature);
 const techs=["Técnica 01","Técnica 02","Técnica 03"];
 return `${pageHeading("creatures")}
   <div class="rack" style="margin-bottom:16px">${catalog.creatures.map(x=>`<button class="pet-option ${x.id===c.id?"selected":""}" data-creature="${x.id}">${sprite(x.id)}<span><strong>${safe(x.name)}</strong><small>${safe(x.id)}</small></span></button>`).join("")}</div>
   <div class="layout">
     <section class="panel creature-layout">
       <div style="text-align:center"><span class="eyebrow">${safe(c.id)} / ${safe(c.kind)}</span><div>${`<img class="detail-img" src="${safe(c.art)}" alt="Conceito de ${safe(c.name)}">`}</div><span class="tag muted">${safe(c.status)}</span></div>
       <div><h2>${safe(c.name)}</h2><p>Os quatro atributos e suas letras são exemplos de layout, não valores de balanceamento.</p>
         <div class="stats">${Object.entries(state.mockTraining).map(([k,v])=>`<div class="stat-row"><span>${safe(k.charAt(0).toUpperCase()+k.slice(1))}</span><div class="progress"><span style="width:${{A:78,B:60,C:44}[v]||40}%"></span></div><strong>${safe(v)}</strong></div>`).join("")}</div>
       </div>
     </section>
     <div class="stack">
       <section class="panel"><span class="eyebrow">TÉCNICAS / 3 ESPAÇOS</span><h2>Cartas automáticas</h2>
         <div class="stack" style="gap:9px">${techs.map((t,i)=>`<div class="skill"><span class="skill-mark">${["◇","✦","◆"][i]}</span><div><strong>${t}</strong><small>Slot demonstrativo · comportamento não implementado</small></div></div>`).join("")}</div>
       </section>
       <section class="panel"><span class="eyebrow">CONTROLE DE PRODUÇÃO</span><h2>Estágio do asset</h2><p>${c.id==="CR001"?"Sprite de conceito com preview de idle; exige limpeza e inbetweens.":"Silhueta inicial em SVG editável. Não há animação final."}</p>
       ${button("open-evolutions","Ver evolução")}</section>
     </div>
   </div>`;
}
function renderEvolutions() {
 const grade=[1,2,3,4];
 const selected=catalog.forms.find(f=>f.id===state.selectedForm)||catalog.forms[0];
 return `${pageHeading("evolutions")}
  <section class="panel"><span class="eyebrow">ÁRVORE CONCEITUAL / CR001</span><h2>Quatro graus, caminhos diferentes</h2>
    <p>Os nomes, condições e conexões abaixo são apenas um exemplo navegável; nenhum requisito é uma regra definitiva.</p>
    <div class="branch-tree">
      ${grade.map(g=>`<div class="grade-col"><span class="mini-label">GRAU ${g}</span>${catalog.forms.filter(f=>f.grade===g).map(f=>`<button type="button" data-form="${f.id}" class="form-node ${f.id===state.selectedForm?"selected":""} ${f.grade>2?"unavailable":""}"><span class="grade">${safe(f.branch.toUpperCase())}</span><strong>${safe(f.name)}</strong><small>${f.grade>2?"Conceito futuro":"Forma para inspeção"}</small></button>`).join("")}</div>`).join("")}
    </div>
  </section>
  <div class="panel" style="margin-top:16px"><span class="eyebrow">FORMA SELECIONADA</span><h2>${safe(selected.name)}</h2>
  <p>ID: ${safe(selected.id)} · Grau ${selected.grade} · Especialização: ${safe(selected.branch)}.</p>
  <div class="callout">O registro de formas no rancho é global, mas cada criatura desbloqueia suas próprias formas. A troca entre formas disponíveis ocorre fora de combate. Requisitos concretos ainda precisam ser aprovados.</div></div>`;
}
function renderRanch() {
 return `${pageHeading("ranch")}
  <section class="panel">
    <div class="topline"><div><span class="eyebrow">HABITAT DE TESTE</span><h2>Rancho — tema ${state.theme==="forest"?"Bosque":state.theme==="dusk"?"Crepúsculo":"Noite"}</h2></div><span class="tag muted">Sem compras</span></div>
    <div class="ranch-scene ${state.theme}">${catalog.creatures.map(c=>sprite(c.id)).join("")}</div>
    <div class="actions" role="group" aria-label="Amostras de temas de rancho">
      ${[["forest","Bosque","#476958"],["dusk","Crepúsculo","#8c6472"],["night","Noite","#2c3a62"]].map(([id,label,color])=>`<button type="button" class="btn ${state.theme===id?"primary":""}" data-theme="${id}"><span aria-hidden="true" class="color-choice" style="width:13px;height:13px;background:${color};border:0;margin-right:7px"></span>${label}</button>`).join("")}
    </div>
  </section>
  <div class="layout" style="margin-top:16px"><section class="panel"><span class="eyebrow">REGISTRO PERMANENTE</span><h2>Formas distintas</h2>
   <p>As formas são registradas uma vez por descoberta global. Cópias de uma forma não geram contagem extra.</p><span class="tag muted">Contagem real indisponível neste protótipo</span></section>
   <section class="panel"><span class="eyebrow">PERSONALIZAÇÃO</span><h2>Cosméticos</h2>
   <p>Os temas mostram uma possível linha de produtos, mas não existe loja ou vantagem comprável.</p></section></div>`;
}
function renderTrainer() {
 const notes={
  "Proteção":"Estilo de preservação, resistência e contra-ataque. A assinatura afeta a equipe inteira.",
  "Ofensiva":"Estilo de pressão e risco; requer limites de gatilho e contrapartida.",
  "Estratégia":"Estilo de controle e adaptação; exige respostas competitivas possíveis."
 };
 return `${pageHeading("trainer")}
  <div class="layout"><section class="panel"><span class="eyebrow">SISTEMA / POTENCIAL DO TREINADOR</span><h2>O que a sua trajetória desperta</h2>
    <div class="signature-box"><img src="../../assets/02_cards/signature/signature_frame_concept.svg" alt="Moldura conceitual da Carta de Assinatura">
    <div><span class="tag">1 CARTA ATIVA / EQUIPE</span><h2 style="margin-top:14px">${safe(state.signature)}</h2><p>${safe(notes[state.signature])}</p></div></div>
    <div class="callout">A primeira assinatura nasce de feitos e decisões relevantes da dungeon, não de um sorteio. Os exemplos aqui não realizam um despertar real.</div><div class="motion-fx"><img src="../../assets/05_fx/fx_examples.svg" alt="Estudos de efeitos de corte, defesa e despertar"><small>Estudos de FX: camadas independentes do sprite, ainda sem timings de combate.</small></div>
  </section>
  <div class="stack">
   <section class="panel"><span class="eyebrow">IDENTIDADES CONCEITUAIS</span><h2>Famílias de assinatura</h2><div class="stack" style="gap:8px">
   ${catalog.signature_families.map(s=>`<button class="signature-family ${s===state.signature?"active":""}" type="button" data-signature="${safe(s)}">${safe(s)} <small class="muted">· inspecionar conceito</small></button>`).join("")}</div>
   </section>
   <section class="panel"><span class="eyebrow">MARCO DE PROGRESSÃO</span><h2>Rompimento → Refinamento → Maestria</h2>
   <p>O rancho contribui para os marcos de Potencial; as decisões em expedição moldam o estilo. Apenas uma assinatura fica ativa.</p></section>
  </div></div>`;
}
function renderArena() {
 return `${pageHeading("arena")}
 <section class="panel"><span class="eyebrow">PRÉVIA DE LEITURA / SEM SIMULAÇÃO</span><h2>Confronto 3 contra 3</h2>
 <div class="arena-teams">
   <div class="team-block"><h3>Equipe do treinador</h3>${partySprites()}<span class="tag">Assinatura: ${safe(state.signature)}</span></div>
   <div class="vs">VS</div>
   <div class="team-block"><h3>Equipe adversária — exemplo</h3>${partySprites()}<span class="tag muted">Assinatura desconhecida</span></div>
 </div>
 <div class="callout" style="margin-top:18px">A interface mostra apenas a composição visual. Ainda não existem servidor, oponente, matchmaking, replay ou vitória/derrota simulada.</div>
 </section>
 <div class="layout" style="margin-top:16px"><div class="panel"><h2>Normalização</h2><p>O PvE poderá usar um teto maior, mas o PvP terá limites competitivos. A fórmula não foi aprovada.</p></div>
 <div class="panel"><h2>Identidade</h2><p>A assinatura diferencia o estilo mesmo quando as três criaturas coincidem. A mesma combinação ainda pode aparecer entre jogadores diferentes.</p></div></div>`;
}
const renderers={dungeon:renderDungeon,creatures:renderCreatures,evolutions:renderEvolutions,ranch:renderRanch,trainer:renderTrainer,arena:renderArena};

function render() {
 if(!catalog) return;
 $("#app").innerHTML=renderers[state.tab]();
 document.querySelectorAll("[data-tab]").forEach(b=>{
  const active=b.dataset.tab===state.tab;
  b.classList.toggle("active",active);
  if(active) b.setAttribute("aria-current","page");
  else b.removeAttribute("aria-current");
 });
 const oldAnimation = state.compact ? "" : "Compacto";
 $("#dock").innerHTML=`<div class="dock-critters">${catalog.creatures.map(c=>sprite(c.id)).join("")}</div><div class="dock-info"><strong>Dungeon · Andar ${state.floor}</strong><small>Prévia do modo desktop — animações e combate não sincronizados</small><div class="progress" style="margin-top:5px;max-width:300px"><span style="width:62%"></span></div></div><button type="button" data-action="compact">${state.compact?"Expandir interface":"Compactar janela"}</button>`;
}

document.addEventListener("click",(e)=>{
 const t=e.target.closest("button");
 if(!t || !catalog) return;
 if(t.dataset.tab){state.tab=t.dataset.tab;render();return;}
 if(t.dataset.creature){state.selectedCreature=t.dataset.creature;state.tab="creatures";render();return;}
 if(t.dataset.form){state.selectedForm=t.dataset.form;render();return;}
 if(t.dataset.theme){state.theme=t.dataset.theme;render();return;}
 if(t.dataset.signature){state.signature=t.dataset.signature;render();return;}
 switch(t.dataset.action) {
  case "advance":state.floor++;break;
  case "reset":state.floor=1;break;
  case "open-creatures":state.tab="creatures";break;
  case "open-evolutions":state.tab="evolutions";break;
  case "compact":state.compact=!state.compact;document.body.classList.toggle("compact",state.compact);break;
 }
 render();
});
document.addEventListener("keydown",e=>{
 if(e.key==="Escape" && state.compact){
  state.compact=false;document.body.classList.remove("compact");render();
 }
 if(!e.altKey&&!e.ctrlKey&&!e.metaKey&&/^[1-6]$/.test(e.key)&&e.target.tagName!=="INPUT"){
  state.tab=Object.keys(tabs)[Number(e.key)-1];render();
 }
});
fetch("./data.json")
 .then(r=>{if(!r.ok) throw Error("HTTP "+r.status);return r.json();})
 .then(data=>{
  if(data.preview_only!==true||data.creatures?.length<3) throw Error("Catálogo de demonstração inválido");
  catalog=data;render();
 })
 .catch(err=>{
  $("#app").innerHTML=`<div class="notice"><strong>Não foi possível carregar os dados locais.</strong><p>Abra este protótipo por um servidor local, por exemplo: <code>python -m http.server 8000</code> na raiz do repositório.</p><small>${safe(err.message)}</small></div>`;
 });
