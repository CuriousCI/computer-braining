#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.2.2 (PDDL: Domino, modelling)], doc)

#let comment(body) = text(luma(150), body)

== Modellazione

$T_1, ..., T_n$

dove $T_i = angle.l x, y angle.r$ e $x, y in {1, ..., 6}$ e $x != y$

#fol[
  - $cal(P)$ = { \
    ~ *Tessera*\/1, *Posizionata*\/1, _sx_\/2, _dx_\/2, _vt_\/2, =\/2, \
    ~ *UltimoNumero*\/1, *Vuoto*\/0, \
    }

  - $cal(F)$ = { \
  ~ 1\/0, 2\/0, 3\/0, 4\/0, 5\/0, 6\/0, \
  ~ $T_1$, $T_2$, $T_3$, $T_4$, $T_5$, $T_6$ \
  }
]

- Si attribuisce il seguente significato ai diversi simboli di predicato:
  - #fol[*Tessera*($t$)]: $t$ è una tessera
  - #fol[*Posizionata*($t$)]: la tessera $t$ è stata posizionata
  - #fol[*UltimoNumero*($x$)]: $x$ è il numero con cui bisogna fra combaciare la prossima tessera
  - #fol[*Vuoto*]: non è stata posizionata ancora nessuna tessera
  - #fol[_sx_($t$, $x$)]: $x$ è il numero a sinistra della tessera $t$
  - #fol[_dx_($t$, $x$)]: $x$ è il numero a destra della tessera $t$
  - #fol[_vt_($t$, $x$)]: $x$ è uno dei due numeri della tessera $t$
  - #fol[$x$ = $y$]: il numero $x$ è uguale al numero $y$



- *Stato iniziale:* #fol[

    *Vuoto* and \

    (1 = 1) and (2 = 2) and (3 = 3) and (4 = 4) and (5 = 5) and (6 = 6) and \

    *Tessera*($T_1$) and *Tessera*($T_2$) and *Tessera*($T_3$) and \
    *Tessera*($T_4$) and *Tessera*($T_5$) and *Tessera*($T_6$) and \
    _sx_($T_1$, 1) and _dx_($T_1$, 2) and _sx_($T_2$, 1) and _dx_($T_2$, 2) and \
    _sx_($T_3$, 1) and _dx_($T_3$, 3) and _sx_($T_4$, 3) and _dx_($T_4$, 1) and \
    _sx_($T_5$, 2) and _dx_($T_5$, 4) and _sx_($T_6$, 2) and _dx_($T_6$, 5) and \

    _vt_($T_1$, 1) and _vt_($T_1$, 2) and _vt_($T_2$, 1) and _vt_($T_2$, 2) and \
    _vt_($T_3$, 1) and _vt_($T_3$, 3) and _vt_($T_4$, 3) and _vt_($T_4$, 1) and \
    _vt_($T_5$, 2) and _vt_($T_5$, 4) and _vt_($T_6$, 2) and _vt_($T_6$, 5)
  ]

- *Stato finale:* #fol[

    *Posizionata*($T_1$) and *Posizionata*($T_2$) and *Posizionata*($T_3$) and \
    *Posizionata*($T_4$) and *Posizionata*($T_5$) and *Posizionata*($T_6$)
  ]

#pagebreak()

=== Schemi di azione

#box(width: 150%)[
  #pddl-action(
    [PosizionaPrimaTessera],
    [tessera, v],
    [
      *Vuoto* and *Tessera*(tessera) and _vt_(tessera, v)
    ],
    [
      not *Vuoto* and *Posizionata*(tessera) and *UltimoNumero*(v)
    ],
  )
]

#box(width: 150%)[
  #pddl-action(
    [PosizionaTessera],
    [tessera, sx, dx, ultimo_numero],
    [
      *Tessera*(tessera) and _sx_(tessera, sx) and _dx_(tessera, dx) and \
      sx = ultimo_numero and \

      not *Posizionata*(tessera) and *UltimoNumero*(ultimo_numero)
    ],
    [
      not *UltimoNumero*(ultimo_numero) and *Posizionata*(tessera) and \

      *UltimoNumero*(dx)
    ],
  )
]

#box(width: 150%)[
  #pddl-action(
    [PosizionaTesseraRuotata],
    [tessera, sx, dx, ultimo_numero],
    [
      *Tessera*(tessera) and _sx_(tessera, sx) and _dx_(tessera, dx) and \
      dx = ultimo_numero

      not *Posizionata*(tessera) and *UltimoNumero*(ultimo_numero)
    ],
    [
      not *UltimoNumero*(ultimo_numero) and *Posizionata*(tessera) and \

      *UltimoNumero*(sx)
    ],
  )
]

// [dx]
// #box(width: 150%)[
//   #pddl-action(
//     [PosizionaPrimaTesseraRuotata],
//     [tessera, sx],
//     [
//       *Vuoto* and *Tessera*(tessera) and _sx_(tessera, sx)
//     ],
//     [
//       not *Vuoto* and *Posizionata*(tessera) and *UltimoNumero*(sx)
//     ],
//   )
// ]


// - TODO: domanda, conviene imporre certi predicati nello stato finale in modo da indurre il solver a fare certe operazioni? Nah, meglio lasciare ragionare l'IA, noi siamo più ad alto livello
// - TODO: Introdurre un predicato per evitare di scrivere più schemi di azione
//  - conviene?
//  - quanto conviene?
//  - pazzerello paschello?
//
// in realtà posso provare a tenermi solo l'ultimo numero posizionato, e far combaciare l'ultima tessera con l'ultimo numero, e fare uno schema di azione per "posiziona al contrario"
//
// un simbolo di predicato zeroario?
//
// Mi serve un modo per indicare la "coda vuota", cioè: posiziona la prima tessera
//
// // ⟨1, 2⟩, ⟨1, 2⟩, ⟨1, 3⟩, ⟨3, 1⟩, ⟨2, 4⟩, ⟨2, 5⟩
//
// nella tessera l'ordine non conta, quindi se ci sta {1, 3} o {3, 1} è virtualmente la stessa cosa, in particolare, posso avere più tessere uguali in questo senso
//
//
// non posso fare rotazioni di 90 gradi, quindi già una semplificazione
//
// - potrei decidere se posizionare una tessera come ruotata oppure no
// mi aspetterei che un possibile schema d'azione sia *Posiziona(tessera X, rotazione)*, perché dovrei avere, in realtà, una memoria delle tessere posizionate!
//
// - una cosa certa che posso dire sullo stato finale è che ho posizionato tutte le tessere
// - beh, è semplice: basta che mi tengo un predicato *Posizionata* per vedere se una certa tessera è stata posizionata o meno, quando sono tutte posizionate ho finito
// - l'azione dovrà prendere una tessera che non è ancora posizionata
// - beh, questa è una stack

