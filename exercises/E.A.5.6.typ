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

== Modellazione (Cards)

=== Variabili e domini

Dati i parametri $k, n in NN$ t.c. $k >= 2, n > 0$ 

// - $D = { D_i | i in {1, ..., k n} and D_i = {1, ..., k n} }$
    // - ... pure i domini sono diversi, ma a quel punto $D$ è ordinato?

// - $"CSP"(k: NN, n: NN): (X, D, C)$
//     - precondizioni
//         - $k >= 2 and n > 0$
//     - postcondizioni
- $X = X_C union X_P$ t.c.
    - $X_C = { C_i | i in { 1, ..., k n } }$
    - $X_P = { P_i | i in { 1, ..., k n } }$
- $D = D_C union D_P$ t.c.
    - $D_C = { D_C_i | exists C_i in X_C and D_C_i = {1, ..., n} }$
    - $D_P = { D_P_i | exists P_i in X_P and D_P_i = {1, ..., k n}}$

=== Vincoli

- $C = C_"cards" union C_"pos" union space.hair "alldifferent"(P_1, ..., P_n)$ t.c.

$
& C_"cards" = { angle.l {C_r}, R angle.r | \
& quad C_r in X_C and \
& quad exists i, j \
& quad quad i in {1, ..., n} and \
& quad quad j in {1, ..., k} and \
& quad quad r = (i - 1) * k + j and \
& quad quad R = {i} \
& }
$

    
$
& C_"pos" = { angle.l {P_(r - 1), P_r}, R angle.r | \
& quad P_(r - 1) in X_P and \
& quad P_r in X_P and \
& quad exists i, j \
& quad quad i in {1, ..., n} and \
& quad quad j in {2, ..., k} and \
& quad quad r = (i - 1) * k + j and \
& quad quad R = {(x, y) | x, y in {1, ..., k * n} and y = x + C_r + 1} \
& }
$

#pagebreak()

== Istanziazione 

=== Variabili e domini

Dati $k = 2, n = 4$
- $X = X_C union X_P$ t.c.
    - $ X_C = { C_1, C_2, C_3, C_4, C_5, C_6, C_7, C_8 }$
    - $ X_P = { P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8 }$
- $D = D_C union D_P$
    - $D_C = { D_C_1, D_C_2, D_C_3, D_C_4, D_C_5, D_C_6, D_C_7, D_C_8 | D_C_i = {1, ..., n}}$
    - $D_P = { D_P_1, D_P_2, D_P_3, D_P_4, D_P_5, D_P_6, D_P_7, D_P_8 | D_P_i = {1, ..., k n}}$

=== Vincoli

- $C = C_"cards" union C_"pos" union space.hair "alldifferent"(P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8) $

$
& C_"cards" = { \
& quad angle.l {C_1}, {1} angle.r, \
& quad angle.l {C_2}, {1} angle.r, \
& quad angle.l {C_3}, {2} angle.r, \
& quad angle.l {C_4}, {2} angle.r, \
& quad angle.l {C_5}, {3} angle.r, \
& quad angle.l {C_6}, {3} angle.r, \
& quad angle.l {C_7}, {4} angle.r, \
& quad angle.l {C_8}, {4} angle.r \
& }
$

$
& C_"pos" = { \
& quad angle.l {P_1, P_2}, {(1, 2), (2, 3), (3, 4), (4, 5), (5, 6), (6, 7), (7, 8)} angle.r, \
& quad angle.l {P_3, P_4}, {(1, 3), (2, 4), (3, 5), (4, 6), (5, 7), (6, 8)} angle.r, \
& quad angle.l {P_5, P_6}, {(1, 4), (2, 5), (3, 6), (4, 7), (5, 8)} angle.r, \
& quad angle.l {P_7, P_8}, {(1, 5), (2, 6), (3, 7), (7, 8))} angle.r, \
& }
$

#pagebreak()

== Codifica in MiniZinc

#[
#show raw.where(block: true): block.with(inset: 1em, width: 100%, fill: luma(254), stroke: (left: 5pt + luma(245), rest: 1pt + luma(245)))

#show regex("constraint"): set text(red)
#show regex("array"): set text(red)

```c
include "alldifferent.mzn";

int: k = 3;
int: n = 10;

array[1..k * n] of var 1..n: cards;
array[1..k * n] of var 1..k * n: positions;

constraint forall(i in 1..n, j in 1..k)(
    cards[(i - 1) * k + j] == i
);

constraint forall(i in 0..n - 1, j in 2..k)(
    positions[i * k + j] == 
        positions[i * k + j - 1] + cards[i * k + j] + 1
);

constraint alldifferent(positions);
```
]

// ```c
// set of int: V = 1..11;
// array [V, V] of var 1..3: C;
//
// any: E = [|
//     /* ... matrice di adiacenza del grafo, dove E[i, j] indica che c'è un arco da v_i a v_j */
// |];
//
// constraint  forall(i in V, j in V, k in V)(
//     (E[k, i] /\ E[k, j] /\ E[i, j]) -> (C[k, i] == C[k, j] -> C[k, i] != C[i, j])
// );
//
// constraint  forall(i in V, j in V)(
//     C[i, j] == C[j, i]
// );
// ```
// ]
