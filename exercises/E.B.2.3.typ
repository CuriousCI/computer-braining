#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.2.3 (PDDL: Water Buckets, modelling)], doc)

#let comment(body) = text(luma(150), body)

== Modellazione

#fol[
  - $cal(P)$ = { *Bucket*\/1, _Capacity_\/2, _Water_\/2, _min_\/2, +\/3 }
  - $cal(F)$ = { \
    $A$\/0, $B$\/0, $C$\/0 \
    0\/0, 1\/0, 2\/0, 3\/0, 4\/0, 5\/0, \
    6\/0, 7\/0, 8\/0, 9\/0, 10\/0 \
  }
]

- Si attribuisce il seguente significato ai diversi simboli di predicato:
  - #fol[*Bucket*($b$)]: $b$ è un secchio
  - #fol[_Capacity_($b$, $c$)]: il secchio $b$ ha capacità $c$
  - #fol[_Water_($b$, $l$)]: il secchio $b$ contiene $l$ litri d'acqua

- *Stato iniziale*: #fol[
    \

    #comment[- Invariante tipi]
    *Bucket*($A$) and *Bucket*($B$) and *Bucket*($C$) and \
    \
    #comment[- Capacità e contenuto secchi]
    _Capacity_($A$, 5) and _Capacity_($B$, 8) and _Capacity_($C$, 10) and \
    _Water_($A$, 4) and _Water_($B$, 5) and _Water_($C$, 6) and \
    \
    // #comment[- Operazioni]
    // 0 + 0 = 0 and 0 + 1 = 1 and 0 + 2 = 2 and 0 + 3 = 3 and 0 + 4 = 4 and \
    // 0 + 5 = 5 and 0 + 6 = 6 and 0 + 7 = 7 and 0 + 8 = 8 and 0 + 9 = 9 and \
    // 0 + 10 = 10 and 1 +
  ]


- *Stato finale*: #fol[
    \

    _Water_($A$, 5) and _Water_($B$, 5) and _Water_($C$, 5)
  ]

=== Schemi di azione

#box(width: 150%)[
  #pddl-action(
    [Pour],
    [
      \
      ~ src, \
      ~ dst, \
      ~ src_capacity, \
      ~ dst_capacity, \
      ~ src_water, \
      ~ dst_water, \
    ],
    [
      *Bucket*(src) and *Bucket*(dst) and \
      _Capacity_(src, src_capacity) and _Capacity_(dst, dst_capacity) and \
      _Water_(src, src_water) and _Water_(dst, dst_water)
    ],
    [
      not _Water_(dst, dst_water) and not _Water_(src, src_water) and \
      _Water_(dst, min(dst_capacity - dst_water, src_water)) and \
      _Water_(src, src_water - min(dst_capacity - dst_water, src_water))
    ],
  )
]
