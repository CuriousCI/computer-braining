#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.2.1 (PDDL: Torri di Hanoi, modelling)], doc)

#set highlight(fill: rgb("fbf1c7bb"))

== Modellazione (FOL)

L'idea è quella di partire da una modellazione ad alto livello (FOL) e trasformarla per ricavarne una specifica in PDDL _(come si fa tipicamente nella progettazione)_.

\

#align(center, image("hanoi.png", width: 40%))

\

#operation(
  [ordine_dischi],
  type: [(*Intero* > 0, *Disco*) [0..\*]],
  description: [l'ordine di inserimento dei dischi su un asse è dato dalla relazione $<$ su #fol[*Disco*]],
  post: [
    exists dischi_asse \
    ~ dischi_asse = { disco | _asse_disco_(this, disco) } -> \
    ~~ result = sorted(dischi_asse, $<$)
  ],
)

#let comment(body) = text(luma(150), body)

#fol[
  - $cal(P)_"FOL"$ = { *Asse*\/1, *Disco*\/1, _asse_disco_\/2, <\/2 }
  - $phi.alt_"FOL" =$ \

    ~ #comment[- invariante tipi]
    ~ forall a *Asse*(a) -> not *Disco*(a) and \
    ~ forall a, d _asse_disco_(a, d) -> *Asse*(a) and *Disco*(d) and \
    ~ forall d1, d2 (d1 < d2 -> *Disco*(d1) and *Disco*(d2)) and \

    ~ #comment[- 1..1]
    ~ forall d *Disco*(d) -> exists a _asse_disco_(a, d) and \
    ~ (not exists d, $alpha$, $beta$ \
    ~~ _asse_disco_($alpha$, d) and _asse_disco_($beta$, d)) and \

    ~ #comment[- relazione <]

    ~ #comment[- antiriflessività]
    ~ forall $delta$ not ($delta$ < $delta$) and \

    ~ #comment[- antisimmetria]
    ~ forall $delta$, $gamma$ ($delta$ < $gamma$) -> not ($gamma$ < $delta$) and \

    ~ #comment[- transitività]
    ~ forall $delta$, $gamma$, $eta$ ($delta$ < $gamma$ and $gamma$ < $eta$) -> $delta$ < $eta$ and \

    ~ #comment[- totalità]
    ~ forall $delta$, $gamma$ (*Disco*($delta$) and *Disco*($gamma$) and $delta$ != $gamma$) -> $delta$ < $gamma$ or $gamma$ < $delta$
]

== Modellazione (PDDL)

Si modifica il predicato #fol[_asse_disco_] in #fol[_asse_ord_disco_] in modo da tenere conto dell'operazione #fol[ordine_dischi()], modellando sostanzialmente ogni asse come una *stack*, e si tiene traccia dell'elemento *top* tramite la relazione #fol[_minore_]. La stack è *vuota* quando l'elemento #fol[_minore_] è #fol[Tavolo].

#fol[
  - $cal(P)_"PDDL"$ = \
  ~ { *Asse*\/1, *Disco*\/1, <\/2 } $union$ \
  ~ { _asse_ord_disco_\/3, _minore_\/2 }

  - $cal(F)_"PDDL"$ = { \
  ~ Tavolo\/0, A\/0, B\/0, C\/0, \
  ~ $D_1$\/0, $D_2$\/0, $D_3$\/0, $D_4$\/0 \
  }
]

- *Stato iniziale:* #fol[
    \
    ~ #comment[- invariante tipi]
    ~ *Asse*(A) and *Asse*(B) and *Asse*(C) and \
    ~ *Disco*($D_1$) and *Disco*($D_2$) and *Disco*($D_3$) and *Disco*($D_4$) and

    ~ #comment[- relazione <]
    ~ ($D_1 < D_2$) and ($D_1 < D_3$) and ($D_1 < D_4$) and \
    ~ ($D_2 < D_3$) and ($D_2 < D_4$) and ($D_3 < D_4$) and

    ~ #comment[- posizione iniziale + ordine_dischi()]
    ~ _asse_ord_disco_(A, $D_1$, $D_2$) and _asse_ord_disco_(A, $D_2$, $D_3$) and \
    ~ _asse_ord_disco_(A, $D_3$, $D_4$) and _asse_ord_disco_(A, $D_4$, Tavolo) and \
    ~ _minore_(B, Tavolo) and _minore_(C, Tavolo) and _minore_(A, $D_1$)
  ]

