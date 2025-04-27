#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
#import "template.typ": *

#show: doc => conf([E.A.3.1 (Esplorazione di Spazi degli Stati 1)], doc)

#let small(t) = text(size: 0.7em, str(t))
#let yellow = rgb("#fabd2f")
#let blue = rgb("#83a598")
#let green = rgb("#b8bb26")

== Ricerca in profondità
DFS (depth first search)

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 2pt + green),
    edge(<S>, <A>, 2, "-|>", stroke: yellow),
    edge(<S>, <B>, 7, "-|>", stroke: yellow),
    edge(<S>, <D>, 5, "-|>", stroke: green),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + yellow),
    edge(<A>, <B>, 4, "-|>"),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 1pt + yellow),
    edge(<B>, <C>, 3, "-|>"),
    edge(<B>, <G1>, 9, "-|>"),

    node((5, 3), [*C* \ #small(2)], name: <C>, stroke: 1pt + yellow),
    edge(<C>, <F>, 2, "-|>"),
    edge(<C>, <J>, 5, "-|>"),
    edge(<C>, <S>, 1, "-|>"),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 2pt + green),
    edge(<D>, <C>, 3, "-|>", stroke: yellow),
    edge(<D>, <E>, 3, "-|>", stroke: green),
    edge(<D>, <S>, 8, "-|>", bend: -45deg, stroke: yellow),

    node((11, 2), [*E* \ #small(5)], name: <E>, stroke: 2pt + green),
    edge(<E>, <G2>, 7, "-|>", stroke: green),

    node((9, 5), [*F* \ #small(3)], name: <F>),
    edge(<F>, <D>, 1, "-|>"),
    edge(<F>, <G2>, 4, "-|>"),

    node((0, 3), [*G1* \ #small(0)], name: <G1>),
    node((12, 3), [*G2* \ #small(0)], name: <G2>, stroke: 2pt + green),

    node((4, 5), [*J* \ #small(1)], name: <J>),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

\

#align(center)[
  #table(
    columns: (auto, auto, auto, 7em, auto),
    align: (center + horizon, center + horizon, center + horizon, center + horizon, start),
    table.header(
      [\#],
      [],
      [*azioni*],
      [*esplorati*],
      [*frontiera*],
    ),
    [0], $emptyset$, `{}`, `{}`,
    `(S, g: 0, h: 7, f: 7, d: 0)  <`,
    [1], `S`, `{A, B, D}`, `{S}`,
    `(D, g: 5, h: 4, f:  9, d: 1) <
(B, g: 7, h: 3, f: 10, d: 1)
(A, g: 2, h: 9, f: 11, d: 1)
`,
    [2], `D`, `{C, E, S}`, `{D, S}`,
    `(E, g: 8, h: 5, f: 13, d: 2) <
(C, g: 8, h: 2, f: 10, d: 2)
(B, g: 7, h: 3, f: 10, d: 1)
(A, g: 2, h: 9, f: 11, d: 1)
`,
    [3], `E`, `{G2}`, `{D, E, S}`,
    `(G2, g: 15, h: 0, f: 15, d: 3) <
(C, g: 8, h: 2, f: 10, d: 2)
(B, g: 7, h: 3, f: 10, d: 1)
(A, g: 2, h: 9, f: 11, d: 1)
`,
    [4], `G2`, `{}`, `{D, E, G2, S}`, table.cell(align: center + horizon, `is goal`)
  )
]

\

/ Percorso: $"S" -> "D" -> "E" -> "G2"$
/ Costo: 5 + 3 + 7 = 15
/ Iterazioni: 4
/ Ottimalità: il cammino non è ottimale (il costo ottimale è 14, generalmente la DFS non garantisce l'ottimalità)

#pagebreak()

== Ricerca in ampiezza
BFS (breadth first search)

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 2pt + green),
    edge(<S>, <A>, 2, "-|>", stroke: blue),
    edge(<S>, <B>, 7, "-|>", stroke: green),
    edge(<S>, <D>, 5, "-|>", stroke: blue),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + blue),
    edge(<A>, <B>, 4, "-|>", stroke: yellow),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 2pt + green),
    edge(<B>, <C>, 3, "-|>", stroke: blue),
    edge(<B>, <G1>, 9, "-|>", stroke: green),

    node((5, 3), [*C* \ #small(2)], name: <C>, stroke: 1pt + blue),
    edge(<C>, <F>, 2, "-|>", stroke: yellow),
    edge(<C>, <J>, 5, "-|>", stroke: yellow),
    edge(<C>, <S>, 1, "-|>", stroke: yellow),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 1pt + blue),
    edge(<D>, <C>, 3, "-|>", stroke: yellow),
    edge(<D>, <E>, 3, "-|>", stroke: yellow),
    edge(<D>, <S>, 8, "-|>", bend: -45deg, stroke: yellow),

    node((11, 2), [*E* \ #small(5)], name: <E>, stroke: 1pt + yellow),
    edge(<E>, <G2>, 7, "-|>"),

    node((9, 5), [*F* \ #small(3)], name: <F>, stroke: 1pt + yellow),
    edge(<F>, <D>, 1, "-|>"),
    edge(<F>, <G2>, 4, "-|>"),

    node((0, 3), [*G1* \ #small(0)], name: <G1>, stroke: 2pt + green),

    node((12, 3), [*G2* \ #small(0)], name: <G2>),

    node((4, 5), [*J* \ #small(1)], name: <J>, stroke: 1pt + yellow),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

\

#align(center)[
  #table(
    columns: (auto, auto, auto, 7em, auto),
    align: (center + horizon, center + horizon, center + horizon, center + horizon, left),
    table.header(
      [\#],
      [],
      [*azioni*],
      [*esplorati*],
      [*frontiera*],
    ),
    [0], $emptyset$, `{}`, `{}`,
    `(S, g: 0, h: 7, f: 7, d: 0)`,
    [1], `S`, `{A, B, D}`, `{S}`,
    `(A, g: 2, h: 9, f: 11, d: 1)
(B, g: 7, h: 3, f: 10, d: 1)
(D, g: 5, h: 4, f:  9, d: 1)
`,
    [2], `A`, `{B}`, `{A, S}`,
    `(A, g: 2, h: 9, f: 11, d: 1)
(B, g: 7, h: 3, f: 10, d: 1)
(D, g: 5, h: 4, f:  9, d: 1)
`,
    [3], `B`, `{C, G1}`, `{A, B, S}`,
    `(D, g: 5, h: 4, f: 9, d: 1)
(C, g: 10, h: 2, f: 12, d: 2)
(G1, g: 16, h: 0, f: 16, d: 2)
`,
    [4], `D`, `{C, E, S}`, `{A, B, D, S}`,
    `(C, g: 10, h: 2, f: 12, d: 2)
(G1, g: 16, h: 0, f: 16, d: 2)
(E, g: 8, h: 5, f: 13, d: 2)
`,
    [5], `C`, `{F, J, S}`, `{A, B, C, D, S}`,
    `(G1, g: 16, h: 0, f: 16, d: 2)
(E, g: 8, h: 5, f: 13, d: 2)
(F, g: 12, h: 3, f: 15, d: 3)
(J, g: 15, h: 1, f: 16, d: 3)
`,
    [6], `G1`, `{}`, `{A, B, D, G1, S}`,
    table.cell(align: center + horizon, `is goal`)
  )
]

\

/ Percorso: $"S" -> "B" -> "G1"$
/ Costo: 7 + 9 = 16
/ Iterazioni: 1
/ Ottimalità: il cammino non è ottimale

Generalmente la BFS garantisce l'ottimalità solo se il costo per tutte le azioni è lo stesso (perché la BFS trova il minor numero di azioni per raggiungere l'obiettivo), e se è possibile trovare un piano (quindi le azioni per un dato stato non sono infinite).

// - garantisce solo la minimalità del numero di azioni
// - il cammino trovato è ottimo se il costo di tutte le azioni è lo stesso

#pagebreak()

== Ricerca a costi uniformi
Min cost search

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 2pt + green),
    edge(<S>, <A>, 2, "-|>", stroke: blue),
    edge(<S>, <B>, 7, "-|>", stroke: blue),
    edge(<S>, <D>, 5, "-|>", stroke: green),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + blue),
    edge(<A>, <B>, 4, "-|>", stroke: yellow),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 1pt + blue),
    edge(<B>, <C>, 3, "-|>", stroke: yellow),
    edge(<B>, <G1>, 9, "-|>", stroke: yellow),

    node((5, 3), [*C* \ #small(2)], name: <C>, stroke: 2pt + green),
    edge(<C>, <F>, 2, "-|>", stroke: green),
    edge(<C>, <J>, 5, "-|>", stroke: blue),
    edge(<C>, <S>, 1, "-|>", stroke: yellow),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 2pt + green),
    edge(<D>, <C>, 3, "-|>", stroke: green),
    edge(<D>, <E>, 3, "-|>", stroke: blue),
    edge(<D>, <S>, 8, "-|>", bend: -45deg, stroke: yellow),

    node((11, 2), [*E* \ #small(5)], name: <E>, stroke: 1pt + blue),
    edge(<E>, <G2>, 7, "-|>", stroke: blue),

    node((9, 5), [*F* \ #small(3)], name: <F>, stroke: 2pt + green),
    edge(<F>, <D>, 1, "-|>", stroke: yellow),
    edge(<F>, <G2>, 4, "-|>", stroke: green),

    node((0, 3), [*G1* \ #small(0)], name: <G1>, stroke: 1pt + yellow),

    node((12, 3), [*G2* \ #small(0)], name: <G2>, stroke: 2pt + green),

    node((4, 5), [*J* \ #small(1)], name: <J>, stroke: 1pt + blue),
    edge(<J>, <G1>, 3, "-|>", stroke: yellow),
  )
]

\

#align(center)[
  #table(
    columns: (auto, auto, auto, 7em, auto),
    align: (center + horizon, center + horizon, center + horizon, center + horizon, start),
    table.header(
      [\#],
      [],
      [*azioni*],
      [*esplorati*],
      [*frontiera*],
    ),
    [0], $emptyset$, `{}`, `{}`,
    `{
  (S, g: 0, h: 7, f: 7, d: 0),
}`,
    [1], `S`, `{A, B, D}`, `{S}`,
    `{
  (A, g: 2, h: 9, f: 11, d: 1),
  (D, g: 5, h: 4, f:  9, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
}`,
    [2], `A`, `{B}`, `{A, S}`,
    `{
  (D, g: 5, h: 4, f: 9, d: 1),
  (B, g: 6, h: 3, f: 9, d: 2),
}`,
    [3], `D`, `{C, E, S}`, `{A, D, S}`,
    `{
  (B, g: 6, h: 3, f: 9, d: 2),
  (C, g: 8, h: 2, f: 10, d: 2),
  (E, g: 8, h: 5, f: 13, d: 2),
}`,
    [4], `B`, `{C, G1}`, `{A, B, D, S}`,
    `{
  (C, g: 8, h: 2, f: 10, d: 2),
  (E, g: 8, h: 5, f: 13, d: 2),
  (G1, g: 15, h: 0, f: 15, d: 3),
}`,
    [5], `C`, `{F, J, S}`, `{A, B, C, D, S}`,
    `{
  (E, g: 8, h: 5, f: 13, d: 2),
  (F, g: 10, h: 3, f: 13, d: 3),
  (J, g: 13, h: 1, f: 14, d: 3),
  (G1, g: 15, h: 0, f: 15, d: 3),
}`,
    [6], `E`, `{G2}`, `{A, B, C, D, E, S}`,
    `{
  (F, g: 10, h: 3, f: 13, d: 3),
  (J, g: 13, h: 1, f: 14, d: 3),
  (G1, g: 15, h: 0, f: 15, d: 3),
  (G2, g: 15, h: 0, f: 15, d: 3),
}`,
    [7], `F`, `{D, G2}`, `{A, B, C, D, E, F, S}`,
    `{
  (J, g: 13, h: 1, f: 14, d: 3),
  (G2, g: 14, h: 0, f: 14, d: 4),
  (G1, g: 15, h: 0, f: 15, d: 3),
}`,
    [8], `J`, `{G1}`, `{A, B, C, D, E, F, J, S}`,
    `{
  (G2, g: 14, h: 0, f: 14, d: 4),
  (G1, g: 15, h: 0, f: 15, d: 3),
}`,
    [9], `G2`, `{}`, `{A, B, C, D, E, F, G2, J, S}`, table.cell(align: center + horizon, `is goal`)
  )
]

\

/ Percorso: $"S" -> "D" -> "C" -> "F" -> "G2"$
/ Costo: 5 + 3 + 2 + 4 = 14
/ Iterazioni: 1
/ Ottimalità: il costo del cammino è ottimale

L'algoritmo min cost trova sempre il cammino ottimale (se l'albero di ricerca è finito).

#pagebreak()

== Ricerca ad approfondimento iterativo
Iterative deepening search

=== Iterazione 1

\

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 1pt + blue),
    edge(<S>, <A>, 2, "-|>", stroke: blue),
    edge(<S>, <B>, 7, "-|>", stroke: blue),
    edge(<S>, <D>, 5, "-|>", stroke: blue),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + blue),
    edge(<A>, <B>, 4, "-|>"),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 1pt + blue),
    edge(<B>, <C>, 3, "-|>"),
    edge(<B>, <G1>, 9, "-|>"),

    node((5, 3), [*C* \ #small(2)], name: <C>),
    edge(<C>, <F>, 2, "-|>"),
    edge(<C>, <J>, 5, "-|>"),
    edge(<C>, <S>, 1, "-|>"),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 1pt + blue),
    edge(<D>, <C>, 3, "-|>"),
    edge(<D>, <E>, 3, "-|>"),
    edge(<D>, <S>, 8, "-|>", bend: -45deg),

    node((11, 2), [*E* \ #small(5)], name: <E>),
    edge(<E>, <G2>, 7, "-|>"),

    node((9, 5), [*F* \ #small(3)], name: <F>),
    edge(<F>, <D>, 1, "-|>"),
    edge(<F>, <G2>, 4, "-|>"),

    node((0, 3), [*G1* \ #small(0)], name: <G1>),

    node((12, 3), [*G2* \ #small(0)], name: <G2>),

    node((4, 5), [*J* \ #small(1)], name: <J>),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

\

=== Iterazione 2

\

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 2pt + green),
    edge(<S>, <A>, 2, "-|>", stroke: blue),
    edge(<S>, <B>, 7, "-|>", stroke: green),
    edge(<S>, <D>, 5, "-|>", stroke: blue),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + blue),
    edge(<A>, <B>, 4, "-|>", stroke: yellow),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 2pt + green),
    edge(<B>, <C>, 3, "-|>", stroke: yellow),
    edge(<B>, <G1>, 9, "-|>", stroke: green),

    node((5, 3), [*C* \ #small(2)], name: <C>, stroke: 1pt + blue),
    edge(<C>, <F>, 2, "-|>"),
    edge(<C>, <J>, 5, "-|>"),
    edge(<C>, <S>, 1, "-|>"),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 1pt + blue),
    edge(<D>, <C>, 3, "-|>", stroke: blue),
    edge(<D>, <E>, 3, "-|>", stroke: blue),
    edge(<D>, <S>, 8, "-|>", bend: -45deg, stroke: yellow),

    node((11, 2), [*E* \ #small(5)], name: <E>, stroke: 1pt + blue),
    edge(<E>, <G2>, 7, "-|>"),

    node((9, 5), [*F* \ #small(3)], name: <F>),
    edge(<F>, <D>, 1, "-|>"),
    edge(<F>, <G2>, 4, "-|>"),

    node((0, 3), [*G1* \ #small(0)], name: <G1>, stroke: 2pt + green),

    node((12, 3), [*G2* \ #small(0)], name: <G2>),

    node((4, 5), [*J* \ #small(1)], name: <J>),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

\

#align(center)[
  #table(
    columns: (auto, auto, auto, 7em, auto),
    align: (center + horizon, center + horizon, center + horizon, center + horizon, start),
    table.header(
      [\#],
      [],
      [*azioni*],
      [*esplorati*],
      [*frontiera*],
    ),
    [0], $emptyset$, `{}`, `{}`,
    `[
  (S, g: 0, h: 7, f: 7, d: 0),
]`,
    [1], `S`, `{A, B, D}`, `{S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
  (D, g: 5, h: 4, f:  9, d: 1),
]`,
    [2], `D`, `{}`, `{D, S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
]`,
    [3], `B`, `{}`, `{B, D, S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
]`,
    [4], `A`, `{}`, `{A, B, D, S}`, `[]`,
    [5], $emptyset$, `{}`, `{}`,
    `[
  (S, g: 0, h: 7, f: 7, d: 0),
]`,
    [6], `S`, `{A, B, D}`, `{S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
  (D, g: 5, h: 4, f:  9, d: 1),
]`,
    [7], `D`, `{C, E, S}`, `{D, S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
  (C, g: 8, h: 2, f: 10, d: 2),
  (E, g: 8, h: 5, f: 13, d: 2),
]`,
    [8], `E`, `{}`, `{D, E, S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
  (C, g: 8, h: 2, f: 10, d: 2),
]`,
    [9], `C`, `{}`, `{C, D, E, S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
]`,
    [10], `B`, `{C, G1}`, `{B, C, D, E, S}`,
    `[
  (A, g: 2, h: 9, f: 11, d: 1),
  (G1, g: 16, h: 0, f: 16, d: 2),
]`,
    [11], `G1`, `{}`, `{B, C, D, E, G1, S}`, table.cell(align: center + horizon, `is goal`)
  )
]

\

/ Percorso: $"S" -> "B" -> "G1"$
/ Costo: 7 + 9 = 16
/ Iterazioni: 2
/ Ottimalità: il cammino non è ottimale

Generalmente non è detto che la ricerca ad approfondimento iterativo trovi un cammino con costo ottimale.

#pagebreak()

== Ricerca best-first greedy
Best-first greedy search

\

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 1pt + blue),
    edge(<S>, <A>, 2, "-|>", stroke: yellow),
    edge(<S>, <B>, 7, "-|>", stroke: yellow),
    edge(<S>, <D>, 5, "-|>", stroke: yellow),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + yellow),
    edge(<A>, <B>, 4, "-|>"),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 1pt + yellow),
    edge(<B>, <C>, 3, "-|>"),
    edge(<B>, <G1>, 9, "-|>"),

    node((5, 3), [*C* \ #small(2)], name: <C>),
    edge(<C>, <F>, 2, "-|>"),
    edge(<C>, <J>, 5, "-|>"),
    edge(<C>, <S>, 1, "-|>"),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 1pt + yellow),
    edge(<D>, <C>, 3, "-|>"),
    edge(<D>, <E>, 3, "-|>"),
    edge(<D>, <S>, 8, "-|>", bend: -45deg),

    node((11, 2), [*E* \ #small(5)], name: <E>),
    edge(<E>, <G2>, 7, "-|>"),

    node((9, 5), [*F* \ #small(3)], name: <F>),
    edge(<F>, <D>, 1, "-|>"),
    edge(<F>, <G2>, 4, "-|>"),

    node((0, 3), [*G1* \ #small(0)], name: <G1>),
    node((12, 3), [*G2* \ #small(0)], name: <G2>),

    node((4, 5), [*J* \ #small(1)], name: <J>),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 1pt + blue),
    edge(<S>, <A>, 2, "-|>", stroke: yellow),
    edge(<S>, <B>, 7, "-|>", stroke: blue),
    edge(<S>, <D>, 5, "-|>", stroke: yellow),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + yellow),
    edge(<A>, <B>, 4, "-|>"),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 1pt + blue),
    edge(<B>, <C>, 3, "-|>", stroke: yellow),
    edge(<B>, <G1>, 9, "-|>", stroke: yellow),

    node((5, 3), [*C* \ #small(2)], name: <C>, stroke: 1pt + yellow),
    edge(<C>, <F>, 2, "-|>"),
    edge(<C>, <J>, 5, "-|>"),
    edge(<C>, <S>, 1, "-|>"),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 1pt + yellow),
    edge(<D>, <C>, 3, "-|>"),
    edge(<D>, <E>, 3, "-|>"),
    edge(<D>, <S>, 8, "-|>", bend: -45deg),

    node((11, 2), [*E* \ #small(5)], name: <E>),
    edge(<E>, <G2>, 7, "-|>"),

    node((9, 5), [*F* \ #small(3)], name: <F>),
    edge(<F>, <D>, 1, "-|>"),
    edge(<F>, <G2>, 4, "-|>"),

    node((0, 3), [*G1* \ #small(0)], name: <G1>, stroke: 1pt + yellow),
    node((12, 3), [*G2* \ #small(0)], name: <G2>),

    node((4, 5), [*J* \ #small(1)], name: <J>),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 2pt + green),
    edge(<S>, <A>, 2, "-|>", stroke: yellow),
    edge(<S>, <B>, 7, "-|>", stroke: green),
    edge(<S>, <D>, 5, "-|>", stroke: yellow),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + yellow),
    edge(<A>, <B>, 4, "-|>"),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 2pt + green),
    edge(<B>, <C>, 3, "-|>", stroke: yellow),
    edge(<B>, <G1>, 9, "-|>", stroke: green),

    node((5, 3), [*C* \ #small(2)], name: <C>, stroke: 1pt + yellow),
    edge(<C>, <F>, 2, "-|>"),
    edge(<C>, <J>, 5, "-|>"),
    edge(<C>, <S>, 1, "-|>"),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 1pt + yellow),
    edge(<D>, <C>, 3, "-|>"),
    edge(<D>, <E>, 3, "-|>"),
    edge(<D>, <S>, 8, "-|>", bend: -45deg),

    node((11, 2), [*E* \ #small(5)], name: <E>),
    edge(<E>, <G2>, 7, "-|>"),

    node((9, 5), [*F* \ #small(3)], name: <F>),
    edge(<F>, <D>, 1, "-|>"),
    edge(<F>, <G2>, 4, "-|>"),

    node((0, 3), [*G1* \ #small(0)], name: <G1>, stroke: 2pt + green),
    node((12, 3), [*G2* \ #small(0)], name: <G2>),

    node((4, 5), [*J* \ #small(1)], name: <J>),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

\

#align(center)[
  #table(
    columns: (auto, auto, auto, 7em, auto),
    align: (center + horizon, center + horizon, center + horizon, center + horizon, start),
    table.header(
      [\#],
      [],
      [*azioni*],
      [*esplorati*],
      [*frontiera*],
    ),
    [0], $emptyset$, `{}`, `{}`,
    `{
  (S, g: 0, h: 7, f: 7, d: 0),
}`,
    [1], `S`, `{A, B, D}`, `{S}`,
    `{
  (B, g: 7, h: 3, f: 10, d: 1),
  (D, g: 5, h: 4, f:  9, d: 1),
  (A, g: 2, h: 9, f: 11, d: 1),
}`,
    [2], `B`, `{C, G1}`, `{B, S}`,
    `{
  (G1, g: 16, h: 0, f: 16, d: 2),
  (C, g: 10, h: 2, f: 12, d: 2),
  (D, g: 5, h: 4, f:  9, d: 1),
  (A, g: 2, h: 9, f: 11, d: 1),
}`,
    [3], `G1`, `{}`, `{B, G1, S}`, table.cell(align: center + horizon, `is goal`)
  )
]

\

/ Percorso: $"S" -> "B" -> "G1"$
/ Costo: 7 + 9 = 16
/ Iterazioni: 1
/ Ottimalità: la soluzione non è ottimale

L'algoritmo best-first non è ottimale, a meno che l'euristica non corrisponde esattamente alla distanza minima per raggiungere un goal. Questo perché il best-first non considera i costi effettivi (che sono maggiori o uguali all'euristica).

#pagebreak()

== A#super[\*]

A#super[\*]

\

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((5, 0), [*S* \ #small(7)], name: <S>, stroke: 2pt + green),
    edge(<S>, <A>, 2, "-|>", stroke: blue),
    edge(<S>, <B>, 7, "-|>", stroke: blue),
    edge(<S>, <D>, 5, "-|>", stroke: green),

    node((1, 1), [*A* \ #small(9)], name: <A>, stroke: 1pt + blue),
    edge(<A>, <B>, 4, "-|>", stroke: yellow),

    node((3, 2), [*B* \ #small(3)], name: <B>, stroke: 1pt + blue),
    edge(<B>, <C>, 3, "-|>", stroke: yellow),
    edge(<B>, <G1>, 9, "-|>", stroke: yellow),

    node((5, 3), [*C* \ #small(2)], name: <C>, stroke: 2pt + green),
    edge(<C>, <F>, 2, "-|>", stroke: green),
    edge(<C>, <J>, 5, "-|>", stroke: yellow),
    edge(<C>, <S>, 1, "-|>", stroke: yellow),

    node((9, 1), [*D* \ #small(4)], name: <D>, stroke: 2pt + green),
    edge(<D>, <C>, 3, "-|>", stroke: green),
    edge(<D>, <E>, 3, "-|>", stroke: blue),
    edge(<D>, <S>, 8, "-|>", bend: -45deg, stroke: yellow),

    node((11, 2), [*E* \ #small(5)], name: <E>, stroke: 1pt + blue),
    edge(<E>, <G2>, 7, "-|>", stroke: blue),

    node((9, 5), [*F* \ #small(3)], name: <F>, stroke: 2pt + green),
    edge(<F>, <D>, 1, "-|>", stroke: yellow),
    edge(<F>, <G2>, 4, "-|>", stroke: green),

    node((0, 3), [*G1* \ #small(0)], name: <G1>, stroke: 1pt + yellow),
    node((12, 3), [*G2* \ #small(0)], name: <G2>, stroke: 2pt + green),

    node((4, 5), [*J* \ #small(1)], name: <J>, stroke: 1pt + yellow),
    edge(<J>, <G1>, 3, "-|>"),
  )
]

\

#align(center)[
  #table(
    columns: (auto, auto, auto, 7em, auto),
    align: (center + horizon, center + horizon, center + horizon, center + horizon, start),
    table.header(
      [\#],
      [],
      [*azioni*],
      [*esplorati*],
      [*frontiera*],
    ),
    [0], $emptyset$, `{}`, `{}`,
    `{
  (S, g: 0, h: 7, f: 7, d: 0),
}`,
    [1], `S`, `{A, B, D}`, `{S}`,
    `{
  (D, g: 5, h: 4, f:  9, d: 1),
  (B, g: 7, h: 3, f: 10, d: 1),
  (A, g: 2, h: 9, f: 11, d: 1),
}`,
    [2], `D`, `{C, E, S}`, `{D, S}`,
    `{
  (B, g: 7, h: 3, f: 10, d: 1),
  (C, g: 8, h: 2, f: 10, d: 2),
  (A, g: 2, h: 9, f: 11, d: 1),
  (E: g: 8, h: 5, f: 13, d: 2),
}`,
    [3], `B`, `{C, G1}`, `{B, D, S}`,
    `{
  (C, g: 8, h: 2, f: 10, d: 2),
  (A, g: 2, h: 9, f: 11, d: 1),
  (E: g: 8, h: 5, f: 13, d: 2),
  (G1: g: 16, h: 0, f: 16, d: 2),
}`,
    [4], `C`, `{F, J, S}`, `{B, C, D, S}`,
    `{
  (A, g: 2, h: 9, f: 11, d: 1),
  (E: g: 8, h: 5, f: 13, d: 2),
  (F: g: 10, h: 3, f: 13, d: 3),
  (J: g: 13, h: 1, f: 14, d: 3),
  (G1: g: 16, h: 0, f: 16, d: 2),
}`,
    [5], `A`, `{B}`, `{A, B, C, D, S}`,
    `{
  (E: g: 8, h: 5, f: 13, d: 2),
  (F: g: 10, h: 3, f: 13, d: 3),
  (J: g: 13, h: 1, f: 14, d: 3),
  (G1: g: 16, h: 0, f: 16, d: 2),
}`,
    [6], `E`, `{G2}`, `{A, B, C, D, E, S}`,
    `{
  (F: g: 10, h: 3, f: 13, d: 3),
  (J: g: 13, h: 1, f: 14, d: 3),
  (G2: g: 15, h: 0, f: 15, d: 3),
  (G1: g: 16, h: 0, f: 16, d: 2),
}`,
    [7], `F`, `{D, G2}`, `{A, B, C, D, E, F, S}`,
    `{
  (G2, g: 14, h: 0, f: 14, d: 4),
  (J: g: 13, h: 1, f: 14, d: 3),
  (G1, g: 16, h: 0, f: 16, d: 2),
}`,
    [8], `G2`, `{}`, `{A, B, C, D, E, F, G2, S}`, table.cell(align: center + horizon, `is goal`)
  )
]

\

/ Percorso: $"S" -> "D" -> "C" -> "F" -> "G2"$
/ Costo: 5 + 3 + 2 + 4 = 14
/ Iterazioni: 1
/ Ottimalità: la soluzione è ottimale

L'algoritmo A#super[\*] è ottimale quando la funzione $h(s)$ è consistente (quindi anche ammissibile). In questo esempio l'euristica è ammissibile ma non consistente, il che non basta per avere l'ottimalità di A#super[\*].

#pagebreak()

== Euristica

Come si nota dalla tabella sotto l'euristica *è ammissibile*, perché per ogni stato $s$ vale $h(s)$ è minore o uguale al costo minimo per raggiungere un obiettivo.

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center + horizon,
    table.header(
      [$s$],
      [$h(s)$],
      [$"dist"(s)$],
      [A],
      [4],
      [13],
      [B],
      [3],
      [9],
      [C],
      [2],
      [6],
      [D],
      [4],
      [9],
      [E],
      [5],
      [7],
      [F],
      [3],
      [4],
      [G1],
      [0],
      [0],
      [G2],
      [0],
      [0],
      [J],
      [1],
      [3],
      [S],
      [7],
      [14],
    ),
  )
]

L'euristica *non è consistente*: $9 = h("A") > 4 + h("B") = 4 + 3 = 7$.

