// #import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.A.6.4 ($n$-Queens)], doc)

== Modellazione

=== Variabili

Dato $n >= 1$ siano
- $cal(N) = {1, 2, 3, ..., n}$ l'insieme dei numeri da $1$ a $n$
- $Q = { Q_(i, j) | i in cal(N) and j in cal(N)}$ l'insieme delle variabili t.c.
  - $Q_(i,j) "è vera se all'"i"-esima riga e" j"-esima colonna è presente una regina"$

=== Vincoli

- c'è almeno una regina per colonna

$
  and.big_(c in cal(N))(or.big_(r in cal(N)) Q_(r, c))
$

- c'è esattamente una regina per colonna

$
  forall j in cal(N) and.big_(c in cal(N))((and.big_(r in cal(N) and c != j) not Q_(r, c)) and Q_(j, c))
$

- c'è esattamente una regina per riga

$
  forall j in cal(N) and.big_(r in cal(N))((and.big_(c in cal(N) and c != j) not Q_(r, c)) and Q_(r, j))
$

- c'è esattamente una regina per diagonale $"NW" -> "SE"$

nella i-esima diagonale devo selezionare

// prendiamo la diagonale 0

//   1 2 3 4
// 1
// 2
// 3
// 4

// // d = 4
// 4 1
// --
// // d = 3
// 3 1
// 4 2
// --
// // d = 2
// 2 1
// 3 2
// 4 3
// --
// // d = 1
// 1 1
// 2 2
// 3 3
// 4 4
// --
// 1 2
// 2 3
// 3 4
// --
// 1 3
// 2 4
// --
// 1 4

// In realtà è questo quello che voglio! Devo dire
// $not Q_(d, d')$ tranne per quel unico pazzo scelerato j != d'
//

// NON basta d'
$
  forall d in cal(N), d' in {1, ..., n - d + 1}
$

- c'è esattamente una regina per diagonale $"NE" -> "SW"$

// - non ci sono due regine sulla stessa riga
//   - per ogni riga $r in {1, ..., n}$
//     - per ogni colonna $c in {1, ..., n}$
// $
//   not Q_(r, 1) and ... and not Q_(r, c - 1) and Q_(r, c) and not Q_(r, c + 1) and ... and not Q_(r, n)
// $

// - non ci sono due regine sulla stessa colonna
//   - per ogni riga $r in {1, ..., n}$
//     - per ogni colonna $c in {1, ..., n}$
// $
//   not Q_(1, c) and ... and not Q_(r - 1, c) and Q_(r, c) and not Q_(r + 1, c) and ... and not Q_(n, c)
// $
// - non ci sono due regine sulla stessa diagonale


// Paramentri
// - $n >= 1$ il numero di regine
// - per ogni colonna $c in {1, ..., n}$
// $
//   Q_(1, c) or Q_(2, c) or Q_(3, c) or ... or Q_(n, c)
// $
//


// per ogni riga
// - per ogni colonna nella riga
//      tirare fuori questa mega formula
// $
//   & (Q_(1, 1) and not Q_(1, 2) and not Q_(1, 3) and ... and not Q_(1, n)) or \
//   & (not Q_(1, 1) and Q_(1, 2) and not Q_(1, 3) and ... and not Q_(1, n)) or \
//   & (not Q_(1, 1) and not Q_(1, 2) and Q_(1, 3) and ... and not Q_(1, n)) or \
// $


#pagebreak()

== Istanza $n = 4$

$
  & Q = { \
    & quad Q_(1, 1), Q_(1, 2), Q_(1, 3), Q_(1, 4), \
    & quad Q_(2, 1), Q_(2, 2), Q_(2, 3), Q_(2, 4), \
    & quad Q_(3, 1), Q_(3, 2), Q_(3, 3), Q_(3, 4), \
    & quad Q_(4, 1), Q_(4, 2), Q_(4, 3), Q_(4, 4) \
    & }
$
- c'è almeno una regina per colonna

$
  & (Q_(1, 1) or Q_(2, 1) or Q_(3, 1) or Q_(4, 1)) and \
  & (Q_(1, 2) or Q_(2, 2) or Q_(3, 2) or Q_(4, 2)) and \
  & (Q_(1, 3) or Q_(2, 3) or Q_(3, 3) or Q_(4, 3)) and \
  & (Q_(1, 4) or Q_(2, 4) or Q_(3, 4) or Q_(4, 4)) \
$

- c'è esattamente una regina per colonna

$
  & (Q_(1, 1) or Q_(2, 1) or Q_(3, 1) or Q_(4, 1)) and \
  & (Q_(1, 2) or Q_(2, 2) or Q_(3, 2) or Q_(4, 2)) and \
  & (Q_(1, 3) or Q_(2, 3) or Q_(3, 3) or Q_(4, 3)) and \
  & (Q_(1, 4) or Q_(2, 4) or Q_(3, 4) or Q_(4, 4)) \
$
