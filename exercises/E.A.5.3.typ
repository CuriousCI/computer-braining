#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond

#set text(font: "New Computer Modern", lang: "it", weight: "light", size: 11pt)
#set page(margin: 1.75in)
#set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
#set math.equation(numbering: "(1)")

#show figure: set block(breakable: true)
#show figure.caption: set align(center)
#show heading: set block(above: 1.4em, below: 1em)
#show outline.entry.where(level: 1): it => { show repeat : none; v(1.1em, weak: true); text(size: 1em, strong(it)) }
#show raw: set text(font:"CaskaydiaCove NFM", lang: "it", weight: "light", size: 9pt)
#show sym.emptyset : sym.diameter 

#let reft(reft) = box(width: 8pt, place(dy: -8pt, 
  box(radius: 100%, width: 9pt, height: 9pt, inset: 1pt, stroke: .5pt, // fill: black,
    align(center + horizon, text(font: "CaskaydiaCove NFM", size: 7pt, repr(reft)))
  )
))

#set heading(numbering: "1.1")
#set raw(lang: "Rust")
#set table(stroke: 0.25pt)

= E.A.5.3

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

== Modellazione (Edge Colouring)

=== Variabili e domini

Dato un grafo $G = (V, E)$ per ogni arco $(v_i, v_j) in E$ si definisce una variabile, per cui:

- $X = {C_(i, j) | (v_i, v_j) in E)}$, dove $C_(i, j)$ indica il colore dell'arco $(v_i, v_j)$
- $D = {D_(i, j) | (v_i, v_j) in E and D_(i, j) = {1, 2, 3}}$

=== Vincoli

Si ha un triancolo per ogni tripla di vertici connessi

$ 
& forall i, j, k \
& quad ((v_i, v_j) in E and (v_i, v_k) in E and (v_j, v_k) in E) ==> \
& quad quad (C_(i, j) = C_(i, k) ==> C_(i, j) != C_(j, k))
$

Se due degli archi del triangolo hanno lo stesso colore, allora il terzo deve essere diverso (per non avere archi tutti dello stesso colore). Nel grafo non diretto il verso non conta, quindi $C_(i, j) = C_(j, i)$.


== Istanziazione 

=== Variabili e domini

Dati A = 1, B = 2, C = 3, D = 4, E = 5, G1 = 6, G2 = 7, H = 8, I = 9, J = 10, S = 11; le variabili sono:

$
C_(1, 5), C_(5, 1), C_(1, 8), C_(8, 1), C_(1, 9), C_(9, 1), C_(1, 11), C_(11, 1), \
C_(2, 3), C_(3, 2), C_(2, 7), C_(7, 2), C_(2, 9), C_(9, 2), C_(2, 10), C_(10, 2), \
C_(2, 11), C_(11, 2), C_(3, 4), C_(4, 3), C_(3, 7), C_(7, 3), C_(3, 11), C_(11, 3), \
C_(4, 5), C_(5, 4), C_(4, 11), C_(11, 4), C_(5, 6), C_(6, 5), C_(5, 8), C_(8, 5), \
C_(6, 8), C_(8, 6), C_(7, 10), C_(10, 7), C_(8, 9), C_(9, 8), : [1, 3]
$

=== Vincoli

Variabili che rappresentano lo stesso arco devono avere lo stesso colore

