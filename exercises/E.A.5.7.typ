#import "template.typ": *

#show: doc => conf([E.A.5.7 (Cards 2)], doc)

== Modellazione

=== Variabili e domini

Dati i parametri $({C_1, ..., C_n}, N, M, D)$, siano $(X, D, C)$ t.c.
- $X = { X_i | i = 1, ..., n } union { P_1, V, P_2 }$, dove
  - $X_i$ è la carta $C_X_i$ scelta per la posizione $i$
  - $P_1$ è la posizione del primo picco
  - $V$ è la posizione della valle
  - $P_2$ è la posizione del secondo picco
- $D = { D_l | D_l = {1, ..., n} and l = {X_1, ..., X_n, P_1, V, P_2} }$

=== Vincoli

- $C = "alldifferent"(X_1, ..., X_n) union C_"stationary" union C_"ord"$ t.c.
  - $C_"stationary" = {angle.l {P_1, V, P_2}, R angle.r | R = {(p_1, v, p_2) | p_1 < v < p_2}$

$
  & C_"ord" = {angle.l {P_1, V, P_2, X_i, X_(i + 1)}, R angle.r | \
    & quad R = { (p_1, v, p_2, x_i, x_(i + 1)) | \
      & quad quad (1 <= i < p_1 - 1 or v <= i < p_2 - 1) ==> C_x_i < C_x_(i + 1) and \
      & quad quad (p_1 <= i < v - 1 or p_2 <= i < n - 1) ==> C_x_i > C_x_(i + 1) \
      & quad } \
    & }
$

== Istanziazione

=== Variabili e domini

Siano $("Cards", N, M, D) = ({1, 1, 2, 2, 3, 3, 4}, 7, 4, 4)$ i parametri, si hanno $(X, D, C)$ t.c.
- $X = {X_1, X_2, X_3, X_4, X_5, X_6, X_7, P_1, V, P_2}$
- $D = {D_l | D_l = {1, 2, 3, 4, 5, 6, 7} and l = {X_1, X_2, X_3, X_4, X_5, X_6, X_7, P_1, V, P_2}}$

=== Vincoli

- $C = "alldifferent"(X_1, X_2, X_3, X_4, X_5, X_6, X_7) union C_"stationary" union C_"ord"$ t.c.

$
  & C_"stationary" = {angle.l {P_1, V, P_2}, { \
      & quad (1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 2, 6), (1, 2, 7), \
      & quad (1, 3, 4), (1, 3, 5), (1, 3, 6), (1, 3, 7), (1, 4, 5), \
      & quad (1, 4, 6), (1, 4, 7), (1, 5, 6), (1, 5, 7), (1, 6, 7), \
      & quad (2, 3, 4), (2, 3, 5), (2, 3, 6), (2, 3, 7), (2, 4, 5), \
      & quad (2, 4, 6), (2, 4, 7), (2, 5, 6), (2, 5, 7), (2, 6, 7), \
      & quad (3, 4, 5), (3, 4, 6), (3, 4, 7), (3, 5, 6), (3, 5, 7), \
      & quad (3, 6, 7), (4, 5, 6), (4, 5, 7), (4, 6, 7), (5, 6, 7) \
      & } angle.r}
$

\

$
  C_"ord" = { "circa 30000 valori... non vale la pena metterli tutti \n perché il vincolo guarda tutti i valori per tutte le triple \n (p1, v, p2), non solo quelle vincolate" }
$

#pagebreak()

== Codifica in MiniZinc

#[
  #show raw.where(block: true): block.with(
    inset: 1em,
    width: 100%,
    fill: luma(254),
    stroke: (left: 5pt + luma(245), rest: 1pt + luma(245)),
  )

  #show regex("constraint"): set text(red)
  #show regex("array"): set text(red)

  ```c
  include "globals.mzn";

  any: cards_values = [1, 1, 2, 2, 3, 3, 4];
  int: n = 7;
  int: m = 4;
  int: d = 4;

  array[1..n] of var 1..n: card_at_position;
  var 1..n - 2: peak_1_pos;
  var 1..n - 1: valley_pos;
  var 1..n: peak_2_pos;

  constraint (peak_1_pos < valley_pos /\ valley_pos < peak_2_pos);

  constraint alldifferent(card_at_position);

  constraint forall(i in 1..peak_1_pos - 1)(cards_values[card_at_position[i]] < cards_values[card_at_position[i + 1]]);
  constraint forall(i in peak_1_pos..valley_pos - 1)(cards_values[card_at_position[i]] > cards_values[card_at_position[i + 1]]);
  constraint forall(i in valley_pos..peak_2_pos - 1)(cards_values[card_at_position[i]] < cards_values[card_at_position[i + 1]]);
  constraint forall(i in peak_2_pos..n - 1)(cards_values[card_at_position[i]] > cards_values[card_at_position[i + 1]]);

  constraint (peak_2_pos - peak_1_pos = d);


  output ["peak 1 - " ++ show(peak_1_pos) ++ "\nvalley - " ++ show(valley_pos) ++ "\npeak 2 - " ++ show(peak_2_pos) ++ "\n"];
  output [show(cards_values[card_at_position[i]]) ++ " " | i in 1..n];
  ```
]

