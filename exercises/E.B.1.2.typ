#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.2 (FOL: Studenti ansiosi, inferenza)], doc)

#fol[$cal(P)$ = { *Studente*\/1, *Corso*\/1, _HaStudiato_\/2, *Ansioso*\/1, _Supera_\/2}]

#fol[
  forall X forall C \
  ~ ( \
  ~~ *Studente*(X) and \
  ~~ *Corso*(C) and \
  ~~ (*Ansioso*(X) or not _HaStudiato_(X, C)) \
  ~ ) -> \
  ~~ not _Supera_(X, C)
]

\

Di seguito la riduzione a CNF della formula sopra

\

#align(center)[
  #box(width: 150%)[
    #fol[
      (*Studente*(X) and *Corso*(C) and (*Ansioso*(X) or not _HaStudiato_(X, C))) -> not _Supera_(X, C) =

      {A -> B $equiv$ not A or B}

      not (*Studente*(X) and *Corso*(C) and (*Ansioso*(X) or not _HaStudiato_(X, C)) or not _Supera_(X, C) =

      {De Morgan}

      not *Studente*(X) or not *Corso*(C) or not (*Ansioso*(X) or not _HaStudiato_(X, C)) or not _Supera_(X, C) =

      {De Morgan}

      not *Studente*(X) or not *Corso*(C) or (not *Ansioso*(X) and _HaStudiato_(X, C)) or not _Supera_(X, C) =

      {Associatività di or}

      not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or (not *Ansioso*(X) and _HaStudiato_(X, C)) =

      {Distributività di or}

      (not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or not *Ansioso*(X)) and \
      (not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or _HaStudiato_(X, C))
    ]
  ]
]

#pagebreak()

== Inferenza A

=== KB di partenza

Data la knowledge-base di partenza #fol[KB] t.c. \

#indent(
  fol[
    KB = { \
    ~ exists X *Studente*(X) and *Ansioso*(X), \

    ~ exists X exists C *Studente*(X) and *Corso*(C) and _HaStudiato_(X, C), \

    ~ forall X forall C \
    ~~ ( \
    ~~~ *Studente*(X) and \
    ~~~ *Corso*(C) and \
    ~~~ (*Ansioso*(X) or not _HaStudiato_(X, C)) \
    ~~ ) -> \
    ~~~ not _Supera_(X, C) \
    }
  ],
)

È vero che #fol[KB $tack.r.double$ (forall X forall C *Studente*(X) and *Corso*(C) -> not _Supera_(X, C))] ?

=== CNF

#align(center)[
  #fol[
    $alpha$ =

    (forall X forall C *Studente*(X) and *Corso*(C) -> not _Supera_(X, C)) =

    {Semplificazione}

    (*Studente*(X) and *Corso*(C)) -> not _Supera_(X, C) =

    {A -> B $equiv$ not A or B}

    not (*Studente*(X) and *Corso*(C)) or not _Supera_(X, C) =

    {De Morgan}

    not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C)

    {La negazione si ottiene con De Morgan}

    not $alpha$ = *Studente*(X) and *Corso*(C) and _Supera_(X, C)
  ]
]

\

#box(width: 150%)[
  #fol[
    KB#sub[CNF] = { \

    ~ *Studente*($S_1$), \
    ~ *Ansioso*($S_1$), \
    \
    ~ *Studente*($S_2$), \
    ~ *Corso*($C_1$), \
    ~ _HaStudiato_($S_2$, $C_1$), \
    \
    ~ (not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or not *Ansioso*(X)), \
    ~ (not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or _HaStudiato_(X, C))

    }
  ]
]

#pagebreak()

Si applica l'algoritmo di risoluzione su

#align(center)[
  #fol[KB#sub[CNF] and *Studente*(Y) and *Corso*(D) and _Supera_(Y, D)]
]


