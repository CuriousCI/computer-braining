#import "logic-new.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.5 (FOL: Club delle Alpi)], doc)

- #logic[
        $cal(P)$ = { Membro/1, Sciatore/1, Rocciatore/1, _piace_/2 }
    ]

- #logic[$cal(F)$ = { Tiziana/0, Michela/0, Giulia/0, Pioggia/0, Neve/0 }]

- Si attribuisce il seguente significato ai diversi simboli di predicato:
    - #logic[Membro($x$)]: $x$ è un membro del club delle "Amici delle Alpi"
    - #logic[Sciatore($x$)]: $x$ è uno sciatore
    - #logic[Rocciatore($x$)]: $x$ è un rocciatore
    - #logic[_piace_($x$, $y$)]: a $x$ piace $y$

== Domanda 1

KB  = #logic(```
    Membro(Tiziana) and
    Membro(Michela) and
    Membro(Julie) and
    forall x (Membro(x) and not Sciatore(x) -> Rocciatore(x)) and
    forall x (Rocciatore(x) -> not piace(x, Pioggia)) and
    forall x (not piace(x, Neve) -> not Sciatore(x)) and
    forall x (piace(Tiziana, x) -> not piace(Michela, x)) and
    piace(Tiziana, Pioggia) and
    piace(Tiziana, Neve)
```)

== Domanda 2

$phi_1$ = #logic(`exists x Membro(x) and Rocciatore(x) and not Sciatore(x)`)

Si dimostri che $"KB" tack.r.double phi_1$, quindi che $"KB"_"CNF" and not phi_1$ è insoddisfacibile

\

#align(center, logic[
    not exists x Membro(x) and Rocciatore(x) and not Sciatore(x) \
    \= \
    not (Membro(M) and Rocciatore(M) and not Sciatore(M)) \
    \= \
    not Membro(M) or not Rocciatore(M) or Sciatore(M)
])

\

KB#sub[CNF] = #logic(```
    Membro(Tiziana) and
    Membro(Michela) and
    Membro(Julie) and
    (not Membro(x) or Sciatore(x) or not Rocciatore(x)) and
    (not Rocciatore(x) or not piace(x, Pioggia)) and
    (piace(x, Neve) or not Sciatore(x)) and
    (not piace(Tiziana, x) or not piace(Michela, x)) and
    piace(Tiziana, Pioggia) and
    piace(Tiziana, Neve) and
    not Membro(M) or not Rocciatore(M) or Sciatore(M)
```)

=== Inferenza

1. #logic[
        (not Membro(x) or Sciatore(x) or not Rocciatore(x)) and \
        (not Membro(M) or not Rocciatore(M) or Sciatore(M)) $tack.r.double$ \
        (not Membro(M) or Sciatore(M))
    ]

// esiste un membro del club che è rocciatore ma non sciatore

== Domanda 3

// A Michela non piace qualunque cosa che piace a Tiziana
// Si dimostri (usando la tecnica più opportuna) se dalla nuova KB sia ancora corretto
// inferire che esiste un membro del club che è rocciatore ma non sciatore.

== Domanda 4

// Tiziana, Michela e Julie sono membri del club “Amici delle Alpi”.
// Ogni membro del club che non è uno sciatore è un rocciatore.
// Ai rocciatori non piace la pioggia e chiunque a cui non piace la neve non è uno sciatore.
// A Michela non piace qualunque cosa che piace a Tiziana, e piace qualunque cosa che non piace a Tiziana.
// A Tiziana piacciono sia la pioggia che la neve.
