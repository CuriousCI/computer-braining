#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.1 (FOL: Studenti ansiosi, modelling)], doc)

\

#align(center, image("studenti-ansiosi.png", width: 60%))

\

#set math.equation(numbering: none)

- #highlight[
    $cal(P)$ = { \
    ~ *Studente*\/1, *Ansioso*\/1, *Esame*\/1, *Programma*\/1, \
    ~ _esame_superato_/2, _esame_programma_/2, \
    ~ _programma_studiato_/2 \
    }
  ]


- $cal(F) = {}$

\
#highlight[
  // $phi.alt$ = \
  ($forall$ $alpha$ *Studente*($alpha$) $->$ $not$ *Esame*($alpha$) $and$ $not$ *Programma*($alpha$)) $and$ \
  // ($forall$ $alpha$ *Studente*($alpha$) $->$ $not$ *Programma*($alpha$)) $and$ \
  ($forall$ $alpha$ *Esame*($alpha$) $->$ $not$ *Programma*($alpha$)) $and$ \
  ($forall$ $alpha$ *Ansioso*($alpha$) $->$ *Studente*($alpha$)) $and$ \
  ($forall$ $alpha$, $beta$ _esame_superato_($alpha$, $beta$) $->$ *Esame*($alpha$) $and$ *Studente*($beta$)) $and$ \
  ($forall$ $alpha$, $beta$ _esame_programma_($alpha$, $beta$) $->$ *Esame*($alpha$) $and$ *Programma*($beta$)) $and$ \
  ($forall$ $alpha$, $beta$ _programma_studiato_($alpha$, $beta$) $->$ *Programma*($alpha$) $and$ *Studente*($beta$)) $and$ \
  ($forall$ e *Esame*(e) $->$ $exists$ p _esame_programma_(e, p)) $and$ \
  ( \
  ~ $not$ $exists$ e, p1, p2 \
  ~~ p1 $!=$ p2 $and$ \
  ~~ _esame_programma_(e, p1) $and$ \
  ~~ _esame_programma_(e, p2) \
  ) $and$ \
  ( \
  ~ $forall$ s, e \
  ~~ _esame_superato_(s, e) $->$ \
  ~~~ $not$ *Ansioso*(s) $or$ \
  ~~~ $exists$ p _esame_programma_(e, p) $and$ _programma_studiato_(p, s) \
  )
]

- $D = {s, e, p, }$
- $M$ = {...}
- $I$ = {...}


// \
// \
// \
// ($forall$ $alpha$ $beta$ _esame_programma_($alpha$, $beta$) $->$ *Programma*($alpha$) $and$ *Studente*($beta$)) $and$ \
// \
//
// $
//   & forall s, e, p \
//   & quad ( \
//     & quad quad "Studente"(s) and \
//     & quad quad "Esame"(e) and \
//     & quad quad "programma"(e, p) and \
//     & quad quad ("Ansioso"(s) or not "studiato"(s, p) ) \
//     & quad ) -> \
//   & quad quad not "superato"(s, e)
// $


// - $cal(D) = {alpha, beta, gamma, eta}$
