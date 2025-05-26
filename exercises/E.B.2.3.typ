#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.2.3 (PDDL: Water Buckets, modelling)], doc)

#fol[
  - $cal(P)$ = { \
  ~ *Bucket*\/1, _Capacity_\/2 \
  }
  - $cal(F)$ = { \
  }
]

- Si attribuisce il seguente significato ai diversi simboli di predicato:
  - #fol[*Bucket*($b$)]: $b$ è un secchio
  - #fol[_Capacity_($b$, $c$)]: il secchio $b$ ha capacità $c$
