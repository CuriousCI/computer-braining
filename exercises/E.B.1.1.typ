#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.B.1.1 (FOL: Studenti ansiosi, modelling)], doc)

\

#align(center, image("studenti-ansiosi.png", width: 63%))

\

#set math.equation(numbering: none)

- #fol[
    $cal(P)$ = { \
    ~ *Persona*\/1, *Studente*\/1, *PersonaAnsiosa*\/1, *Esame*\/1, \
    ~ *Programma*\/1, _esame_superato_/2, _esame_programma_/2, \
    ~ _programma_studiato_/2 \
    }
  ]


- $cal(F) = {}$

\
#fol[
  $phi.alt$ = ($forall$ $alpha$ *Persona*($alpha$) $->$ $not$ *Esame*($alpha$) $and$ $not$ *Programma*($alpha$)) $and$ \
  ($forall$ $alpha$ *Esame*($alpha$) $->$ $not$ *Programma*($alpha$)) $and$ \
  ($forall$ $alpha$ *PersonaAnsiosa*($alpha$) $->$ *Persona*($alpha$)) $and$ \
  ($forall$ $alpha$ *Studente*($alpha$) $->$ *Persona*($alpha$)) $and$ \
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
  ~ $forall$ studente, esame \
  ~~ _esame_superato_(studente, esame) $->$ \
  ~~~ $not$ *PersonaAnsiosa*(studente) $and$ \
  ~~~ $exists$ programma \
  ~~~~ _esame_programma_(esame, programma) $and$ \
  ~~~~ _programma_studiato_(programma, studente) \
  )
]

#pagebreak()

Sia $D = {alpha, beta, gamma}$ il dominio di interpretazione e sia $M$ un'interpretazione t.c.
#fol[
  - $M$(*Persona*) = ${alpha}$
  - $M$(*Studente*) = ${alpha}$
  - $M$(*PersonaAnsiosa*) = ${}$
  - $M$(*Esame*) = ${beta}$
  - $M$(*Programma*) = ${gamma}$
  - $M$(_esame_superato_) = ${(beta, alpha)}$
  - $M$(_esame_programma_) = ${(beta, gamma)}$
  - $M$(_programma_studiato_) = ${(gamma, alpha)}$
]

Si ha che $M tack.r.double phi.alt$ ($alpha$ è uno studente che ha superato l'esame $beta$, non è ansioso, e ne ha studiato il programma $gamma$)

\
Sia $I$ un'interpretazione t.c.
#fol[
  - $I$(*Persona*) = ${alpha}$
  - $I$(*Studente*) = ${alpha}$
  - $I$(*PersonaAnsiosa*) = ${alpha}$
  - $I$(*Esame*) = ${beta}$
  - $I$(*Programma*) = ${gamma}$
  - $I$(_esame_superato_) = ${(beta, alpha)}$
  - $I$(_esame_programma_) = ${(beta, gamma)}$
  - $I$(_programma_studiato_) = ${}$
]

Si ha che $I tack.r.double.not phi.alt$ perché $alpha$ è uno studente che ha superato l'esame $beta$, ma è ansioso e non ne ha studiato il programma $gamma$

// $phi.alt$ = \
// ($forall$ $alpha$ *Studente*($alpha$) $->$ $not$ *Programma*($alpha$)) $and$ \

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
