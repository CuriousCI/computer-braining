#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.4 (FOL: Aldo, inferenza)], doc)

#fol[$cal(P)$ = { \
  ~ *CaneDaCaccia*\/1, *AbbaiaDiNotte*\/1, *Gatto*\/1, \
  ~ *HaIlTopoInCasa*\/1, *HaSonnoLeggero*\/2, _Possiede_\/2 \
  }]

#fol[$cal(F)$ = { Aldo\/0 }]

#fol[
  KB = { \
  ~ forall c *CaneDaCaccia*(c) -> *AbbaiaDiNotte*(c), \
  ~ forall p, g *Gatto*(g) and _Possiede_(p, g) -> not *HaIlTopoInCasa*(p), \
  ~ forall p, a *HaSonnoLeggero*(p) and _Possiede_(p, a) -> not *AbbaiaDiNotte*(a), \
  ~ exists a _Possiede_(Aldo, a) and (*Gatto*(a) or *CaneDaCaccia*(a)) \
  }
]

== Inferenza

Si dimostri che #fol[KB $tack.r.double$ *HaSonnoLeggero*(Aldo) -> not *HaIlTopoInCasa*(Aldo)]
_(primo tenativo fallimentare perché non mi ero accorto che ci fosse una clausola con più di un letterale positivo)_

\

#align(
  center,
  fol[
    $alpha$ =

    *HaSonnoLeggero*(Aldo) -> not *HaIlTopoInCasa*(Aldo) =

    {A -> B $equiv$ not A or B}

    not *HaSonnoLeggero*(Aldo) or not *HaIlTopoInCasa*(Aldo)
  ],
)

\
\

#align(
  center,
  fol[
    *HaSonnoLeggero*(p) and _Possiede_(p, a) -> not *AbbaiaDiNotte*(a) =

    {A -> B $equiv$ not A or B}

    not (*HaSonnoLeggero*(p) and _Possiede_(p, a)) or not *AbbaiaDiNotte*(a) =

    {De Morgan}

    not *HaSonnoLeggero*(p) or not _Possiede_(p, a) or not *AbbaiaDiNotte*(a) =

    {Commutatività di or}


    not _Possiede_(p, a) or not *AbbaiaDiNotte*(a) or not *HaSonnoLeggero*(p) =

    {De Morgan al contrario}

    not (_Possiede_(p, a) and *AbbaiaDiNotte*(a)) or not *HaSonnoLeggero*(p) =

    {A -> B $equiv$ not A or B}

    _Possiede_(p, a) and *AbbaiaDiNotte*(a) -> not *HaSonnoLeggero*(p)

  ],
)

\

#fol[
  KB' = { \
  ~ *CaneDaCaccia*(c1) -> *AbbaiaDiNotte*(c1), \
  ~ *Gatto*(g1) and _Possiede_(p1, g1) -> not *HaIlTopoInCasa*(p1), \
  // ~ *HaSonnoLeggero*(p2) and _Possiede_(p2, a2) -> not *AbbaiaDiNotte*(a2), \
  ~ _Possiede_(p, a) and *AbbaiaDiNotte*(a) -> not *HaSonnoLeggero*(p) \
  ~ _Possiede_(Aldo, $A_1$), \
  ~ *Gatto*($A_1$) or *CaneDaCaccia*($A_1$) \
  }
]

\

#fol[KB'] *non* è in forma di *Horn* (a causa di #fol[*Gatto*($A_1$) or *CaneDaCaccia*($A_1$)]), per cui non si può applicare l'algoritmo di concatenazione in avanti. Infatti non è possibile ottenere #fol[*AbbaiaDiNotte*($A_1$)] che serve per ottenere #fol[not *HaSonnoLeggero*(Aldo)].

\