- $angle.l {C_(1, 5), C_(5, 1)}, C_(1, 5) = C_(5, 1) angle.r$
- $angle.l {C_(1, 8), C_(8, 1)}, C_(1, 8) = C_(8, 1) angle.r$
- $angle.l {C_(1, 9), C_(9, 1)}, C_(1, 9) = C_(9, 1) angle.r$
- $angle.l {C_(1, 11), C_(11, 1)}, C_(1, 11) = C_(11, 1) angle.r$
- $angle.l {C_(2, 3), C_(3, 2)}, C_(2, 3) = C_(3, 2) angle.r$
- $angle.l {C_(2, 7), C_(7, 2)}, C_(2, 7) = C_(7, 2) angle.r$
- $angle.l {C_(2, 9), C_(9, 2)}, C_(2, 9) = C_(9, 2) angle.r$
- $angle.l {C_(2, 10), C_(10, 2)}, C_(2, 10) = C_(10, 2) angle.r$
- $angle.l {C_(2, 11), C_(11, 2)}, C_(2, 11) = C_(11, 2) angle.r$
- $angle.l {C_(3, 4), C_(4, 3)}, C_(3, 4) = C_(4, 3) angle.r$
- $angle.l {C_(3, 7), C_(7, 3)}, C_(3, 7) = C_(7, 3) angle.r$
- $angle.l {C_(3, 11), C_(11, 3)}, C_(3, 11) = C_(11, 3) angle.r$
- $angle.l {C_(4, 5), C_(5, 4)}, C_(4, 5) = C_(5, 4) angle.r$
- $angle.l {C_(4, 11), C_(11, 4)}, C_(4, 11) = C_(11, 4) angle.r$
- $angle.l {C_(5, 6), C_(6, 5)}, C_(5, 6) = C_(6, 5) angle.r$
- $angle.l {C_(5, 8), C_(8, 5)}, C_(5, 8) = C_(8, 5) angle.r$
- $angle.l {C_(6, 8), C_(8, 6)}, C_(6, 8) = C_(8, 6) angle.r$
- $angle.l {C_(7, 10), C_(10, 7)}, C_(7, 10) = C_(10, 7) angle.r$
- $angle.l {C_(8, 9), C_(9, 8)}, C_(8, 9) = C_(9, 8) angle.r$

Non esistono archi tutti dello stesso colore

