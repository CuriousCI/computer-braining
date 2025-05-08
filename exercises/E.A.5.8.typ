#import "template.typ": *

#show: doc => conf([E.A.5.8 (Social Golfers)], doc)

== Modellazione

Dati i parametri $P, W, G$ siano

- $S = (|P|) / G$
- $cal(W) = {1, 2, ..., W}$
- $cal(G) = {1, 2, ..., G}$
- $cal(S) = {1, 2, ..., S}$
- $cal(P) = {1, 2, ..., |P|}$, per cui ad ogni socio è assegnato un $id$ da $1$ a $|P|$

E sia $(X, D, C)$ l'istanza parametrica di CSP t.c.

$
  X = { X_(w, g, p) | w in cal(W) and g in cal(G) and p in cal(S)}
$

Dove $X_(w, g, p)$ è l'id del socio in posizione $p$, nel gruppo $g$ alla $w$-esima settimana

$
  D = { D_X_(w, g, p) | D_X_(w, g, p) = cal(P)}
$

Poiché in ogni settimana, in ogni gruppo e in ogni posizione ci può essere uno qualsiasi dei giocatori.

$ C = union.big_(i = 1)^4 C_i "dove" $

Un socio non può comparire in più gruppi nella stessa settimana, e deve comparire in almeno un gruppo.

$
  C_1 = {"alldifferent"(X_(w, g, s)) | w in cal(W)}
$

All'interno di un gruppo l'ordine non conta, quindi per semplificare e fare symmetry breaking si accetta solo la permutazione in cui i soci sono ordinati per $id$.

$
  & C_2 = { \
    & quad angle.l { X_(w, g, p), X_(w, g, p + 1)}, X_(w, g, p) < X_(w, g, p + 1) angle.r | \
    & quad w in cal(W) and g in cal(G) and p in cal(S) \
    & }
$

L'ordine fra i gruppi non conta, quindi si accetta solo la permutazione in cui i gruppi sono ordinati usando l'$id$ del primo socio nel gruppo.

$
  & C_3 = { \
    & quad angle.l { X_(w, g, 1), X_(w, g + 1, 1)}, X_(w, g, 1) < X_(w, g + 1, 1) angle.r | \
    & quad w in cal(W) and g in cal(G) \
    & }
$

#pagebreak()

Se una coppia di soci ha giocato insieme nella settimana $w'$ e nel gruppo $g'$, non c'è una settimana $w''$ successiva a $w'$, e non c'è un gruppo $g''$ nella settimana $w''$ in cui questi due soci giocano nuovamente insieme.

$
  & C_4 = { \
    & quad angle.l \
    & quad quad {X_(w', g', i'), X_(w', g', j'), X_(w'', g'', i''), X_(w'', g'', j'')}, \
    & quad quad X_(w', g', i') = X_(w'', g'', i'') -> X_(w', g', j') != X_(w'', g'', j'') \
    & quad angle.r | \
    & quad quad w' in cal(W) and w'' in cal(W) and w' < w'' and \
    & quad quad g' in cal(G) and g'' in cal(G) and \
    & quad quad i' in cal(S) and j' in cal(S) and i' < j' and \
    & quad quad i'' in cal(S) and j'' in cal(S) and i'' < j'' \
    & }
$

#pagebreak()

== Istanziazione

#set math.equation(numbering: none)
#show math.equation.where(block: true): set block(breakable: true)

#let P = 9;
#let W = 4;
#let G = 3;
#let S = int(P / G);

Dati i parametri $P = #P, W = #W, G = #G$ quindi $S = #S$, si hanno $(X, D, C)$ t.c.

$
  & X = { \
    #for w in range(1, W + 1) [
      $& quad$
      #for g in range(1, G + 1) [
        #for p in range(1, S + 1) [ $X_(#w, #g, #p),$ ]
      ] \
    ]
  }
$

\