#fol(
  align(
    center,
    box(
      width: 150%,
      grid(
        align: center,
        gutter: .5em,
        [_Possiede_(Aldo $A_1$), *AbbaiaDiNotte*($A_1$) $quad$ (_Possiede_(p, a) and *AbbaiaDiNotte*(a) -> not *HaSonnoLeggero*(p)) ],
        line(stroke: 0.20pt, length: 100%),
        [not *HaSonnoLeggero*(Aldo)]
      ),
    ),
  ),
)

\

#fol(
  align(
    center,
    box(
      grid(
        align: center,
        gutter: .5em,
        [_Possiede_(Aldo $A_1$) $quad$ (_Possiede_(p1, g1) -> not *HaIlTopoInCasa*(p1))],
        line(stroke: 0.20pt, length: 100%),
        [not *HaIlTopoInCasa*(Aldo)]
      ),
    ),
  ),
)

\

#fol(
  align(
    center,
    box(
      grid(
        align: center,
        gutter: .5em,
        [not *HaSonnoLeggero*(Aldo), not *HaIlTopoInCasa*(Aldo) $quad$ A and B -> A or B],
        line(stroke: 0.20pt, length: 100%),
        [not *HaSonnoLeggero*(Aldo) or not *HaIlTopoInCasa*(Aldo)]
      ),
    ),
  ),
)

=== CNF

#align(
  center,
  fol[
    not $alpha$ =

    not (not *HaSonnoLeggero*(Aldo) or not *HaIlTopoInCasa*(Aldo)) =

    {De Morgan}

    *HaSonnoLeggero*(Aldo) and *HaIlTopoInCasa*(Aldo)
  ],
)

\

#fol[
  KB#sub[CNF] = { \
  ~ not *CaneDaCaccia*(c1) or *AbbaiaDiNotte*(c1), \
  ~ not *Gatto*(g1) or not _Possiede_(p1, g1) or not *HaIlTopoInCasa*(p1), \
  ~ not _Possiede_(p, a) or not *AbbaiaDiNotte*(a) or not *HaSonnoLeggero*(p), \
  ~ _Possiede_(Aldo, $A_1$), \
  ~ *Gatto*($A_1$) or *CaneDaCaccia*($A_1$) \
  }
]

Si usa l'algoritmo di risoluzione per dimostrare che #fol[KB#sub[CNF] and not $alpha$] non è soddisfacibile, quindi #fol[KB#sub[CNF] $tack.r.double$ $alpha$ ]


1. #box(width: 120%)[
    #fol[
      (not *Gatto*(g1) or not _Possiede_(p1, g1) or not *HaIlTopoInCasa*(p1)) and \
      (*Gatto*($A_1$) or *CaneDaCaccia*($A_1$) ) \

      ~ $tack.r.double$ (not _Possiede_(p1, $A_1$) or not *HaIlTopoInCasa*(p1) or *CaneDaCaccia*($A_1$))
    ]]

2. #fol[
    (not _Possiede_(p1, $A_1$) or not *HaIlTopoInCasa*(p1) or *CaneDaCaccia*($A_1$)) and \
    (_Possiede_(Aldo, $A_1$)) \

    ~ $tack.r.double$ (not *HaIlTopoInCasa*(Aldo) or *CaneDaCaccia*($A_1$))
  ]

3. #fol[
    (not *HaIlTopoInCasa*(Aldo) or *CaneDaCaccia*($A_1$)) and \
    (not *CaneDaCaccia*(c1) or *AbbaiaDiNotte*(c1)) \

    ~ $tack.r.double$ (not *HaIlTopoInCasa*(Aldo) or *AbbaiaDiNotte*($A_1$))
  ]

4. #fol[
    (not *HaIlTopoInCasa*(Aldo) or *AbbaiaDiNotte*($A_1$)) and \
    (*HaIlTopoInCasa*(Aldo)) \

    ~ $tack.r.double$ (*AbbaiaDiNotte*($A_1$))
  ]

