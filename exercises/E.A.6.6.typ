#import "template.typ": *

#show: doc => conf([E.A.6.6 (Edge Colouring)], doc)

#show math.equation.where(block: true): set block(breakable: true)
#set math.equation(numbering: none)

== Modellazione

Dato un grafo non diretto $G = (V, E)$ siano
- $cal(C) = {1, 2, 3}$
// - $cal(E) = {1, ..., |E|}$

- $X = { X_(u, v)^c | (u, v) in E and c in cal(C)}$ l'insieme di variabili t.c.
  - $X_(u, v)^c$ è vera se l'arco $(u, v) in E$ ha colore $c$

\

$
  & phi.alt = phi.alt_"almeno_un_colore_per_arco" and \
  & quad phi.alt_"al_più_un_colore_per_arco" and \
  & quad phi.alt_"triangoli"
$

\

$
  phi.alt_"almeno_un_colore_per_arco" & = and.big_((u, v) in E) (or.big_(c in cal(C)) X_(u, v)^c) \
  phi.alt_"al_più_un_colore_per_arco" & = and.big_((u, v) in E \ c_1 in cal(C) \ c_2 in cal(C) \ c_1 < c_2) (X_(u, v)^(c_1) -> not X_(u, v)^(c_2)) \
  phi.alt_"triangoli" & = and.big_(t in V \ u in V \ v in V \ (t, u) in E \ (u, v) in E \ (v, t) in E \ c in cal(C)) (X_(t, u)^c and X_(u, v)^c -> not X_(v, t)^c)
$

\

#pagebreak()

== Istanziazione


#pagebreak()

== Codifica

=== EdgeColouringToSAT

=== SATToEdgeColouring