#box(width: 150%)[
  1. #fol[
      (not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or _HaStudiato_(X, C)) and \
      (*Studente*($S_2$)) \
      $tack.r.double$ (not *Corso*(C) or not _Supera_($S_2$, C) or _HaStudiato_($S_2$, C))
    ]

  2. #fol[
      (not *Corso*(C) or not _Supera_($S_2$, C) or _HaStudiato_($S_2$, C)) and \
      (_HaStudiato_($S_2$, $C_1$)) \
      $tack.r.double$ (not *Corso*($C_1$) or not _Supera_($S_2$, $C_1$))
    ]

  3. #fol[
      (not *Corso*($C_1$) or not _Supera_($S_2$, $C_1$)) and \
      (*Corso*($C_1$)) \
      $tack.r.double$ not _Supera_($S_2$, $C_1$)
    ]

  4. #fol[
      (not _Supera_($S_2$, $C_1$)) and \
      (_Supera_(Y, D)) \
      $tack.r.double$ ()
    ]

]

Avendo trovato la clausola vuota, si ha che #fol[KB#sub[CNF] and not $alpha$] non è soddisfacibile, quindi #fol[KB#sub[CNF] $tack.r.double$ $alpha$]

#pagebreak()

== Inferenza B

=== KB di partenza

Data la knowledge-base di partenza #fol[KB] t.c. \

#indent(
  fol[
    KB = { \
    ~ exists X *Studente*(X) and not *Ansioso*(X),

    ~ forall X exists C *Studente*(X) -> (*Corso*(C) and _HaStudiato_(X, C)),

    ~ forall X forall C \
    ~~ ( \
    ~~~ *Studente*(X) and \
    ~~~ *Corso*(C) and \
    ~~~ (*Ansioso*(X) or not _HaStudiato_(X, C)) \
    ~~ ) -> \
    ~~~ not _Supera_(X, C) \
    }
  ],
)

È vero che #fol[KB $tack.r.double$ (forall X exists C *Studente*(X) -> (*Corso*(C) and _Supera_(X, C)))] ?

=== CNF

#align(center)[
  #fol[
    forall X exists C *Studente*(X) -> (*Corso*(C) and _HaStudiato_(X, C)) =

    {Semplificazione}

    *Studente*(X) -> (*Corso*($C_1$(X)) and _HaStudiato_(X, $C_1$(X))) =

    {A -> B $equiv$ not A or B}

    not *Studente*(X) or (*Corso*($C_1$(X)) and _HaStudiato_(X, $C_1$(X))) =

    {Distributività di or}

    (not *Studente*(X) or *Corso*($C_1$(X))) and \
    (not *Studente*(X) or _HaStudiato_(X, $C_1$(X)))
  ]
]

\

#align(center)[
  #fol[
    $alpha$ =

    forall X exists C *Studente*(X) -> (*Corso*(C) and _Supera_(X, C)) =

    {Semplificazione}

    *Studente*(X) -> (*Corso*($C_2$(X)) and _Supera_(X, $C_2$(X))) =

    {A -> B $equiv$ not A or B}

    not *Studente*(X) or (*Corso*($C_2$(X)) and _Supera_(X, $C_2$(X))) =

    {Distributività di or}

    (not *Studente*(X) or *Corso*($C_2$(X))) and \
    (not *Studente*(X) or _Supera_(X, $C_2$(X)))

    {La negazione si ottiene con De Morgan}

    not $alpha$ = \
    not (not *Studente*(X) or *Corso*($C_2$(X))) or \
    not (not *Studente*(X) or _Supera_(X, $C_2$(X))) =

    {De Morgan}

    (*Studente*(X) and not *Corso*($C_2$(X))) or \
    (*Studente*(X) and not _Supera_(X, $C_2$(X))) =

    {Distributività}

    ((*Studente*(X) and not *Corso*($C_2$(X))) or *Studente*(X)) and \
    ((*Studente*(X) and not *Corso*($C_2$(X))) or not _Supera_(X, $C_2$(X))) =

    {Distributività}

    (*Studente*(X) or *Studente*(X)) and \
    (not *Corso*($C_2$(X)) or *Studente*(X)) and \
    (*Studente*(X) or not _Supera_(X, $C_2$(X))) and \
    (not *Corso*($C_2$(X)) or not _Supera_(X, $C_2$(X)))

    {Semplificazione + ridenominazione}

    *Studente*(Y) and \
    (not *Corso*($C_2$(Y)) or *Studente*(Y)) and \
    (*Studente*(Y) or not _Supera_(Y, $C_2$(Y))) and \
    (not *Corso*($C_2$(Y)) or not _Supera_(Y, $C_2$(Y)))
  ]
]