- $angle.l {C_(0, 4), C_(0, 7), C_(4, 7)}, C_(0, 4) = C_(0, 7) ==> C_(0, 4) != C_(4, 7)) angle.r$
- $angle.l {C_(0, 7), C_(0, 4), C_(7, 4)}, C_(0, 7) = C_(0, 4) ==> C_(0, 7) != C_(7, 4)) angle.r$
- $angle.l {C_(0, 7), C_(0, 8), C_(7, 8)}, C_(0, 7) = C_(0, 8) ==> C_(0, 7) != C_(7, 8)) angle.r$
- $angle.l {C_(0, 8), C_(0, 7), C_(8, 7)}, C_(0, 8) = C_(0, 7) ==> C_(0, 8) != C_(8, 7)) angle.r$
- $angle.l {C_(1, 2), C_(1, 6), C_(2, 6)}, C_(1, 2) = C_(1, 6) ==> C_(1, 2) != C_(2, 6)) angle.r$
- $angle.l {C_(1, 2), C_(1, 10), C_(2, 10)}, C_(1, 2) = C_(1, 10) ==> C_(1, 2) != C_(2, 10)) angle.r$
- $angle.l {C_(1, 6), C_(1, 2), C_(6, 2)}, C_(1, 6) = C_(1, 2) ==> C_(1, 6) != C_(6, 2)) angle.r$
- $angle.l {C_(1, 6), C_(1, 9), C_(6, 9)}, C_(1, 6) = C_(1, 9) ==> C_(1, 6) != C_(6, 9)) angle.r$
- $angle.l {C_(1, 9), C_(1, 6), C_(9, 6)}, C_(1, 9) = C_(1, 6) ==> C_(1, 9) != C_(9, 6)) angle.r$
- $angle.l {C_(1, 10), C_(1, 2), C_(10, 2)}, C_(1, 10) = C_(1, 2) ==> C_(1, 10) != C_(10, 2)) angle.r$
- $angle.l {C_(2, 1), C_(2, 6), C_(1, 6)}, C_(2, 1) = C_(2, 6) ==> C_(2, 1) != C_(1, 6)) angle.r$
- $angle.l {C_(2, 1), C_(2, 10), C_(1, 10)}, C_(2, 1) = C_(2, 10) ==> C_(2, 1) != C_(1, 10)) angle.r$
- $angle.l {C_(2, 3), C_(2, 10), C_(3, 10)}, C_(2, 3) = C_(2, 10) ==> C_(2, 3) != C_(3, 10)) angle.r$
- $angle.l {C_(2, 6), C_(2, 1), C_(6, 1)}, C_(2, 6) = C_(2, 1) ==> C_(2, 6) != C_(6, 1)) angle.r$
- $angle.l {C_(2, 10), C_(2, 1), C_(10, 1)}, C_(2, 10) = C_(2, 1) ==> C_(2, 10) != C_(10, 1)) angle.r$
- $angle.l {C_(2, 10), C_(2, 3), C_(10, 3)}, C_(2, 10) = C_(2, 3) ==> C_(2, 10) != C_(10, 3)) angle.r$
- $angle.l {C_(3, 2), C_(3, 10), C_(2, 10)}, C_(3, 2) = C_(3, 10) ==> C_(3, 2) != C_(2, 10)) angle.r$
- $angle.l {C_(3, 10), C_(3, 2), C_(10, 2)}, C_(3, 10) = C_(3, 2) ==> C_(3, 10) != C_(10, 2)) angle.r$
- $angle.l {C_(4, 0), C_(4, 7), C_(0, 7)}, C_(4, 0) = C_(4, 7) ==> C_(4, 0) != C_(0, 7)) angle.r$
- $angle.l {C_(4, 5), C_(4, 7), C_(5, 7)}, C_(4, 5) = C_(4, 7) ==> C_(4, 5) != C_(5, 7)) angle.r$
- $angle.l {C_(4, 7), C_(4, 0), C_(7, 0)}, C_(4, 7) = C_(4, 0) ==> C_(4, 7) != C_(7, 0)) angle.r$
- $angle.l {C_(4, 7), C_(4, 5), C_(7, 5)}, C_(4, 7) = C_(4, 5) ==> C_(4, 7) != C_(7, 5)) angle.r$
- $angle.l {C_(5, 4), C_(5, 7), C_(4, 7)}, C_(5, 4) = C_(5, 7) ==> C_(5, 4) != C_(4, 7)) angle.r$
- $angle.l {C_(5, 7), C_(5, 4), C_(7, 4)}, C_(5, 7) = C_(5, 4) ==> C_(5, 7) != C_(7, 4)) angle.r$
- $angle.l {C_(6, 1), C_(6, 2), C_(1, 2)}, C_(6, 1) = C_(6, 2) ==> C_(6, 1) != C_(1, 2)) angle.r$
- $angle.l {C_(6, 1), C_(6, 9), C_(1, 9)}, C_(6, 1) = C_(6, 9) ==> C_(6, 1) != C_(1, 9)) angle.r$
- $angle.l {C_(6, 2), C_(6, 1), C_(2, 1)}, C_(6, 2) = C_(6, 1) ==> C_(6, 2) != C_(2, 1)) angle.r$
- $angle.l {C_(6, 9), C_(6, 1), C_(9, 1)}, C_(6, 9) = C_(6, 1) ==> C_(6, 9) != C_(9, 1)) angle.r$
- $angle.l {C_(7, 0), C_(7, 4), C_(0, 4)}, C_(7, 0) = C_(7, 4) ==> C_(7, 0) != C_(0, 4)) angle.r$
- $angle.l {C_(7, 0), C_(7, 8), C_(0, 8)}, C_(7, 0) = C_(7, 8) ==> C_(7, 0) != C_(0, 8)) angle.r$
- $angle.l {C_(7, 4), C_(7, 0), C_(4, 0)}, C_(7, 4) = C_(7, 0) ==> C_(7, 4) != C_(4, 0)) angle.r$
- $angle.l {C_(7, 4), C_(7, 5), C_(4, 5)}, C_(7, 4) = C_(7, 5) ==> C_(7, 4) != C_(4, 5)) angle.r$
- $angle.l {C_(7, 5), C_(7, 4), C_(5, 4)}, C_(7, 5) = C_(7, 4) ==> C_(7, 5) != C_(5, 4)) angle.r$
- $angle.l {C_(7, 8), C_(7, 0), C_(8, 0)}, C_(7, 8) = C_(7, 0) ==> C_(7, 8) != C_(8, 0)) angle.r$
- $angle.l {C_(8, 0), C_(8, 7), C_(0, 7)}, C_(8, 0) = C_(8, 7) ==> C_(8, 0) != C_(0, 7)) angle.r$
- $angle.l {C_(8, 7), C_(8, 0), C_(7, 0)}, C_(8, 7) = C_(8, 0) ==> C_(8, 7) != C_(7, 0)) angle.r$
- $angle.l {C_(9, 1), C_(9, 6), C_(1, 6)}, C_(9, 1) = C_(9, 6) ==> C_(9, 1) != C_(1, 6)) angle.r$
- $angle.l {C_(9, 6), C_(9, 1), C_(6, 1)}, C_(9, 6) = C_(9, 1) ==> C_(9, 6) != C_(6, 1)) angle.r$
- $angle.l {C_(10, 1), C_(10, 2), C_(1, 2)}, C_(10, 1) = C_(10, 2) ==> C_(10, 1) != C_(1, 2)) angle.r$
- $angle.l {C_(10, 2), C_(10, 1), C_(2, 1)}, C_(10, 2) = C_(10, 1) ==> C_(10, 2) != C_(2, 1)) angle.r$
- $angle.l {C_(10, 2), C_(10, 3), C_(2, 3)}, C_(10, 2) = C_(10, 3) ==> C_(10, 2) != C_(2, 3)) angle.r$
- $angle.l {C_(10, 3), C_(10, 2), C_(3, 2)}, C_(10, 3) = C_(10, 2) ==> C_(10, 3) != C_(3, 2)) angle.r$

