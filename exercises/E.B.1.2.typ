#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.2 (FOL: Studenti ansiosi, inferenza)], doc)

- #fol[
    $cal(P)$ = { *Studente*\/1, *Corso*\/1, _HaStudiato_\/2, *Ansioso*\/1, _Supera_\/2}
  ]
- #fol[
    $forall$ X $forall$ C \
    ~ ( \
    ~~ *Studente*(X) $and$ \
    ~~ *Corso*(C) $and$ \
    ~~ (*Ansioso*(X) $or$ $not$ _HaStudiato_(X, C)) \
    ~ ) $->$ \
    ~~ $not$ _Supera_(X, C)
  ]

== Inferenza A


- #fol[
    KB = { \
    ~ $forall$ X $forall$ C \
    ~~ *Studente*(X) $and$ *Corso*(C) $and$ (*Ansioso*(X) $or$ $not$ _HaStudiato_(X, C)) \
    ~~~ $->$ $not$ _Supera_(X, C), \
    ~ $exists$ X *Studente*(X) $and$ *Ansioso*(X), \
    ~ $exists$ X $exists$ C *Studente*(X) $and$ *Corso*(C) $and$ _HaStudiato_(X, C) \
    }

  ]
- $cal(F) = { S_1\/0, S_2\/0, C_1\/0 }$

\

#align(center)[
  #box(width: 150%)[
    #fol[
      \
      ~ *Studente*(X) $and$ *Corso*(C) $and$ (*Ansioso*(X) $or$ $not$ _HaStudiato_(X, C)) $->$ $not$ _Supera_(X, C) = \
      \
      ~ $not$ *Studente*(X) $or$ $not$ *Corso*(C) $or$ $not$ (*Ansioso*(X) $or$ $not$ _HaStudiato_(X, C)) $or$ $not$ _Supera_(X, C) = \
      \
      ~ $not$ *Studente*(X) $or$ $not$ *Corso*(C) $or$ $not$ _Supera_(X, C) $or$ ($not$ *Ansioso*(X) $and$ _HaStudiato_(X, C)) = \
      \
      ~ $not$ *Studente*(X) $or$ $not$ *Corso*(C) $or$ \ (($not$ *Ansioso*(X) $or$ $not$ _Supera_(X, C)) $and$ (_HaStudiato_(X, C) $or$ $not$ _Supera_(X, C))) = \
      \
      ~ $not$ *Studente*(X) $or$ \ (($not$ *Ansioso*(X) $or$ $not$ _Supera_(X, C)$or$ $not$ *Corso*(C)) $and$ \ (_HaStudiato_(X, C) $or$ $not$ _Supera_(X, C))$or$ $not$ *Corso*(C)) = \
      \
      ~ ($not$ *Ansioso*(X) $or$ $not$ _Supera_(X, C)$or$ $not$ *Corso*(C) $or$ $not$ *Studente*(X)) $and$ \ (_HaStudiato_(X, C) $or$ $not$ _Supera_(X, C))$or$ $not$ *Corso*(C) $or$ $not$ *Studente*(X) \
    ]
  ]
]

#pagebreak()

#box(width: 150%)[
  #fol[
    KB#sub[CNF] = { \
    // ~ $not$ *Ansioso*(X) $or$ $not$ _Supera_(X, C)$or$ $not$ *Corso*(C) $or$ $not$ *Studente*(X)), \
    // ~ (_HaStudiato_(X, C) $or$ $not$ _Supera_(X, C) $or$ $not$ *Corso*(C) $or$ $not$ *Studente*(X), \
    // ~ $forall$ X $forall$ C \
    // ~ $exists$ X *Studente*(X) $and$ *Ansioso*(X), \
    ~ *Studente*($S_1$), \
    ~ *Ansioso*($S_1$), \
    ~ *Studente*($S_2$), \
    ~ *Corso*($C_1$), \
    ~ _HaStudiato_($S_2$, $C_1$) \
    ~ $not$ *Ansioso*(X) $or$ $not$ _Supera_(X, C) $or$ $not$ *Corso*(C) $or$ $not$ *Studente*(X)) \
    ~ _HaStudiato_(X, C) $or$ $not$ _Supera_(X, C) $or$ $not$ *Corso*(C) $or$ $not$ *Studente*(X) \
    // ~ $exists$ X $exists$ C *Studente*(X) $and$ *Corso*(C) $and$ _HaStudiato_(X, C) \
    }
  ]
]


- #fol[
    KB#sub[CNF] $tack.r.double$ $not$ ($exists$ X $exists$ C *Studente*(X) $and$ *Corso*(C) $and$ _Supera_(X, C)) ?
  ]

// $
//   & "KB" = { \
//     & quad
//     & }
// $
// - Ci sono studenti ansiosi
//   - #highlight[
//       $exists$ X *Studente*(X) $and$ *Ansioso*(X)
//     ]
// - Ci sono studenti che hanno studiato
//   - #highlight[
//       $exists$ X $exists$ C *Studente*(X) $and$ *Corso*(C) $and$ _HaStudiato_(X, C)
//     ]
// - SI PUÒ INFERIRE: nessuno studente supererà alcun esame?
//   - #highlight[
//       $not$ ($exists$ X $exists$ C *Studente*(X) $and$ *Corso*(C) $and$ _Supera_(X, C))
//     ]
// $"KB" tack.r.double "query"$
// - devo definire KB
// - devo definire query, e vedere se la cosa sussiste

== Inferenza B
- Non tutti gli studenti sono ansiosi
  - #fol[
      $exists$ X *Studente*(X) $and$ $not$ *Ansioso*(X)
    ]
- Ogni studente ha studiato per almeno un esame
  - #fol[
      $forall$ X *Studente*(X) $->$ $exists$ C (*Corso*(C) $and$ _HaStudiato_(X, C))
    ]
- SI PUÒ INFERIRE: che tutti gli studenti supereranno almeno un esame?
  - #fol[
      $forall$ X *Studente*(X) $->$ $exists$ C (*Corso*(C) $and$ _Supera_(X, C))
    ]

// ∀X∀C Studente(X)∧Corso(C)∧(Ansioso(X) ∨ ¬HaStudiato(X, C)) → ¬Supera(X, C)
