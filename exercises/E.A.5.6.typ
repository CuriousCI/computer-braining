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

$"CSP"(k >= 2, n > 0): (X, D, C)$

- $X = X_C union X_P$ t.c.
    - $X_C = { C_i | i in { 1, ..., k n } }$
    - $X_P = { P_i | i in { 1, ..., k n } }$
- $D = D_C union D_P$ t.c.
    - $D_C = { D_C_i | exists C_i in X_C and D_C_i = {1, ..., k n} }$
    - $D_P = { D_P_i | exists P_i in X_P and D_P_i = {1, ..., n}}$
- $C = C_"cards" union C_"pos" union "alldifferent"(P_1, ..., P_n)$ t.c.
    - $C_"cards" = { angle.l {C_i}, R angle.r | exists i, j}$
    - $C_"pos" = { angle.l {}, R angle.r }$
    
// $
// & C_"pos" = { angle.l {P_i, P_j}, R angle.r | \
// & quad R = {} \
// & }
// $ 

// variabili pre-impostate per i colori? Eh sì, ci tocca
// constraint forall(i in 1..n, j in 1..k)(cards[(i - 1) * k + j] == i);
//
// constraint forall(i in 0..n - 1, j in 2..k)(positions[i * k + j] == positions[i * k + j - 1] + cards[i * k + j] + 1);

=== Vincoli

// Si ha un triancolo per ogni tripla di vertici connessi
//
// $ 
// & forall i, j, k \
// & quad ((v_i, v_j) in E and (v_i, v_k) in E and (v_j, v_k) in E) ==> \
// & quad quad (C_(i, j) = C_(i, k) ==> C_(i, j) != C_(j, k))
// $
//
// Se due degli archi del triangolo hanno lo stesso colore, allora il terzo deve essere diverso (per non avere archi tutti dello stesso colore). Nel grafo non diretto il verso non conta, quindi $C_(i, j) = C_(j, i)$.


== Istanziazione 

=== Variabili e domini

Dati $k = 2, n = 4$
- $X = { C_1, C_2, C_3, C_4, C_5, C_6, C_7, C_8, P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8}$
- $D = { D_C_1, D_C_2, D_C_3, D_C_4, D_C_5, D_C_6, D_C_7, D_C_8,      }$

// Dati A = 1, B = 2, C = 3, D = 4, E = 5, G1 = 6, G2 = 7, H = 8, I = 9, J = 10, S = 11; le variabili sono:
//
// $
// C_(1, 5), C_(5, 1), C_(1, 8), C_(8, 1), C_(1, 9), C_(9, 1), C_(1, 11), C_(11, 1), \
// C_(2, 3), C_(3, 2), C_(2, 7), C_(7, 2), C_(2, 9), C_(9, 2), C_(2, 10), C_(10, 2), \
// C_(2, 11), C_(11, 2), C_(3, 4), C_(4, 3), C_(3, 7), C_(7, 3), C_(3, 11), C_(11, 3), \
// C_(4, 5), C_(5, 4), C_(4, 11), C_(11, 4), C_(5, 6), C_(6, 5), C_(5, 8), C_(8, 5), \
// C_(6, 8), C_(8, 6), C_(7, 10), C_(10, 7), C_(8, 9), C_(9, 8), : [1, 3]
// $

=== Vincoli

- $C = C_"diff" union C_"col" union C_"pos"$
- $C_"diff" = "alldifferent"(P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8)$
- $C_"col" = {}$
- $C_"pos" = {}$

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