#pagebreak()

== Codifica in MiniZinc

#[
#show raw.where(block: true): block.with(inset: 1em, width: 100%, fill: luma(254), stroke: (left: 5pt + luma(245), rest: 1pt + luma(245)))

#show regex("constraint"): set text(red)
#show regex("array"): set text(red)

```c
set of int: V = 1..11;
array [V, V] of var 1..3: C;

any: E = [|
    /* ... matrice di adiacenza del grafo, dove E[i, j] indica che c'è un arco da v_i a v_j */
|];

constraint  forall(i in V, j in V, k in V)(
    (E[k, i] /\ E[k, j] /\ E[i, j]) -> (C[k, i] == C[k, j] -> C[k, i] != C[i, j])
);

constraint  forall(i in V, j in V)(
    C[i, j] == C[j, i]
);
```
]

\

#let small(t) = text(size: 0.7em, str(t))
#let yellow = rgb("#ffbf00")
#let yellow = rgb("#fabd2f")
#let blue = rgb("#83a598")
#let green = rgb("#b8bb26")

#figure(caption: [soluzione generata da `MiniZinc`])[
#diagram(
  node-stroke: .5pt + black, 
  node-shape: circle,
  edge-stroke: 1pt + yellow,
  spacing: 2em,
  label-sep: .5pt,

  node((4, 1), [*A*], name: <A>),
  edge(<A>, <E>, "-", stroke: blue),
  edge(<A>, <H>, "-"),
  edge(<A>, <I>, "-", stroke: blue),
  edge(<A>, <S>, "-"),

  node((6, 1), [*B*], name: <B>),
  edge(<B>, <C>, "-"),
  edge(<B>, <G2>, "-"),
  edge(<B>, <I>, "-"),
  edge(<B>, <J>, "-", stroke: blue),
  edge(<B>, <S>, "-", stroke: blue),

  node((6, 3), [*C*], name: <C>),
  edge(<C>, <D>, "-", stroke: blue),
  edge(<C>, <G2>, "-", stroke: blue),
  edge(<C>, <S>, "-"),

  node((2, 3), [*D*], name: <D>),
  edge(<D>, <E>, "-"),
  edge(<D>, <S>, "-"),

  node((1, 2), [*E*], name: <E> ),
  edge(<E>, <G1>, "-", stroke: blue),
  edge(<E>, <H>, "-"),

  node((0, 0), [*G1*], name: <G1>),
  edge(<G1>, <H>, "-"),

  node((7, 1), [*G2*], name: <G2>),
  edge(<G2>, <J>, "-"),

  node((2, 0), [*H*], name: <H>),
  edge(<H>, <I>, "-"),

  node((4, 0), [*I*], name: <I>),

  node((6, 0), [*J*], name: <J>),

  node((4, 2), [*S*], name: <S>),
)
]
