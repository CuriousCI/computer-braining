#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.2.1 (PDDL: Torri di Hanoi, modelling)], doc)


== Modellazione (FOL)

L'idea è quella di partire da una modellazione ad alto livello (FOL) e trasformarla per ricavarne una specifica in PDDL _(come si fa tipicamente nella progettazione)_.

\

#align(center, image("hanoi.png", width: 20%))

\
#fol[
  - $cal(P)_"FOL"$ = { *Asse*\/1, *Disco*\/1, _asse_disco_\/2, <\/2 }
  - $phi.alt_"FOL" =$ \
    \
    ~ tipizzazione \
    ~ forall a *Asse*(a) -> not *Disco*(a) and \
    ~ forall a, d _asse_disco_(a, d) -> *Asse*(a) and *Disco*(d) and \
    ~ forall d1, d2 (d1 < d2 -> *Disco*(d1) and *Disco*(d2)) and \
    \
    ~ 1..1 \
    ~ forall d *Disco*(d) -> exists a _asse_disco_(a, d) and \
    ~ (not exists d, $alpha$, $beta$ \
    ~~ _asse_disco_($alpha$, d) and _asse_disco_($beta$, d)) and \
    \
    ~ antiriflessività \
    ~ forall d not (d < d) and \
    \
    ~ antisimmetria \
    ~ forall d1, d2 (d1 < d2) -> not (d2 < d1) and \
    \
    ~ transitività \
    ~ forall d1, d2, d3 (d1 < d2 and d2 < d3) -> d1 < d3 \
    \
    ~ totalità \
    ~ forall d1, d2 \
    ~~ (*Disco*(d1) and *Disco*(d2) and d1 != d2) -> d1 < d2 or d2 < d1
]

\
L'idea generale è molto semplice: ogni disco è associato ad un asse, ed essendoci una relazione d'ordine totale e stretta sui dischi, è possibile ricavare l'ordine dei dischi su un dato asse.

#pagebreak()

== Modellazione (PDDL)

// ~ (forall ) \

// TODO: domande da fare:
// - SAT: (i1, j), (i2, j) lecita come notazione matematica
// - SOL: come funziona in basi di dati, nel suo paper prende uno schema relazionale in FOL, ma ci sono una serie di cose che si possono fare molto fighe, ma dove pago il prezzo
// - FOL: aveva parlato di un editor per la FOL fatto da un ex studente per le basi di dati etc... ma non è che è disponibile, ma era in grado di..., perché si potrebbe fare un progetto in cui creo un editor per UML, da cui genero la FOL + la CNF che si usa per i solver da competizione + magari un progetto in cui cosa tipo tradurre da FOL

// #operation(
//   "< ",
//   args: [disco: *Disco*],
//   pre: [this != disco],
//   post: [ ],
// )

// *Naturale*\/1,

// dovrei definire l'operazione <(disco: Disco)
//
// Ok, effettivamente in FOL non solo è più semplice.. ma anche più generico!
// - è più semplice perché sto dando molte cose per scontato:
//   - sto dando per scontato che c'è un tavolo
//   - sto dando per scontato che i dischi sono posizionati nell'unico ordine possibile (tanto hanno tutti dimensione diversa), se vogliamo l'unica permutazione
//   - posso avere infiniti dischi (si limita easy)
//   - posso avere infinite pile (si limita easy)
//
// Bah, magari esplicitando i predicati posso fare qualcosa...


// Definire il dominio di pianificazione di questo problema in PDDL, definendo un opportuno insieme di simboli di predicato. Definire lo stato iniziale e quello finale per l’istanza con n = 4.

// TODO:
// - simbolo di <= sui dischi
// - anzi, mi correggo, simbolo di <
// - ok, adesso mi serve sapere su che colonna sta un certo disco
// - ma anche su che disco sta appoggiato, o per lo meno il disco più picolo su una certa colonna
// - ah, si!!!
// - basta un predicato "piùPiccolo" che si prende un disco e una colonna, e mi dice se un certo disco è il più piccolo di una certa colonna
// - Ma come posso rappresentare questo? Hmmm... magari "sta su disco"
// - Ok, ragioniamo su quela voglio che sia lo stato finale e quello iniziale, magari così ho un clue su quello che posso fare

// - $cal(P)_"FOL"$ = { *Asse*\/1, *Disco*\/1, _asse_disco_\/2, <\/2 }

#fol[
  - $cal(P)_"PDDL"$ = { \
  // ~ Asse\/1, Disco\/1, PoggiatoSu\/2, PiùGrandeDi\/2 \
  ~ *Asse*\/1, *Disco*\/1, _asse_disco_\/2, <\/2 \
  }
  - $cal(F)$ = { \
  ~ Piattaforma\/0, A\/0, B\/0, C\/0, \
  ~ $D_1$\/0, $D_2$\/0, $D_3$\/0, $D_4$\/0 \
  }
]

- *Stato iniziale:* #fol[
    \
    ~ tipizzazione \
    ~ *Asse*(A) and *Asse*(B) and *Asse*(C) and \
    ~ *Disco*($D_1$) and *Disco*($D_2$) and *Disco*($D_3$) and *Disco*($D_4$) and \
    \
    ~ relazione d'ordine stretto e totale \
    ~ ($D_1 < D_2$) and ($D_1 < D_3$) and ($D_1 < D_4$) and \
    ~ ($D_2 < D_3$) and ($D_2 < D_4$) and ($D_3 < D_4$) and \
    \
    ~ posizione iniziale \
    ~ _Su_(A, $D_1$) and _Su_(A, $D_2$) and _Su_(A, $D_3$) and _Su_(A, $D_4$)
  ]

- *Stato finale:* #fol[
    \
    ~ _Su_(C, $D_1$) and _Su_(C, $D_2$) and _Su_(C, $D_3$) and _Su_(C, $D_4$)
  ]

- *Schemi di azione:*
  - #pddl-action(
      [Azione],
      [x, y, z],
      [_Su_(t, s1) and _Su_(x, s2)],
      [_Su_(x, s1) and _Su_(t, x)],
    )

#fol-constraint([C.*Class*.ciao_come_stai], [come stai], description: [ciao come stai])

// Ok, quindi voglio partire da una modellazione in primo ordine, e poi ridurmi a quella in PDDL, altrimenti è come partire direttamente dalla progettazione e sto provando a risolvere due problemi contemporaneamente

// progettiamo due schemi di azione:
// MoveOntoBlock e MoveOntoTable ed introduciamo cost. Table

// MoveOntoBlock(b, y):
// Precond: Block(b) ∧Block(y) ∧b ̸= y ∧Clear(b) ∧Clear(y)
// Effetto:
// On(b, y) ∧¬Clear(y)∧“per ogni x per cui si aveva,
// prima dell’esecuzione dell’azione, On(b, x),
// deve essere ¬On(b, x) ∧Clear(x)”

// Stato iniziale: On(B, Table) ∧On(A, Table) ∧On(C, A) ∧Block(A) ∧
// Block(B) ∧Block(C) ∧Clear(B) ∧Clear(C)
// Obiettivo: On(A, B) ∧On(B, C) ∧On(C, Table)

// Ok, nella modellazione in FOL ci sono un po' di cose implicite

// \
// \
// PosizionatoSu($D_4$, Piattaforma, A) $and$ \
// PosizionatoSu($D_3$, $D_4$, A) $and$ \
// PosizionatoSu($D_2$, $D_3$, A) $and$ \
// PosizionatoSu($D_1$, $D_2$, A) \
// \
// PosizionatoSu
// - $cal(P) = {Tavolo}$