- *Stato finale:* #fol[
    \
    ~ #comment[- posizione finale + ordine_dischi()]
    ~ _asse_ord_disco_(C, $D_1$, $D_2$) and _asse_ord_disco_(C, $D_2$, $D_3$) and \
    ~ _asse_ord_disco_(C, $D_3$, $D_4$) and _asse_ord_disco_(C, $D_4$, Tavolo) and \
    ~ _minore_(A, Tavolo) and _minore_(B, Tavolo) and _minore_(C, $D_1$)
  ]

#page(height: auto)[
  === Schemi di azione

  // Si potrebbero definire delle "operazioni d'appoggio" o "operazioni ausiliarie" posso invocare solo io nella specifica, tipo "push" e "pop"
  // che posso riusare al posto di fare sempre le stesse cose

  #box(width: 150%)[
    #pddl-action(
      [SpostaSuDiscoDaDisco],
      [
        \
        ~ disco, \
        ~ disco_sottostante, \
        ~ disco_minore_asse_di_arrivo, \
        ~ asse_di_partenza, \
        ~ asse_di_arrivo \
      ],
      [
        #comment[- tipi]
        *Disco*(disco) and *Disco*(disco_sottostante) and \
        *Disco*(disco_minore_asse_di_arrivo) and \
        *Asse*(asse_di_partenza) and *Asse*(asse_di_arrivo) \
        disco < disco_minore_asse_di_arrivo and

        \
        _asse_ord_disco_(asse_di_partenza, disco, disco_sottostante) and \
        _minore_(asse_di_partenza, disco) and \
        _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) \
        \
      ],
      [
        #comment[- disco = pop(asse_di_partenza)]
        not _asse_ord_disco_(asse_di_partenza, disco, disco_sottostante) and \
        not _minore_(asse_di_partenza, disco) and \
        not _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) and \

        \
        #comment[- push(asse_di_arrivo, disco)]
        _asse_ord_disco_(asse_di_arrivo, disco, disco_minore_asse_di_arrivo) and\
        _minore_(asse_di_partenza, disco_sottostante) and \
        _minore_(asse_di_arrivo, disco)
      ],
    )
  ]

  #box(width: 150%)[
    #pddl-action(
      [SpostaSuTavoloDaDisco],
      [
        \
        ~ disco, \
        ~ disco_sottostante, \
        ~ asse_di_partenza, \
        ~ asse_di_arrivo \
      ],
      [
        #comment[- tipi]
        *Disco*(disco) and *Disco*(disco_sottostante) and \
        *Asse*(asse_di_partenza) and *Asse*(asse_di_arrivo) and \

        \
        _asse_ord_disco_(asse_di_partenza, disco, disco_sottostante) and \
        _minore_(asse_di_partenza, disco) and \
        _minore_(asse_di_arrivo, Tavolo)

        \
      ],
      [
        #comment[- disco = pop(asse_di_partenza)]
        not _asse_ord_disco_(asse_di_partenza, disco, disco_sottostante) and \
        not _minore_(asse_di_partenza, disco) and \
        not _minore_(asse_di_arrivo, Tavolo) and \

        \
        #comment[- push(asse_di_arrivo, disco)]
        _asse_ord_disco_(asse_di_arrivo, disco, Tavolo) and\
        _minore_(asse_di_partenza, disco_sottostante) and \
        _minore_(asse_di_arrivo, disco)
      ],
    )
  ]

  #box(width: 150%)[
    #pddl-action(
      [SpostaSuDiscoDaTavolo],
      [
        \
        ~ disco, \
        ~ disco_minore_asse_di_arrivo, \
        ~ asse_di_partenza, \
        ~ asse_di_arrivo \
      ],
      [
        #comment[- tipi]
        *Disco*(disco) and *Disco*(disco_minore_asse_di_arrivo) and \
        *Asse*(asse_di_partenza) and *Asse*(asse_di_arrivo) and \
        disco < disco_minore_asse_di_arrivo and

        \
        _asse_ord_disco_(asse_di_partenza, disco, Tavolo) and \
        _minore_(asse_di_partenza, disco) and \
        _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) \
        \
      ],
      [
        #comment[- disco = pop(asse_di_partenza)]
        not _asse_ord_disco_(asse_di_partenza, disco, Tavolo) and \
        not _minore_(asse_di_partenza, disco) and \
        not _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) and \

        \
        #comment[- push(asse_di_arrivo, disco)]
        _asse_ord_disco_(asse_di_arrivo, disco, disco_minore_asse_di_arrivo) and \
        _minore_(asse_di_partenza, Tavolo) and \
        _minore_(asse_di_arrivo, disco)
      ],
    )
  ]

  #box(width: 150%)[
    #pddl-action(
      [SpostaSuTavoloDaTavolo],
      [
        \
        ~ disco, \
        ~ asse_di_partenza, \
        ~ asse_di_arrivo \
      ],
      [
        #comment[- tipi]
        *Disco*(disco) and *Asse*(asse_di_partenza) and *Asse*(asse_di_arrivo) and \

        \
        _asse_ord_disco_(asse_di_partenza, disco, Tavolo) and \
        _minore_(asse_di_partenza, disco) and \
        _minore_(asse_di_arrivo, Tavolo) \
        \
      ],
      [
        #comment[- disco = pop(asse_di_partenza)]
        not _asse_ord_disco_(asse_di_partenza, disco, Tavolo) and \
        not _minore_(asse_di_partenza, disco) and \
        not _minore_(asse_di_arrivo, Tavolo) and \

        \
        #comment[- push(asse_di_arrivo, disco)]
        _asse_ord_disco_(asse_di_arrivo, disco, Tavolo) and \
        _minore_(asse_di_partenza, Tavolo) and \
        _minore_(asse_di_arrivo, disco)
      ],
    )
  ]
]

