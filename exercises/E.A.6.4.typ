#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.A.6.4 ($n$-Queens)], doc)

== Modellazione

Paramentri
- $n >= 1$ il numero di regine

Sia $Q = { Q_(i, j) | i in {1, ..., n} and j in {1, ..., n}}$ l'insieme delle variabili t.c.
- $Q_(i,j) "è vera se all'"i"-esima riga e alla" j"-esima colonna è presente una regina"$

Bisogna imporre 3 tipologie di vincoli

- non ci sono due regine sulla stessa riga
  - per ogni riga $r in {1, ..., n}$
    - per ogni colonna $c in {1, ..., n}$
$
  not Q_(r, 1) and ... and not Q_(r, c - 1) and Q_(r, c) and not Q_(r, c + 1) and ... and not Q_(r, n)
$

// per ogni riga
// - per ogni colonna nella riga
//      tirare fuori questa mega formula
// $
//   & (Q_(1, 1) and not Q_(1, 2) and not Q_(1, 3) and ... and not Q_(1, n)) or \
//   & (not Q_(1, 1) and Q_(1, 2) and not Q_(1, 3) and ... and not Q_(1, n)) or \
//   & (not Q_(1, 1) and not Q_(1, 2) and Q_(1, 3) and ... and not Q_(1, n)) or \
// $

- non ci sono due regine sulla stessa colonna
  - per ogni riga $r in {1, ..., n}$
    - per ogni colonna $c in {1, ..., n}$
$
  not Q_(r, 1) and ... and not Q_(r, c - 1) and Q_(r, c) and not Q_(r, c + 1) and ... and not Q_(r, n)
$
- non ci sono due regine sulla stessa diagonale


