# Mascotes oficiais das Copas do Mundo

Coloque aqui a imagem do mascote oficial de cada Copa, no formato **AVIF**.

## Convenção de nomes

Cada arquivo deve se chamar **`{ano}.avif`** (o ano da Copa). O código carrega
`/mascots/{ano}.avif` e, se o arquivo não existir, simplesmente não exibe o card
(fallback gracioso). Nem toda Copa teve mascote — o primeiro foi em **1966**
(World Cup Willie). Copas anteriores (1930–1962) não têm mascote e o card não
aparece.

## Mascotes disponíveis (16)

```
1966 World Cup Willie     1998 Footix
1970 Juanito              2002 Ato, Kaz e Nik
1974 Tip e Tap            2006 Goleo VI e Pille
1978 Gauchito             2010 Zakumi
1982 Naranjito            2014 Fuleco
1986 Pique                2018 Zabivaka
1990 Ciao                 2022 La'eeb
1994 Striker              2026 Maple, Zayu e Clutch
```

> Ideal: imagens com **fundo transparente** (recortadas). Origens com fundo
> opaco aparecem com um "quadrado" atrás, destoando das demais.

## Onde aparece

Card "Mascote oficial" na barra lateral do detalhe (`/historia/{ano}`), logo
abaixo do card "Bola oficial". O nome (campo `mascot` em `src/data/world-cups.ts`)
é exibido como legenda.
