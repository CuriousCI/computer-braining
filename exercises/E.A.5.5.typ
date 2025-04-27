#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
#import "template.typ": *

#show: doc => conf([E.A.5.5 (Backtracking and Propagation)], doc)

#let yellow = rgb("#fabd2f")
#let blue = rgb("#83a598")
#let green = rgb("#b8bb26")

Sia dato $(X, D, C)$ con:
- $X = {X_1, X_2, X_3, X_4, X_5}$
- $D_1 = ... = D_5 = {1, 2, 3, 4, 5}$
- $C = {C_1, C_2, C_3, C_4, C_5}$
  - $C_1: X_1 > X_3$
  - $C_2: X_2 <= X_3$
  - $C_3: X_3^2 + X_4^2 <= 15$
  - $C_4: X_5 >= 3$
  - $C_5: X_1 + X_5 >= 3$

== Node Consistency

#columns[
  - $D_1 = {1, 2, 3, 4, 5}$
  - $D_2 = {1, 2, 3, 4, 5}$
  - $D_3 = {1, 2, 3, 4, 5}$
  - $D_4 = {1, 2, 3, 4, 5}$
  - $D_5 = {3, 4, 5}$
    - rimossi i valori ${1, 2}$ e il vincolo $C_4$

  #colbreak()

  - $C_1: X_1 > X_3$
  - $C_2: X_2 <= X_3$
  - $C_3: X_3^2 + X_4^2 <= 15$
  - $C_5: X_1 + X_5 >= 3$
]

== GAC-3

0. $Q = { (X_1, C_1), (X_3, C_1), (X_2, C_2), (X_3, C_2), (X_3, C_3), (X_4, C_3), (X_1, C_5), (X_5, C_5) }$

1. $Q = { (X_3, C_1), (X_2, C_2), (X_3, C_2), (X_3, C_3), (X_4, C_3), (X_1, C_5), (X_5, C_5) } quad quad$
  - $(X_1, C_1)$
  - $D_1 = {2, 3, 4, 5}$, rimosso 1
  - coppie aggiunte: ${(X_5, C_5)}$

2. $Q = { (X_2, C_2), (X_3, C_2), (X_3, C_3), (X_4, C_3), (X_1, C_5), (X_5, C_5) }$
  - $(X_3, C_1)$
  - $D_3 = {1, 2, 3, 4}$, rimosso 5
  - coppie aggiunte: ${(X_2, C_2), (X_4, C_3)}$

3. $Q = { (X_3, C_2), (X_3, C_3), (X_4, C_3), (X_1, C_5), (X_5, C_5) }$
  - $(X_2, C_2)$
  - $D_2 = {1, 2, 3, 4}$, rimosso 5
  - coppie aggiunte: $emptyset$

4. $Q = { (X_3, C_3), (X_4, C_3), (X_1, C_5), (X_5, C_5) }$
  - $(X_3, C_2)$
  - $D_3 = {1, 2, 3, 4}$, nessuna rimozione
  - non vanno aggiunte coppie a $Q$

5. $Q = { (X_4, C_3), (X_1, C_5), (X_5, C_5) }$
  - $(X_3, C_3)$
  - $D_3 = {1, 2, 3}$, rimosso 4
  - coppie aggiunte : ${(X_1, C_1), (X_2, C_2)}$

6. $Q = { (X_1, C_5), (X_5, C_5), (X_1, C_1), (X_2, C_2) }$
  - $(X_4, C_3)$
  - $D_4 = {1, 2, 3}$, rimossi ${4, 5}$
  - coppie aggiunte: $emptyset$

7. $Q = { (X_5, C_5), (X_1, C_1), (X_2, C_2) }$
  - $(X_1, C_5)$
  - $D_1 = {2, 3, 4, 5}$, nessuna rimozione
  - non vanno aggiunte coppie a $Q$

8. $Q = { (X_1, C_1), (X_2, C_2) }$
  - $(X_5, C_5)$
  - $D_5 = {3, 4, 5}$, nessuna rimozione
  - non vanno aggiunte coppie a $Q$

9. $Q = { (X_2, C_2) }$
  - $(X_1, C_1)$
  - $D_1 = {2, 3, 4, 5}$, nessuna rimozione
  - non vanno aggiunte coppie a $Q$

10. $Q = emptyset$
  - (X_2, C_2)
  - $D_2 = {1, 2, 3}$, rimosso 4
  - copppie aggiunte: $emptyset$

\

