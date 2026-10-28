# Pipeline de produção visual

1. **Conceito:** definir silhueta/atributos da linhagem em uma frase; produzir uma vista visual coerente.
2. **Revisão:** conferir originalidade, identidade da família, proporções e legibilidade em tamanho real.
3. **Sprite-base:** limpar pixel grid, contorno, transparência, sombra e ponto de contato com o chão.
4. **Animação:** criar quadros consistentes; não transformar os primeiros GIFs de pose em promessa de animação final.
5. **Integração:** manter origem, escala, pivot, frames, duração, estado e status de revisão no manifesto.
6. **QA:** verificar transparência, vazamento de pixels, loop, alinhamento, performance e leitura no desktop.
7. **Publicação:** registrar origem e utilização de IA, revisar direitos e exigências da Steam; assets comerciais exigem checagem final.

## IDs e convenções

- Criatura: `CR001`, `CR002`...
- Forma: `CR001_G1` etc.; ramificação acrescenta sufixo quando necessário.
- Técnica: `TC001`; assinatura: `SG001`; efeitos: `FX001`.
- Arquivos: letras minúsculas e underscore; arquivos-fonte separados de exportações.
- A revisão de um arquivo **não** modifica o ID lógico de sua criatura.
- O manifesto é a fonte da verdade do **status**, não do balanceamento.

## Git

Somente versionar arquivos úteis e auditáveis; não subir exports temporários ou uma pasta de screenshots duplicados. Binários grandes podem exigir Git LFS quando a biblioteca crescer. Nunca publicar tokens/credenciais.

Os arquivos do kit exploratório podem ser importados sob `assets/` mantendo a divisão original `00_reference` a `05_fx`.