$
  & D = { D_X_(w, g, p) = {1, 2, 3, 4, 5, 6, 7, 8, #P} | w in {1, ..., #W} and g in {1, ..., #G} and p in {1, ..., #S} }\
$

\

$
  C = union.big_(i = 1)^4 C_i
$

\

$
  & C_1 = { \
    #for w in range(1, W + 1) [
      $& quad "alldifferent"(X_(#w, g, p)),$ \
    ]
    & }
$

\

$
  & C_2 = { \
    #for w in range(1, W + 1) [
      #for g in range(1, G + 1) [
        #for p in range(1, S) [
          $& quad angle.l {X_(#w, #g, #p), X_(#w, #g, #{ p + 1 })}, X_(#w, #g, #p) < X_(#w, #g, #{ p + 1 }) angle.r,$
        ] \
      ]
    ]
    & }
$

\

$
  & C_3 = { \
    #for w in range(1, W + 1) [
      #for g in range(1, G + 1) [
        $& quad angle.l {X_(#w, #g, 1), X_(#w, #{ g + 1 }, 1)}, X_(#w, #g, 1) < X_(#w, #{ g + 1 }, 1) angle.r,$

      ] \
    ]
    & }
$

\

$
  & C_4 = { \
    #for w1 in range(1, W + 1) [
      #for w2 in range(w1 + 1, W + 1) [
        #for g1 in range(1, G + 1) [
          #for g2 in range(1, G + 1) [
            #for i1 in range(1, S + 1) [
              #for j1 in range(i1 + 1, S + 1) [
                #for i2 in range(2, S + 1) [
                  #for j2 in range(i2 + 1, S + 1) [
                    $& quad angle.l {X_(#w1, #g1, #i1), X_(#w1, #g1, #j1)X_(#w2, #g2, #i2)X_(#w2, #g2, #j2)}, X_(#w1, #g1, #i1) = X_(#w2, #g2, #i2) -> X_(#w1, #g1, #j1) != X_(#w2, #g2, #j2) angle.r$
                  ]
                ] \
              ]
            ]
          ]
        ]
      ]
    ]
    & }
$

#pagebreak()

== Codifica MiniZinc

#minizinc[
  ```c
  include "globals.mzn";

  int: card_P = 9;
  int: W = 4;
  int: G = 3;
  int: S = card_P div G;

  array[1..W, 1..G, 1..S] of var 1..card_P: X;

  constraint forall(w in 1..W)(
    alldifferent([X[w,g,p] | g in 1..G, p in 1..S])
  );

  constraint forall(w in 1..W, g in 1..G, p in 1..S - 1)(
    X[w,g,p] < X[w,g,p+1]
  );

  constraint forall(w in 1..W, g in 1..G - 1)(
    X[w,g,1] < X[w, g+1, 1]
  );

  constraint forall(w1 in 1..W, w2 in w1 + 1..W, g1 in 1..G, g2 in 1..G, i1 in 1..S, j1 in i1 + 1..S, i2 in 1..S, j2 in i2 + 1..S)(
    X[w1, g1, i1] = X[w2, g2, i2] -> X[w1, g1, j1] != X[w2, g2, j2]
  );

  output [
    "week " ++ show(w) ++ ": | " ++ concat(
       [concat([show_int(-2, X[w, g, p]) ++ " " | p in 1..S]) ++ "| " | g in 1..G]
     ) ++ "\n" | w in 1..W
  ];
  ```
]

// int: card_P = 24;
// int: W = 8;
// int: G = 8;


// Vincoli?
//
// - dentro a tutti i gruppi di una certa settimana i giocatori devono essere tutti diversi!

// ok, non basta, perché a questo punto $X$ è un insieme di valori, ma non posso avere un insieme di valori, ma non posso avere domini che sono insiemi (lol, che razza di dominio è???), a questo punto mi serve


// - $P$ soci
// - $W$ settimane
// - $G$ gruppi
// - $S = (|P|) / G$


// Siano
// - $cal(G) = {1, ..., G}$
// - $cal(W) = {1, ..., W}$
// - $cal(S) = {1, ..., S}$
// - $cal(P) = {1, ..., |P|}$


// Si vuole incrementare la socialità (si vuole fare in modo che ogni coppia di soci giochi nello stesso gruppo al più una volta)
//
// Ok, potrei aver bisogno di identificare i soci, quindi definisco
// - $P = {1, ..., n}$
// - Il mio output dovrebbe essere una cosa tipo $G dot.c W$ insiemi:
//   - per ogni settimana devo dire quali sono i gruppi
//   - in una data settimana ci sono $G$ gruppi, tutti di dimensione $S$
//
//   - vincolo, una cosa del tipo:
//     - data la settimana $i$, non esiste un gruppo nelle settimane \
//       $i < j <= W$ per cui due giocatori di quel gruppo stanno in uno dei gruppi successivi

