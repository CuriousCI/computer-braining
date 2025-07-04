#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.3 (FOL: Aldo, modelling)], doc)

\

#align(center, image("aldo.png", width: 100%))

\

#show math.equation.where(block: true): set block(breakable: true)
#set math.equation(numbering: none)

- #fol[
        $cal(P)$ = { \
        ~ *Persona*\/1, *HaIlSonnoLeggero*\/1, *Animale*\/1, \
        ~ *Cane*\/1, *Gatto*\/1, *Topo*\/1, *CaneDaCaccia*\/1, \
        ~ *AbbaiaDiNotte*\/1, _possiede_\/2, _ha_in_casa_\/2 \
        }
    ]


- $cal(F) = {"Aldo"\/0}$

\
#fol[
    $phi.alt$ = \
    ~ $forall$ o *Persona*(o) $->$ $not$ *Animale*(o) $and$ \
    ~ $forall$ o *HaIlSonnoLeggero*(o) $->$ *Persona*(o) $and$ \
    ~ $forall$ o *Cane*(o) $->$ *Animale*(o) $and$ \
    ~ $forall$ o *Gatto*(o) $->$ *Animale*(o) $and$ \
    ~ $forall$ o *Topo*(o) $->$ *Animale*(o) $and$ \
    ~ $forall$ o *Cane*(o) $->$ $not$ *Gatto*(o) $and$ \
    ~ $forall$ o *Cane*(o) $->$ $not$ *Topo*(o) $and$ \
    ~ $forall$ o *Gatto*(o) $->$ $not$ *Topo*(o) $and$ \
    ~ $forall$ o *AbbaiaDiNotte*(o) $->$ *Cane*(o) $and$ \
    ~ $forall$ o *CaneDaCaccia*(o) $->$ *AbbaiaDiNotte*(o) $and$ \
    ~ $forall$ p, a _possiede_(p, a) $->$ *Persona*(p) $and$ *Animale*(a) $and$ \
    ~ $forall$ p, a _ha_in_casa_(p, a) $->$ _possiede_(p, a) $and$ \
    ~ $forall$ p1, p2, a p1 != p2 $and$ _ha_in_casa_(p1, a) $->$ $not$ _ha_in_casa_(p2, a) $and$ \
    ~ $forall$ p, g _possiede_(p, g) $and$ *Gatto*(g) $->$ \
    ~~ $not$ $exists$ t *Topo*(t) $and$ _ha_in_casa_(p, t) \
    ~ $and$ \
    ~ $forall$ p *HaIlSonnoLeggero*(p) $->$ \
    ~~ $not$ $exists$ a *AbbaiaDiNotte*(a) $and$ _possiede_(p, a) \
    ~ $and$ \
    ~ *Persona*(Aldo) $and$ \
    ~ $exists$ a _possiede_(Aldo, a) $and$ (*Gatto*(a) $or$ *CaneDaCaccia*(a))
]

#pagebreak()

Sia $D = {a, c, g, t}$ il dominio di interpretazione e sia $M$ un'interpretazione t.c.

#fol[
    - $M$(Aldo) = $a$
    - $M$(*Persona*) = ${a}$
    - $M$(*HaIlSonnoLeggero*) = ${a}$
    - $M$(*Animale*) = ${c, g, t}$
    - $M$(*Cane*) = ${c}$
    - $M$(*Gatto*) = ${g}$
    - $M$(*Topo*) = ${t}$
    - $M$(*CaneDaCaccia*) = ${c}$
    - $M$(*AbbaiaDiNotte*) = ${c}$
    - $M$(_possiede_) = ${(a, g)}$
    - $M$(_ha_in_casa_) = ${(a, g)}$
]

Si ha che $M tack.r.double phi.alt$ perché il simbolo di costante $"Aldo"$ ha come valore l'oggetto $a$ che è una persona. Inoltre, $"Aldo"$ ha un gatto $g$. Oltrettutto $c$ è un #fol[*CaneDaCaccia*, *AbbaiaDiNotte* ed è un *Animale*], e t è un #fol[*Topo* e un *Animale*].

\
Sia $I$ un'interpretazione t.c.

#fol[
    - $I$(Aldo) = $a$
    - $I$(*Persona*) = ${a}$
    - $I$(*HaIlSonnoLeggero*) = ${a}$
    - $I$(*Animale*) = ${c, g, t}$
    - $I$(*Cane*) = ${c}$
    - $I$(*Gatto*) = ${g}$
    - $I$(*Topo*) = ${t}$
    - $I$(*CaneDaCaccia*) = ${c}$
    - $I$(*AbbaiaDiNotte*) = ${c}$
    - $I$(_possiede_) = ${(a, g)}$
    - $I$(_ha_in_casa_) = ${(a, g), (a, t)}$
]

Si ha che $I tack.r.double.not phi.alt$ Aldo #fol[_possiede_] sia un gatto $g$ sia un topo $t$.
