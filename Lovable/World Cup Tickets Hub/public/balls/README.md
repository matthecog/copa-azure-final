# Bolas oficiais das Copas do Mundo

Coloque aqui a imagem da bola oficial de cada Copa, no formato **AVIF**.

## Convenção de nomes

Cada arquivo deve se chamar **`{ano}.avif`** (o ano da Copa). O código carrega
automaticamente `/balls/{ano}.avif` e, se o arquivo não existir, simplesmente
não exibe nada (fallback gracioso — não quebra a tela). Não é preciso editar
código para adicionar/remover bolas: basta colocar ou remover o arquivo aqui.

## Arquivos esperados (23 edições)

```
1930.avif  1934.avif  1938.avif  1950.avif  1954.avif  1958.avif
1962.avif  1966.avif  1970.avif  1974.avif  1978.avif  1982.avif
1986.avif  1990.avif  1994.avif  1998.avif  2002.avif  2006.avif
2010.avif  2014.avif  2018.avif  2022.avif  2026.avif
```

> Você não precisa ter todos. Coloque apenas os que tiver — os demais anos
> ficam sem a bola, sem nenhum erro visual.

## Onde aparece

- **Listagem** (`/historia`): miniatura no canto inferior direito do card.
- **Detalhe** (`/historia/{ano}`): card "Bola oficial" na barra lateral.

## Legenda com o nome da bola (opcional)

Se quiser exibir o nome da bola (ex.: "Adidas Telstar") como legenda, preencha
o campo `ball` da respectiva Copa em `src/data/world-cups.ts`. É opcional — sem
ele, apenas a imagem é exibida.
