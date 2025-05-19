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
    ~ ($D_2 < D_3$) and ($D_2 < D_4$) and ($D_3 < D_4$) and \
    ~ ($D_1 <$ Tavolo) and ($D_2 <$ Tavolo) and \
    ~ ($D_3 <$ Tavolo) and ($D_4 <$ Tavolo) and \

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


#pagebreak()

=== Schemi di azione

// Si potrebbero definire delle "operazioni d'appoggio" o "operazioni ausiliarie" posso invocare solo io nella specifica, tipo "push" e "pop"
// che posso riusare al posto di fare sempre le stesse cose

#box(width: 150%)[
  #pddl-action(
    [Sposta],
    [
      \
      ~ disco, \
      ~ oggetto_sottostante, \
      ~ oggetto_minore_asse_di_arrivo, \
      ~ asse_di_partenza, \
      ~ asse_di_arrivo \
    ],
    [
      #comment[- tipi]
      *Disco*(disco) and *Asse*(asse_di_partenza) and *Asse*(asse_di_arrivo) and \
      disco < oggetto_minore_asse_di_arrivo and

      \
      #comment[- disco = top(asse_di_partenza)]
      _asse_ord_disco_(asse_di_partenza, disco, oggetto_sottostante) and \
      _minore_(asse_di_partenza, disco) and \
      _minore_(asse_di_arrivo, oggetto_minore_asse_di_arrivo) \
      \
    ],
    [
      #comment[- pop(asse_di_partenza)]
      not _asse_ord_disco_(asse_di_partenza, disco, oggetto_sottostante) and \
      not _minore_(asse_di_partenza, disco) and \
      not _minore_(asse_di_arrivo, oggetto_minore_asse_di_arrivo) and \

      \
      #comment[- push(asse_di_arrivo, disco)]
      _asse_ord_disco_(asse_di_arrivo, disco, oggetto_minore_asse_di_arrivo) and\
      _minore_(asse_di_partenza, oggetto_sottostante) and \
      _minore_(asse_di_arrivo, disco)
    ],
  )
]
