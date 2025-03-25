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

= E.A.5.2

== $n$-Queens

Il problema $n$-Queens si potrebbe codificare come problema CSP nel seguente modo. 
Siano $(X, D, C)$ t.c.

- $X = {Q_1, ..., Q_n}$
- $D = {D_1, ..., D_n | D_i = {1, ..., n}}$
- vincoli (due regine non possono stare sulla stessa riga e non si possono attaccare in diagonale):
  - $"alldiff"(Q_1, ..., Q_n)$
  - $angle.l {Q_i, Q_j}, Delta angle.r$  t.c. 
    - $i != j and Delta = {(r_i, r_j) | r_i, r_j = 1, ..., n and |i - j| != |r_i - r_j|}$

== $5$-Queens

- $X = {Q_1, Q_2, Q_3, Q_4, Q_5}$
- $D = {D_1, D_2, D_3, D_4, D_5 | D_i = {1, 2, 3, 4, 5}}$
- vincoli:
  - $"alldiff"(Q_1, Q_2, Q_3, Q_4, Q_5)$
  - per le diagonali vedere l'ultima pagina...

== MiniZinc code

#[
#show raw.where(block: true): block.with(inset: 1em, width: 100%, fill: luma(254), stroke: (left: 5pt + luma(245), rest: 1pt + luma(245)))

#show regex("constraint"): set text(red)
#show regex("array"): set text(red)

```c
include "alldifferent.mzn";

int: n = 8; /* l'editor va in crash a n = 21 */
array[1..n] of var 1..n: queens;
constraint alldifferent(queens);
constraint forall(i in 1..n, j in (i + 1)..n)(
  abs(queens[j] - queens[i]) != j - i
);
```
]

Piccola nota: effettivamente il vincolo descritto in MiniZinc non è identico alla definizione in notazione matematica, andrebbe riscritto così:

#[
#show raw.where(block: true): block.with(inset: 1em, width: 100%, fill: luma(254), stroke: (left: 5pt + luma(245), rest: 1pt + luma(245)))

#show regex("constraint"): set text(red)
#show regex("array"): set text(red)

```c
include "alldifferent.mzn";

int: n = 8; /* l'editor va in crash a n = 21 */
array[1..n] of var 1..n: queens;
constraint alldifferent(queens);
constraint forall(i in 1..n, j in 1..n)(
  i != j -> abs(queens[j] - queens[i]) != abs(j - i)
);
```
]

Con $n$ = 20 l'esecuzione del primo codice dura circa 821ms, mentre l'esecuzione per la seconda versione dura circa 1s e 516ms.

#page(width: auto, height: auto)[

#set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 0em, justify: true)

I vincoli per cui le regine non si possono attaccare in diagonale

\

$angle.l {Q_1, Q_2}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

$angle.l {Q_1, Q_3}, { (1, 1), (1, 2), (1, 4), (1, 5), (2, 1), (2, 2), (2, 3), (2, 5), (3, 2), (3, 3), (3, 4), (4, 1), (4, 3), (4, 4), (4, 5), (5, 1), (5, 2), (5, 4), (5, 5) } angle.r$

$angle.l {Q_1, Q_4}, { (1, 1), (1, 2), (1, 3), (1, 5), (2, 1), (2, 2), (2, 3), (2, 4), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (4, 2), (4, 3), (4, 4), (4, 5), (5, 1), (5, 3), (5, 4), (5, 5) } angle.r$