\

#box(width: 150%)[
  #fol[
    KB#sub[CNF] = { \

    ~ *Studente*($S_1$), \
    ~ not *Ansioso*($S_1$), \
    \
    ~ (not *Studente*(Z) or *Corso*($C_1$(Z))), \
    ~ (not *Studente*(Z) or _HaStudiato_(Z, $C_1$(Z))), \
    \
    ~ (not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or not *Ansioso*(X)), \
    ~ (not *Studente*(X) or not *Corso*(C) or not _Supera_(X, C) or _HaStudiato_(X, C)) \

    }
  ]
]

Si applica l'algoritmo di risoluzione su

#align(center)[
  #fol[KB#sub[CNF] and not $alpha$]
]


1. La ricerca fallisce con il solver, quindi dovrei provare tutte le clausole finché non se ne possono aggiungere altre.

#pagebreak()

== Prover9 & Mace4

=== Inferenza A

#align(center)[
  #box(width: 150%)[
    ```c
    formulas(sos).
        (exists x Studente(x) & Ansioso(x)).
        (all x (exists c Studente(x) & Corso(c) & HaStudiato(x, c))).
        (all x all c ((Studente(x) & Corso(c) & (Ansioso(x) | -HaStudiato(x, c))) -> -Supera(x, c))).
    end_of_list.

    formulas(goals).
        (all x all c (Studente(x) & Corso(c)) ->  -Supera(x, c)).
    end_of_list.
    ```
  ]
]


\
Il solver è in grado di dimostrare il goal

\

#align(center)[
  #box(width: 150%)[
    ```c
    1 (exists x Studente(x)) & Ansioso(x) # label(non_clause).  [assumption].
    2 (all x ((exists c Studente(x)) & Corso(c) & HaStudiato(x,c))) # label(non_clause).  [assumption].
    3 (all x all c (Studente(x) & Corso(c) & (Ansioso(x) | -HaStudiato(x,c)) -> -Supera(x,c))) # label(non_clause).  [assumption].
    4 (all x all c (Studente(x) & Corso(c))) -> -Supera(x,c) # label(non_clause) # label(goal).  [goal].
    5 -Studente(x) | -Corso(y) | -Ansioso(x) | -Supera(x,y).  [clausify(3)].
    7 Studente(x).  [clausify(2)].
    11 Ansioso(x).  [clausify(1)].
    12 -Corso(x) | -Ansioso(y) | -Supera(y,x).  [resolve(5,a,7,a)].
    14 Corso(c).  [clausify(2)].
    18 -Corso(x) | -Supera(y,x).  [resolve(12,b,11,a)].
    20 Supera(c1,c).  [deny(4)].
    22 -Supera(x,c).  [resolve(18,a,14,a)].
    24 $F.  [resolve(22,a,20,a)].
    ```
  ]
]

=== Inferenza B

#align(center)[
  #box(width: 150%)[
    ```
    formulas(sos).
        (exists x Studente(x) & -Ansioso(x)).
        (all x Studente(x) -> (exists c Corso(c) & HaStudiato(x, c))).
        (all x all c ((Studente(x) & Corso(c) & (Ansioso(x) | -HaStudiato(x, c))) -> -Supera(x, c))).
    end_of_list.

    formulas(goals).
        (all x (exists c Studente(x) -> (Corso(c) & Supera(x, c)))).
    end_of_list.
    ```
  ]
]

La ricerca fallisce.
