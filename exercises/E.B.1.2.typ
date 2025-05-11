#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.2 (FOL: Studenti ansiosi, inferenza)], doc)

- #highlight[
    $cal(P)$ = { *Studente*\/1, *Corso*\/1, _HaStudiato_\/2, *Ansioso*\/1, _Supera_\/2}
  ]
- #highlight[
    $forall$ X $forall$ C \
    ~ ( \
    ~~ *Studente*(X) $and$ \
    ~~ *Corso*(C) $and$ \
    ~~ (*Ansioso*(X) $or$ $not$ _HaStudiato_(X, C)) \
    ~ ) $->$ \
    ~~ $not$ _Supera_(X, C)
  ]

== Inferenza A

- Ci sono studenti ansiosi
  - #highlight[
      $exists$ X *Studente*(X) $and$ *Ansioso*(X)
    ]
- Ci sono studenti che hanno studiato
  - #highlight[
      $exists$ X $exists$ C *Studente*(X) $and$ *Corso*(C) $and$ _HaStudiato_(X, C)
    ]
- SI PUÒ INFERIRE: nessuno studente supererà alcun esame?
  - #highlight[
      $not$ $exists$ X, C *Studente*(X) $and$ *Corso*(C) $and$ _Supera_(X, C)
    ]

== Inferenza B
- Non tutti gli studenti sono ansiosi
  - #highlight[
      $exists$ X *Studente*(X) $and$ $not$ *Ansioso*(X)
    ]
- Ogni studente ha studiato per almeno un esame
  - #highlight[
      $forall$ X *Studente*(X) $->$ $exists$ C (*Corso*(C) $and$ _HaStudiato_(X, C))
    ]
- SI PUÒ INFERIRE: sia corretto inferire che tutti gli studenti supereranno almeno un esame?
  - #highlight[
      $forall$ X *Studente*(X) $->$ $exists$ C (*Corso*(C) $and$ _Supera_(X, C))
    ]

// ∀X∀C Studente(X)∧Corso(C)∧(Ansioso(X) ∨ ¬HaStudiato(X, C)) → ¬Supera(X, C)