$angle.l {Q_1, Q_5}, { (1, 1), (1, 2), (1, 3), (1, 4), (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (5, 2), (5, 3), (5, 4), (5, 5) } angle.r$

$angle.l {Q_2, Q_1}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

$angle.l {Q_2, Q_3}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

$angle.l {Q_2, Q_4}, { (1, 1), (1, 2), (1, 4), (1, 5), (2, 1), (2, 2), (2, 3), (2, 5), (3, 2), (3, 3), (3, 4), (4, 1), (4, 3), (4, 4), (4, 5), (5, 1), (5, 2), (5, 4), (5, 5) } angle.r$

$angle.l {Q_2, Q_5}, { (1, 1), (1, 2), (1, 3), (1, 5), (2, 1), (2, 2), (2, 3), (2, 4), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (4, 2), (4, 3), (4, 4), (4, 5), (5, 1), (5, 3), (5, 4), (5, 5) } angle.r$

$angle.l {Q_3, Q_1}, { (1, 1), (1, 2), (1, 4), (1, 5), (2, 1), (2, 2), (2, 3), (2, 5), (3, 2), (3, 3), (3, 4), (4, 1), (4, 3), (4, 4), (4, 5), (5, 1), (5, 2), (5, 4), (5, 5) } angle.r$

$angle.l {Q_3, Q_2}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

$angle.l {Q_3, Q_4}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

$angle.l {Q_3, Q_5}, { (1, 1), (1, 2), (1, 4), (1, 5), (2, 1), (2, 2), (2, 3), (2, 5), (3, 2), (3, 3), (3, 4), (4, 1), (4, 3), (4, 4), (4, 5), (5, 1), (5, 2), (5, 4), (5, 5) } angle.r$

$angle.l {Q_4, Q_1}, { (1, 1), (1, 2), (1, 3), (1, 5), (2, 1), (2, 2), (2, 3), (2, 4), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (4, 2), (4, 3), (4, 4), (4, 5), (5, 1), (5, 3), (5, 4), (5, 5) } angle.r$

$angle.l {Q_4, Q_2}, { (1, 1), (1, 2), (1, 4), (1, 5), (2, 1), (2, 2), (2, 3), (2, 5), (3, 2), (3, 3), (3, 4), (4, 1), (4, 3), (4, 4), (4, 5), (5, 1), (5, 2), (5, 4), (5, 5) } angle.r$

$angle.l {Q_4, Q_3}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

$angle.l {Q_4, Q_5}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

$angle.l {Q_5, Q_1}, { (1, 1), (1, 2), (1, 3), (1, 4), (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (5, 2), (5, 3), (5, 4), (5, 5) } angle.r$

$angle.l {Q_5, Q_2}, { (1, 1), (1, 2), (1, 3), (1, 5), (2, 1), (2, 2), (2, 3), (2, 4), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (4, 2), (4, 3), (4, 4), (4, 5), (5, 1), (5, 3), (5, 4), (5, 5) } angle.r$

$angle.l {Q_5, Q_3}, { (1, 1), (1, 2), (1, 4), (1, 5), (2, 1), (2, 2), (2, 3), (2, 5), (3, 2), (3, 3), (3, 4), (4, 1), (4, 3), (4, 4), (4, 5), (5, 1), (5, 2), (5, 4), (5, 5) } angle.r$

$angle.l {Q_5, Q_4}, { (1, 1), (1, 3), (1, 4), (1, 5), (2, 2), (2, 4), (2, 5), (3, 1), (3, 3), (3, 5), (4, 1), (4, 2), (4, 4), (5, 1), (5, 2), (5, 3), (5, 5) } angle.r$

]


// #let diff(i, j) = $angle.l {D_1, D_2}, delta angle.r$
// $delta = {1, ..., n} times {1, ..., n} \\  {(1, 1), (2, 2), (3, 3), (4, 4), (5, 5)}$
// $delta = { \
// quad (1, 2), (1, 3), (1, 4), (1, 5), \
// quad (2, 1), (2, 3), (2, 4), (2, 5), \
// quad (3, 1), (3, 2), (3, 4), (3, 5), \
// quad (4, 1), (4, 2), (4, 3), (4, 5), \
// quad (5, 1), (5, 2), (5, 3), (5, 4) \
// }$
// \


// - $angle.l {Q_1, Q_2}, {} angle.r$
// - Sia $delta = {(1, 2), (1, 3), (1, 4), (1, 5), (2, 1), (2, 3), (2, 4), (2, 5)}$
//   - $C = { & diff(1, 2), diff(1, 3), diff(1, 4), \ & diff(1, 5), diff(2, 1), diff(2, 2), ...) }$

// - Sia $N = {i | i in NN and 1 <= i <= n}$

//   - $C_Delta = { \ 
// quad angle.l {Q_i, Q_j}, Delta angle.r | \
// quad quad i != j and \
// quad quad Delta = {(x, y) | |i - j| != |x - y|} \
// }$

// quad quad i, j = 1, ..., n and i != j and \
// - $C = C_(!=) union C_Delta space.en t.c.$

// - $C = {D_(i,j) | i = 1, ..., n, j = 1, ..., n, i != j }$
  // - $forall Q_i, Q_j Q_i != Q_j$
  // - $D_(i, j) = angle.l {Q_i, Q_j}, Q_i != Q_j angle.r$
  // - $forall i, j |Q_i - Q_j| != |i - j|$


