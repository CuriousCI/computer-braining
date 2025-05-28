#import "template.typ": *

#show: doc => conf([E.B.3.2.2.1 (I Rossi, Inferenza)], doc)

*NOTA*: uso una notazione più simile a quella del libro, l'ho trovata un po' più comoda.

#show math.equation: it => {
  show regex("P"): math.bold("P")
  show regex("\bt\b"): math.italic("true")
  show regex("\bf\b"): math.bold("f")

  it
}

#let phi = math.italic("false")

== Inferenza incompleta ma educativa

\

#math.equation(block: true, numbering: none)[
  $
    P(F = t | L = t, A = phi) = \
    alpha sum_c sum_i P(F = t) P(L = t | F = t) P(A = phi | C = c) P(C = c | I = i, F = t) = \
    {"spostamento dei termini fuori dalle sommatorie"} \
    \
    alpha P(F = t) P(L = t | F = t) sum_c P(A = phi | C = c) sum_i P(C = c | I = i, F = t) = \
    {"eliminazione delle variabili"}
    \
    alpha space f_1 times f_2 times sum_c f_3 (C) times sum_i f_4(C, I) = \
    {"calcolo dei fattori"}
    \
    f_5 (C) = f_4(C, i) + f_4(C, not i) = vec(.99, .01) + vec(.9, .1) = vec(1.89, .11)\
    f_6 = f_3(c) times f_5(c) + f_3(not c) times f_5(not c) = .3 times 1.89 + .99 times .11 = .6759\
    "result" = alpha space f_1 times f_2 times f_6 = alpha space .15 times .6 times .6759 = alpha space .06083
  $
]

\

#pagebreak()

== Inferenza completa


#math.equation(block: true, numbering: none)[
  $
    P(F | L = t, A = phi) = \
    alpha sum_c sum_i P(F) P(L = t | F) P(A = phi | C = c) P(C = c | I = i, F) = \
    {"spostamento dei termini fuori dalle sommatorie"} \
    \
    alpha P(F) P(L = t | F) sum_c P(A = phi | C = c) sum_i P(C = c | I = i, F) = \
    {"eliminazione delle variabili"}
    \
    alpha space f_1(F) times f_2(F) times sum_c f_3(C) times sum_i f_4(C, I, F) = \
    {"calcolo dei fattori"} \
    \
    f_5(C, F) = f_4(C, i, F) + f_4(C, not i, F) = mat(.99, .97; .01, .03;) + mat(.9, .3; .1, .7;) = mat(1.89, 1; .11, .73;) \
    f_6(F) = f_3(c) times f_5(c, F) + f_3(not c) times f_5(not c, F) = .3 times vec(1.89, 1) + .99 times vec(.11, .73) = vec(.567, .3) + vec(.1088, .7227) = vec(.6758, 1.0227) \
    "result" = alpha space f_1(F) times f_2(F) times f_6(F) = alpha space vec(.15, .85) times vec(.6, .05) times vec(.6758, 1.0227) = alpha space vec(.09, .0425) times vec(.6758, 1.0227) = \
    alpha space vec(.060822, .04346475) = 9.588945863208894 vec(.060822, .04346475) = vec(0.5832188652920913, 0.4167811347079088)
  $
]

\

I rossi hanno una probabilità del 58.3% di stare fuori casa.

// 1/ 0.10428675 = 9.588945863208894