// & quad (1 <= i < P_1 - 1 or V <= i < P_2 - 1) ==> \
// & quad (1 <= i < P_1 - 1 or V <= i < P_2 - 1) ==> \
// & quad quad R = { j | C_j > C_X_(i + 1) }) and \

// & quad (1 <= i < P_1 - 1 or V <= i < P_2 - 1) ==> C_X_i < C_X_(i + 1) \
// & quad (1 <= i < P_1 - 1 or V <= i < P_2 - 1) ==> C_X_i < C_X_(i + 1) \
// $
// & C_"crec" = {angle.l P_1, V, P_2, X_1, ..., X_n angle.r | \
// & quad (1 <= i < P_1 - 1 or V <= i < P_2 - 1) ==> C_X_i < C_X_(i + 1) \
// & }
// $
// \
//
// $
// & C_"decr" = {angle.l P_1, V, P_2, X_1, ..., X_n angle.r | \
// & quad (P_1 <= i < V - 1 or P_2 <= i < n - 1) ==> C_X_i > C_X_(i + 1) \
// & }
// $


// == Modello
//
// // "Cards" è un insieme, ma lo posso vedere come un array ordinato, tanto l'ordine non conta, ve?
// Dati $("Cards", N, M, D)$ siano $(X, D, C)$ t.c.
// - $X = { X_i | i in {1, ..., N}}$ // dove X_i indica la posizione dell'i-esima carta
// - $D = { D_i | D_i = {1, ..., N} and i in {1, ..., N}}$
//
// // - $C_2 = {angle.l P_1, X_1, ..., X_n angle.r |  ==> C_X_i < C_X_(i + 1) }$
// // - $C_2 = {angle.l P_1, X_1, ..., X_n angle.r |  ==> C_X_i > C_X_(i + 1) }$
//
// // union { D_l | D_l = {1, ..., n} and l in {P_1, V, P_2} }$
//
//
//
// // -  $N > 0, M > 0, D > 0$
// //         - come mi salvo i valori?
// //         - posso modellare solo i picchi
// //         - e poi disporre le carte in mezzo
// //         - distanza al più $M$, altrimenti non può essere strettamente cresc/decresc (pidgeonhole principle)
// //         - global constraints?
// // - viene dato anche $"Cards"$
// // - sequenze
// //         1. strett. crescente
// //         2. strett. decrescente
// //         3. strett. crescente
// //         4. strett. deescente
// //
// // - considerazioni
// //         - all'interno di una sottosequenza tutti i valori devono essere diversi
// //         - potrei tecnicamente
// //         - i massimi locali a 3. e 4. devono essere a distanza $D$
//
//
//
// - alldifferent per le posizioni
// - mi serve un modo per definire i picchi, potrei in qualche modo usare 3 variabili, peak 1, valley 1,  peak 2 (massimi? cres, decr, cres, decr)
// - cosa deve essere vero per queste 3 variabili?
//         - intanto il loro valore è una posizione
//         - all different per i picchi
//                 - peak 1 deve lasciare 3 spazi
//                 - peak 2 ne deve lasciare 2
//                 - peak 3 ne deve lasciare 1
//         - in secondo luogo, per peak 1
//                 - il valore a sinistra è minore del suo valore
//                 - il valore a destra è minore del suo valore
//         - valley 1
//                 - il valore a sinistra è maggiore del suo valore
//                 - il valore a destra è maggiore del suo valore
//         - peak 2
//                 - il valore a sinistra è minore del suo valore
//                 - il valore a destra è minore del suo valore
// - non è detto che la distanza fra due cose sia al più 1
//
// - per ogni coppia i, j t.c i < j, trova il gruppo in cui stanno, e in base al gruppo decidi l'ordine
// - forse potrei dividere le posizioni in bucket (mah, in realtà mi bastano i divisori)
//
// - devo modellare la crescenza e decresenza in mezzo
// - e devo dire che il valore del picco 1 e del picco 2 ha una certa distanza (decisa da D)
// - come posso usare M e N?
// - Se $D > M$ c'è un problema, perché deve essere strettamente crescente