// not _asse_ord_disco_(asse_di_partenza, disco, Tavolo) and \
// not _minore_(asse_di_partenza, disco) and \
// not _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) and \

// not _asse_ord_disco_(asse_di_partenza, disco, disco_sottostante) and \
// not _minore_(asse_di_partenza, disco) and \
// not _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) and \
// _minore_(asse_di_partenza, disco_sottostante) and \

// ahhhhhhhh, mi posso evitare "vuto" dicendo semplicemente che il "minore" dell'asse è il Tavolo

// - [x] SpostaSuDiscoDaDisco
// - [x] SpostaSuTavoloDaDisco
// - [ ] SpostaSuDiscoDaTavolo
// - [ ] SpostaSuTavoloDaTavolo

// ~ Asse\/1, Disco\/1, PoggiatoSu\/2, PiùGrandeDi\/2 \
// \
// ~ - relazione d'ordine stretto e totale \

// ~ #comment[- invariante ordine]
// ~ #comment[- invariante ordine]
// ~ _Su_(C, $D_1$, $D_2$) and _Su_(C, $D_2$) and _Su_(C, $D_3$) and _Su_(C, $D_4$)

// not _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) and \

// _minore_(asse_di_arrivo, disco_minore_asse_di_arrivo) and \
// disco < disco_minore_asse_di_arrivo
// ~ disco_minore_asse_di_arrivo \

//
// #pddl-action(
//   [SpostaSuTavolo],
//   [disco, disco_sotto, asse_partenza, asse_arrivo],
//   [
//     _asse_ord_disco_(asse_partenza, disco, disco_sotto) and \
//     _minore_(asse_partenza, disco)
//   ],
//   [],
// )


// _minore_(asse_di_partenza, disco_sottostante) and \

// #pddl-action(
//   [Azione],
//   [x, y, z],
//   [_Su_(t, s1) and _Su_(x, s2)],
//   [_Su_(x, s1) and _Su_(t, x)],
// )

// \
// Dato Ad ogni asse è associato un insieme di dischi , essendoci una relazione d'ordine totale e stretta sui dischi, è possibile ricavare l'ordine di inserimento dei dischi su un dato asse.

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



// #pagebreak()
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


// #constraint([C.*Class*.ciao_come_stai], [come stai], description: [ciao come stai])

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