5. #fol[
    (not _Possiede_(p, a) or not *AbbaiaDiNotte*(a) or not *HaSonnoLeggero*(p)) and \
    (*HaSonnoLeggero*(Aldo)) \

    ~ $tack.r.double$ (not _Possiede_(p, a) or not *AbbaiaDiNotte*(a))
  ]

6. #fol[
    (not _Possiede_(p, a) or not *AbbaiaDiNotte*(a)) and (_Possiede_(Aldo, $A_1$)) \

    ~ $tack.r.double$ (not *AbbaiaDiNotte*($A_1$))
  ]

7. #fol[
    not *AbbaiaDiNotte*($A_1$) and *AbbaiaDiNotte*($A_1$) $tack.r.double$ ()
  ]

Avendo ottenuto la clausola vuota si ha che #fol[KB#sub[CNF] and not $alpha$] non è soddisfacibile, quindi #fol[KB#sub[CNF] $tack.r.double$ $alpha$]

== Prover9 / Mace4

#box(width: 200%)[
  ```c
  formulas(sos).
      (all x (CaneDaCaccia(x) -> AbbaiaDiNotte(x))).
      (all x (all y (Gatto(y) & Possiede(x,y) -> -HaIlTopoInCasa(x)))).
      (all x (all y (HaSonnoLeggero(x) & Possiede(x,y) -> -AbbaiaDiNotte(y)))).
      (exists y (Possiede(aldo,y) & (Gatto(y) | CaneDaCaccia(y)))).
  end_of_list.

  formulas(goals).
      (HaSonnoLeggero(aldo) -> -HaIlTopoInCasa(aldo)).
  end_of_list.
  ```
]

\

#align(center)[
  #box(width: 200%)[
    ```c
    % Maximum clause weight is 0.000.
    % Given clauses 0.

    1 (all x (CaneDaCaccia(x) -> AbbaiaDiNotte(x))) # label(non_clause).  [assumption].
    2 (all x all y (Gatto(y) & Possiede(x,y) -> -HaIlTopoInCasa(x))) # label(non_clause).  [assumption]
    3 (all x all y (HaSonnoLeggero(x) & Possiede(x,y) -> -AbbaiaDiNotte(y))) # label(non_clause).  [assumption]
    4 (exists y (Possiede(aldo,y) & (Gatto(y) | CaneDaCaccia(y)))) # label(non_clause).  [assumption]
    5 HaSonnoLeggero(aldo) -> -HaIlTopoInCasa(aldo) # label(non_clause) # label(goal).  [goal].
    6 Gatto(c1) | CaneDaCaccia(c1).  [clausify(4)].
    7 -CaneDaCaccia(x) | AbbaiaDiNotte(x).  [clausify(1)].
    8 Gatto(c1) | AbbaiaDiNotte(c1).  [resolve(6,b,7,a)].
    9 -Gatto(x) | -Possiede(y,x) | -HaIlTopoInCasa(y).  [clausify(2)].
    10 HaSonnoLeggero(aldo).  [deny(5)].
    11 -HaSonnoLeggero(x) | -Possiede(x,y) | -AbbaiaDiNotte(y).  [clausify(3)].
    12 AbbaiaDiNotte(c1) | -Possiede(x,c1) | -HaIlTopoInCasa(x).  [resolve(8,a,9,a)].
    13 Possiede(aldo,c1).  [clausify(4)].
    14 -Possiede(aldo,x) | -AbbaiaDiNotte(x).  [resolve(10,a,11,a)].
    15 AbbaiaDiNotte(c1) | -HaIlTopoInCasa(aldo).  [resolve(12,b,13,a)].
    16 HaIlTopoInCasa(aldo).  [deny(5)].
    17 AbbaiaDiNotte(c1).  [resolve(15,b,16,a)].
    18 -AbbaiaDiNotte(c1).  [resolve(14,a,13,a)].
    19 $F.  [resolve(17,a,18,a)].
    ```
  ]
]
