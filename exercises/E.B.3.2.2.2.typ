#import "template.typ": *

#show: doc => conf([E.B.3.2.2.1 (I Rossi, Inferenza)], doc)

// #let f = $italic("false")$
// #let t = $italic("true")$

*NOTA*: uso una notazione più simile a quella del libro, l'ho trovata un po' più comoda.

#show math.equation: it => {
  show regex("P"): math.bold("P")
  show regex("\bt\b"): math.italic("true")
  // show regex("\bf\b"): math.italic("false")
  show regex("\bf\b"): math.bold("f")

  it
}

#let phi = math.italic("false")

// #let f(x) = $text(f)_#x$

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
    f_5 (C) = f_4(C, i) + f_4(C, not i) = vec(.99 \ .01) + vec(.9 \ .1) = vec(1.89 \ .11)\
    f_6 = f_3(c) times f_5(c) + f_3(not c) times f_5(not c) = .3 times 1.89 + .99 times .11 = .6759\
    "result" = alpha space f_1 times f_2 times f_6 = alpha space .15 times .6 times .6759 = alpha space .06083
  $
]

\

Non sono molto fiducioso di questo risultato...
