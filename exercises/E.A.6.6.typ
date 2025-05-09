// #import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
#import "template.typ": *

#show: doc => conf([E.A.6.6 (Edge Colouring)], doc)

#show math.equation.where(block: true): set block(breakable: true)
#set math.equation(numbering: none)

== Modellazione

Dato un grafo non diretto $G = (V, E)$ siano
- $cal(C) = {1, 2, 3}$

- $X = { X_(u, v)^c | {u, v} in E and c in cal(C)}$ l'insieme di variabili t.c.
  - $X_(u, v)^c$ è vera se l'arco ${u, v} in E$ ha colore $c$

\

$
  & phi.alt = phi.alt_"almeno_un_colore_per_arco" and \
  & quad phi.alt_"al_più_un_colore_per_arco" and \
  & quad phi.alt_"triangoli"
$

\

$
  phi.alt_"almeno_un_colore_per_arco" & = and.big_({u, v} in E) (or.big_(c in cal(C)) X_(u, v)^c) \
  phi.alt_"al_più_un_colore_per_arco" & = and.big_({u, v} in E \ c_1 in cal(C) \ c_2 in cal(C) \ c_1 < c_2) (X_(u, v)^(c_1) -> not X_(u, v)^(c_2)) \
  phi.alt_"triangoli" & = and.big_(t in V \ u in V \ v in V \ {t, u} in E \ {u, v} in E \ {v, t} in E \ c in cal(C)) (X_(t, u)^c and X_(u, v)^c -> not X_(v, t)^c)
$

#pagebreak()

== Istanziazione

// A -> E, H, I, S
// B -> C, G2, I, J, S
// C -> B, D, G2, S
// D -> C, E, S
// E -> A, D, G1, H
// G1 -> E, H
// G2 -> B, C, J
// H -> A, E, G1, I
// I -> A, B, H
// J -> B, G2
// S -> A, B, C, D

#let E = (
  ("A", "E"),
  ("A", "H"),
  ("A", "I"),
  ("A", "S"),
  ("B", "C"),
  ("B", "G2"),
  ("B", "I"),
  ("B", "J"),
  ("B", "S"),
  ("C", "B"),
  ("C", "D"),
  ("C", "G2"),
  ("C", "S"),
  ("D", "C"),
  ("D", "E"),
  ("D", "S"),
  ("E", "A"),
  ("E", "D"),
  ("E", "G1"),
  ("E", "H"),
  ("G1", "E"),
  ("G1", "H"),
  ("G2", "B"),
  ("G2", "C"),
  ("G2", "J"),
  ("H", "A"),
  ("H", "E"),
  ("H", "G1"),
  ("H", "I"),
  ("I", "A"),
  ("I", "B"),
  ("I", "H"),
  ("J", "B"),
  ("J", "G2"),
  ("S", "A"),
  ("S", "B"),
  ("S", "C"),
  ("S", "D"),
)


// #E

//    A  B  C  D  E  1  2  H  I  J  S
// A: -  -  -  -  X  -  -  X  X  -  X
// B: -  -  X  -  -  -  X  -  X  X  X
// C: -  X  -  X  -  -  X  -  -  -  X
// D: -  -  X  -  X  -  -  -  -  -  X
// E: X  -  -  X  -  X  -  X  -  -  -
// 1: -  -  -  -  X  -  -  X  -  -  -
// 2: -  X  X  -  -  -  -  -  -  X  -
// H: X  -  -  -  X  X  -  -  X  -  -
// I: X  X  -  -  -  -  -  X  -  -  -
// J: -  X  -  -  -  -  X  -  -  -  -
// S: X  X  X  X  -  -  -  -  -  -  -

//    A  B  C  D  E  1  2  H  I  J  S
// A: -  -  -  -  X  -  -  X  X  -  X
// B: -  -  X  -  -  -  X  -  X  X  X
// C: -  X  -  X  -  -  X  -  -  -  X
// D: -  -  X  -  X  -  -  -  -  -  X
// E: X  -  -  X  -  X  -  X  -  -  -
// 1: -  -  -  -  X  -  -  X  -  -  -
// 2: -  X  X  -  -  -  -  -  -  X  -
// H: X  -  -  -  X  X  -  -  X  -  -
// I: X  X  -  -  -  -  -  X  -  -  -
// J: -  X  -  -  -  -  X  -  -  -  -
// S: X  X  X  X  -  -  -  -  -  -  -
//    A  B  C  D  E  1  2  H  I  J  S
// A: 1  1  1  1  2  1  1  1  2  1  1
// B: 1  1  1  1  1  1  1  1  1  2  2
// C: 1  1  1  2  1  1  2  1  1  1  1
// D: 1  1  2  1  1  1  1  1  1  1  1
// E: 2  1  1  1  1  2  1  1  1  1  1
// 1: 1  1  1  1  2  1  1  1  1  1  1
// 2: 1  1  2  1  1  1  1  1  1  1  1
// H: 1  1  1  1  1  1  1  1  1  1  1
// I: 2  1  1  1  1  1  1  1  1  1  1
// J: 1  2  1  1  1  1  1  1  1  1  1
// S: 1  2  1  1  1  1  1  1  1  1  1



#pagebreak()

== Codifica

=== EdgeColouringToSAT

=== SATToEdgeColouring

// #let small(t) = text(size: 0.7em, str(t))
// #let yellow = rgb("#ffbf00")
// #let yellow = rgb("#fabd2f")
// #let blue = rgb("#83a598")
// #let green = rgb("#b8bb26")
//
// #figure(caption: [soluzione generata da `MiniZinc`])[
//   #diagram(
//     node-stroke: .5pt + black,
//     node-shape: circle,
//     edge-stroke: 1pt + yellow,
//     spacing: 2em,
//     label-sep: .5pt,
//
//     node((4, 1), [*A*], name: <A>),
//     edge(<A>, <E>, "-", stroke: blue),
//     edge(<A>, <H>, "-"),
//     edge(<A>, <I>, "-", stroke: blue),
//     edge(<A>, <S>, "-"),
//
//     node((6, 1), [*B*], name: <B>),
//     edge(<B>, <C>, "-"),
//     edge(<B>, <G2>, "-"),
//     edge(<B>, <I>, "-"),
//     edge(<B>, <J>, "-", stroke: blue),
//     edge(<B>, <S>, "-", stroke: blue),
//
//     node((6, 3), [*C*], name: <C>),
//     edge(<C>, <D>, "-", stroke: blue),
//     edge(<C>, <G2>, "-", stroke: blue),
//     edge(<C>, <S>, "-"),
//
//     node((2, 3), [*D*], name: <D>),
//     edge(<D>, <E>, "-"),
//     edge(<D>, <S>, "-"),
//
//     node((1, 2), [*E*], name: <E>),
//     edge(<E>, <G1>, "-", stroke: blue),
//     edge(<E>, <H>, "-"),
//
//     node((0, 0), [*G1*], name: <G1>),
//     edge(<G1>, <H>, "-"),
//
//     node((7, 1), [*G2*], name: <G2>),
//     edge(<G2>, <J>, "-"),
//
//     node((2, 0), [*H*], name: <H>),
//     edge(<H>, <I>, "-"),
//
//     node((4, 0), [*I*], name: <I>),
//
//     node((6, 0), [*J*], name: <J>),
//
//     node((4, 2), [*S*], name: <S>),
//   )
// ]