#columns[
  - $D_1 = {2, 3, 4, 5}$
  - $D_2 = {1, 2, 3}$
  - $D_3 = {1, 2, 3}$
  - $D_4 = {1, 2, 3}$
  - $D_5 = {3, 4, 5}$

  #colbreak()

  - $C_1: X_1 > X_3$
  - $C_2: X_2 <= X_3$
  - $C_3: X_3^2 + X_4^2 <= 15$
  - $C_5: X_1 + X_5 >= 3$
]

// usare l’euristica Minimum Remaining Values per scegliere la prossima variabile da
// assegnare (in caso di pareggi, applicare l’euristica “max-degree”; in caso di ulteriori
// pareggi, scegliere la variabile minimale nell’ordinamento scritto per le variabili);

// usare l’euristica del valore meno vincolante per la scelta dei valori (in caso di
// pareggi, scegliere il valore minimale nell’ordinamento scritto per i valori di dominio);

// usare Forward Checking per effettuare la propagazione dei vincoli, contrassegnando
// i nodi dell’albero potati con “FC”.

// #pagebreak()

== Iper-grafo dei vincoli

// max-degree in generale nel grafo, o escludendo le variabili già assegnate + bonus scelgo X_2

\

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 1em,
    label-sep: .5pt,

    node((2cm, 0cm), $X_1$, name: <X1>),
    node((4cm, 1cm), $X_2$, name: <X2>),
    node((3cm, 3cm), $X_3$, name: <X3>),
    node((1cm, 3cm), $X_4$, name: <X4>),
    node((0cm, 1cm), $X_5$, name: <X5>),

    edge(<X1>, <X3>, $C_1$, "-"),
    edge(<X2>, <X3>, $C_2$, "-"),
    edge(<X3>, <X4>, $C_3$, "-"),
    edge(<X1>, <X5>, $C_5$, "-"),
  )
]

#pagebreak()


== Backtracking

\

#align(center)[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    mark-scale: 150%,
    spacing: 4em,
    label-sep: .5pt,

    node((0, -1), [$emptyset$], name: <empty>),

    edge(<empty>, <X311>, [], "-|>"),

    // TODO empty assignment
    node((0, 0), [$X_3 = 1$ \ i = 1], name: <X311>),

    node((0, 1), [$X_2 = 1$ \ i = 2], name: <X212>),
    node((1, 1), [$X_2 = 2$ \ i = 2], name: <X222>, stroke: blue),
    node((2, 1), [$X_2 = 3$ \ i = 2], name: <X232>, stroke: blue),

    edge(<X311>, <X212>, [], "-|>"),
    edge(<X311>, <X222>, [], "-", stroke: blue),
    edge(<X311>, <X232>, [], "-", stroke: blue),

    node((0, 2), [$X_4 = 1$ \ i = 3], name: <X413>),
    edge(<X212>, <X413>, [], "-|>"),

    node((0, 3), [$X_5 = 3$ \ i = 4], name: <X534>),
    edge(<X413>, <X534>, [], "-|>"),

    node((0, 4), [$X_1 = 2$ \ i = 5], name: <X125>),
    edge(<X534>, <X125>, [], "-|>"),
  )
]

#pagebreak()

- i: 1
  - $X_3 = 1 <-$
    - $|D_1| = 4$
    - $|D_2| = 1$
    - $|D_4| = 3$
  - $X_3 = 2$
    - $|D_1| = 3$
    - $|D_2| = 2$
    - $|D_4| = 3$
  - $X_3 = 3$
    - $|D_1| = 2$
    - $|D_2| = 3$
    - $|D_4| = 2$

  - FC
    - $D_1 = {2, 3, 4, 5}$
    - $D_2 = {1}$
    - $D_4 = {1, 2, 3}$
    - $D_5 = {3, 4, 5}$

- i: 2
  - $X_2 = 1 <-$
  - FC
    - $D_1 = {2, 3, 4, 5}$
    - $D_4 = {1, 2, 3}$
    - $D_5 = {3, 4, 5}$

- i: 3
  - $X_4 = 1 <-$ (tutti i valori sono equamente vincolanti)
  - FC
    - $D_1 = {2, 3, 4, 5}$
    - $D_5 = {3, 4, 5}$

- i: 4
  - $X_5 = 3 <-$ (tutti i valori sono equamente vincolanti)
  - FC
    - $D_1 = {2, 3, 4, 5}$

- i: 5
  - $X_1 = 2 <-$ (tutti i valori sono equamente vincolanti)

assegnamento finale: ${X_1 = 2, X_2 = 1, X_3 = 1, X_4 = 1, X_5 = 3}$
