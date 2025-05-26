#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.2.4 (PDDL: Torri di Hanoi, codifica SATPlan)], doc)

#let comment(body) = text(luma(150), body)

== Modellazione

#fol[
  - $cal(P)$ = { *Disk*\/1, _Smaller_\/2, _On_\/2, *Clear*\/1 }
  - $cal(F)$ = { $D_1$, $D_2$, $D_3$, $D_4$, $"Base"_A$, $"Base"_B$, $"Base"_C$}
]

- *Stato iniziale*: #fol[
    \
    #comment[- Quali sono i dischi]
    *Disk*($D_1$) and *Disk*($D_2$) and *Disk*($D_3$) and *Disk*($D_4$) and \
    \
    #comment[- Relazione Smaller tra dischi]
    _Smaller_($D_1$, $D_2$) and _Smaller_($D_1$, $D_3$) and _Smaller_($D_1$, $D_4$) and \
    _Smaller_($D_2$, $D_3$) and _Smaller_($D_2$, $D_4$) and _Smaller_($D_3$, $D_4$) and \
    \
    #comment[- Smaller: i dischi sono più piccoli di qualunque base]
    _Smaller_($D_1$, $"Base"_A$) and _Smaller_($D_1$, $"Base"_B$) and _Smaller_($D_1$, $"Base"_C$) and \
    _Smaller_($D_2$, $"Base"_A$) and _Smaller_($D_2$, $"Base"_B$) and _Smaller_($D_2$, $"Base"_C$) and \
    _Smaller_($D_3$, $"Base"_A$) and _Smaller_($D_3$, $"Base"_B$) and _Smaller_($D_3$, $"Base"_C$) and \
    _Smaller_($D_4$, $"Base"_A$) and _Smaller_($D_4$, $"Base"_B$) and _Smaller_($D_4$, $"Base"_C$) and \
    \
    #comment[- Disposizione iniziale: On]
    _On_($D_4$, $"Base"_A$) and _On_($D_3$, $D_4$) and _On_($D_2$, $D_3$) and _On_($D_1$, $D_2$) and \
    \
    #comment[- Disposizione iniziale: Clear]
    *Clear*($D_1$) and *Clear*($"Base"_B$ ) and *Clear*($"Base"_C$)
  ]
- *Stato finale*: #fol[
    \
    #comment[- Disposizione finale: On]
    _On_($D_4$, $"Base"_B$) and _On_($D_3$, $D_4$) and _On_($D_2$, $D_3$) and _On_($D_1$, $D_2$)
  ]

== Schemi di azione

#pddl-action(
  [Move],
  [d, src, dst],
  [
    *Disk*(d) and _On_(d, src) and _Smaller_(d, dst) \
    *Clear*(d) and *Clear*(dst)
  ],
  [
    *On*(d, dst) and not *Clear*(dst) and *Clear*(src) and not _On_(d, src)
  ],
)