// - ok, e a questo punto?
//
// "ho bisogno di 2 coppie di soci?, in qualche modo x e y identificano il socio?"
// $
//   C_2 = {angle.l {X_(w, i, x), X_(w, j, y), X_(w, i, x), X_(w, j, y) }, angle.r | \
//     w in cal(W) and i in cal(G) and j in cal(G) and i < j}
// $
//
// - magari un socio, se stava nel gruppo 1 la settimana 1, non può stare nel gruppo nella settimana 2? Questo non funziona, perché non impedisce che non giochi con lo stesso giocatore
// - in più lui potrebbe rimanere nel gruppo 1, e si spostano tutti gli altri
//
// - ma scusate un attimo, non posso vedere come una settimana come una permutazione dei soci, quindi ho una funzione tipo $f : cal(P) -> P$ suriettiva e iniettiva, e a quel punto basta un alldifferent sulla permutazione; e per controllare il vincolo, controllo i bordi o una cosa del genere; tanto devo sempre paragonare con la settimana successiva
//
// Ok, come posso eliminare il problema delle permutazioni?
// - posso stabilire un ordine, magico magico, del tipo il giocatore i sta sempre prima del giocatore j? NO
// - posso gestirlo come dei set di gruppi dove l'ordine non conta? Boh, non saprei... devo aggiungere sovrastruttura
// - non posso fissare certi giocatori in dei gruppi? No perché a quel punto non si incontreranno mai
// - array of sets of variables?
// - allora: all'interno del singolo set posso dire che i giocatori sono ordinati
//   - BONUS: posso dire che i singoli set sono ordinati fra di loro, quindi solo la permutazione ordindata è lecita (ma come mi assicuro di non elimnare soluzioni?)
//   - beh, se uno ci pensa, in realtà basta dire che il primo è ordinato, tanto c'è un bel vincolo di alldifferent
//
// Ma a questo punto, no, non la posso esplorare l'idea dei bordi? Non basta dire $i dot.c s$ per determinare l'$i$-esimo bordo?
//
// Quindi ho delle sante permutazioni, e mi serve un modo nice per dire "il primo giocatore sta nel primo insieme, o sta nel secondo, o sta nel terzo, o sta nel quarto, o sta nel quinto, o sta nel sesto"
// - beh, prendo il giocatore $i$, e il giocatore $j$, se entrambi $b_1 < i < j < b_2$, allora nei prossimi turni non è possibile nuovamente $b_1 i < b_2 and b_1 < j < b_2$
//
// ci sono tante combinazioni in cui il primo sta nel primo, quindi non sto facendo particolari danni
//
// A questo punto voglio una funzione del tipo
//
// $
//   f : {1, ..., P} -> {1, ..., P}
// $
//
// che ad ogni socio mi assegna una posizione NO!!! \
// voglio il contrario: una funzione che ad ogni posizione mi assegna un socio (a.k.a. permutazione)
//
// Quindi, per ogni settimana io ho questo bel array. Ma, matematicamente, è più facile accedere con 2 variabili, o con una e poi usare il divisore? Mi sa che matematicamente lo faccio con due variabili, e poi in MiniZinc lo faccio con un array.
// - beh, sono un cavolo di genio, ci avevo già pensato ieri
//
// Ok, abbiamo la symmetry breaking, a questo punto ci divertiamo con un mega vincolo
//
// - prendi due settimane $w' < w''$
//   - a questo punto per ogni gruppo in $w'$, e per ogni gruppo in $w''$
//   - supponiamo $g'$ e $g''$
//     - ora ci divertiamo, prendiamo tutte le coppie $i' < j'$ in $w', g'$
//     - e prendiamo tutte le coppie $i'' < j''$ in $w'', g''$
//       - ora basta dire che $i' != i'' and j' != j''$ (non gli indici di per se, quanto i gicatori associati a quegli indici
//       - ok, forse no, magari il vincolo non è proprio questo

