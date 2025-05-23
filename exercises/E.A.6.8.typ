#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
#import "logic.typ": *
#import "template.typ": *

#show: doc => conf([E.A.6.8 (Graph Colouring with Red Self-Loops)], doc)

== Modellazione

Dati i parametri $G = (V, E)$ siano
- $cal(C) = {R, B, C}$
- $"LP" = { X_v^c | v in V and c in cal(C) }$ l'insieme di lettere proposizionali t.c.
  - $X_v^c$ è vera se il nodo $v$ ha colore $c$

Il problema presenta 4 vincoli

#math.equation(block: true, numbering: none)[
  $
    phi.alt = phi.alt_"ALO_col" and phi.alt_"AMO_col" and phi.alt_"col" and phi.alt_"loop"
  $
]


(ALO) Ogni nodo ha almeno un colore.

$
  phi.alt_"ALO_col" = and.big_(v in V) or.big_(c in cal(C)) x_v^c
$

(AMO) Ogni nodo ha al più un colore.

$
  phi.alt_"AMO_col" & =
  and.big_(v in V \ c_1, c_2 in cal(C) \ c_1 < c_2)
  X_v^c_1 -> not X_v^c_2
$

1. Non esistono nodi collegati da un arco colorati con lo stesso colore.

$
  phi.alt_"col" = and.big_((u, v) in E \ c in cal(C) \ u < v) X_u^c -> not X_v^c
$

2. Ogni nodo $v in V$ che ha un cappio (un arco da $v$ a $v$) è colorato con il colore $R$.

$
  phi.alt_"loop" = and.big_((v, v) in E) X_v^R
$

#pagebreak()

== Istanziazione

#let V = ("A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S")

#let E = (
  ("A", "E"),
  ("A", "H"),
  ("A", "I"),
  ("A", "S"),
  ("B", "C"),
  ("B", "G2"),
  ("B", "I"),
  ("B", "J"),
  ("B", "S"),
  ("C", "D"),
  ("C", "G2"),
  ("C", "S"),
  ("D", "E"),
  ("D", "S"),
  ("E", "G1"),
  ("E", "H"),
  ("G1", "H"),
  ("G2", "J"),
  ("H", "I"),
  ("J", "J"),
)

#let C = ("R", "B", "C")

=== Parametri e variabili

$V = {
  #for (index, v) in V.enumerate() {
    $#v$
    if index + 1 < V.len() { $,$ }
  }
}$

$& E = { \
  #for (index, (u, v)) in E.enumerate() {
    if calc.rem(index, 5) == 0 { $& quad$ }
    $(#u, #v)$
    if u != v { $, (#v, #u),$ }
    if calc.rem(index, 5) == 4 { linebreak() }
  }
  & }$

#set math.equation(numbering: none)

$
  &"LP" = { \
    #let index = 0
    #for v in V {
      for c in C {
        if calc.rem(index, 9) == 0 { $& quad$ }
        $X_#v^#c$
        if v != "S" or c != "C" { $,$ }
        if calc.rem(index, 9) == 8 { linebreak() }
        index += 1
      }
    } \
    & }
$

=== Vincoli

(ALO) Ogni nodo ha almeno un colore.

$
  & phi.alt_"ALO_col" = \
  #let index = 0;
  #for v in V {
    if calc.rem(index, 4) == 0 { $& quad$ }
    $($
    for c in C {
      $X_#v^#c$
      if c != "C" { $or$ }
    }
    $)$
    if v != "S" { $and$ }
    if calc.rem(index, 4) == 3 { linebreak() }
    index += 1
  } \
$

(AMO) Ogni nodo ha al più un colore.

$
  & phi.alt_"AMO_col" = \
  #let index = 0;
  #for v in V {
    for c1 in C {
      for c2 in C {
        if c1 < c2 {
          if calc.rem(index, 4) == 0 { $& quad$ }
          $(not X_#v^#c1 or not X_#v^c2)$
          if index < 32 { $and$ }
          if calc.rem(index, 4) == 3 { linebreak() }
          index += 1
        }
      }
    }
  } \
$

1. Non esistono nodi collegati da un arco colorati con lo stesso colore.

$
  & phi.alt_"col" = \
  #let index = 0;
  #for (u, v) in E {
    for c in C {
      if calc.rem(index, 4) == 0 { $& quad$ }
      if u != v { $(not X_#u^#c or not X_#v^#c)$ }
      if index < 56 { $and$ }
      if calc.rem(index, 4) == 3 { linebreak() }
      index += 1
    }
  } \
$

2. Ogni nodo $v in V$ che ha un cappio (un arco da $v$ a $v$) è colorato con il colore $R$.

$
  &phi.alt_"loop" = X_J^R
$


#figure(caption: [soluzione generata da `picosat`])[
  #diagram(
    node-stroke: 1pt + green,
    node-shape: circle,
    edge-stroke: 1pt + gray,
    spacing: 2em,
    label-sep: .5pt,

    node((4, 1), [*A*], name: <A>),
    edge(<A>, <E>, "-"),
    edge(<A>, <H>, "-"),
    edge(<A>, <I>, "-"),
    edge(<A>, <S>, "-"),

    node((6, 1), [*B*], name: <B>),
    edge(<B>, <C>, "-"),
    edge(<B>, <G2>, "-"),
    edge(<B>, <I>, "-"),
    edge(<B>, <J>, "-"),
    edge(<B>, <S>, "-"),

    node((6, 3), [*C*], name: <C>, stroke: red),
    edge(<C>, <D>, "-"),
    edge(<C>, <G2>, "-"),
    edge(<C>, <S>, "-"),

    node((2, 3), [*D*], name: <D>),
    edge(<D>, <E>, "-"),
    edge(<D>, <S>, "-"),

    node((1, 2), [*E*], name: <E>, stroke: blue),
    edge(<E>, <G1>, "-"),
    edge(<E>, <H>, "-"),

    node((0, 0), [*G1*], name: <G1>),
    edge(<G1>, <H>, "-"),

    node((7, 1), [*G2*], name: <G2>, stroke: blue),
    edge(<G2>, <J>, "-"),

    node((2, 0), [*H*], name: <H>, stroke: red),
    edge(<H>, <I>, "-"),

    node((4, 0), [*I*], name: <I>, stroke: blue),

    node((6, 0), [*J*], name: <J>, stroke: red),
    edge(<J>, <J>, "-", bend: 140deg),

    node((4, 2), [*S*], name: <S>, stroke: blue),
  )
]

#pagebreak()

== Codifica

```rust
use crate::encoder::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub enum Color {
    R,
    B,
    C,
}

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub struct X<T>(T, Color);

pub fn encode_instance<T>(vertices: &[T], edges: &[(T, T)]) -> (String, Vec<X<T>>)
where
    T: std::cmp::Eq + std::hash::Hash + std::fmt::Debug + Serialize + Clone + Copy,
{
    use Literal::Neg;
    let colors = [Color::R, Color::B, Color::C];

    let mut encoder = EncoderSAT::new();

    // ALO_col
    for &v in vertices {
        encoder.add(colors.into_iter().map(|color| X(v, color).into()).collect());
    }

    // AMO_col
    for &v in vertices {
        for (i_1, &color_1) in colors.iter().enumerate() {
            for &color_2 in colors.iter().skip(i_1 + 1) {
                encoder.add(vec![Neg(X(v, color_1)), Neg(X(v, color_2))]);
            }
        }
    }

    // col + loop
    for &(u, v) in edges {
        if u == v {
            encoder.add(vec![X(v, Color::R).into()])
        } else {
            for color in colors {
                encoder.add(vec![Neg(X(u, color)), Neg(X(v, color))]);
            }
        }
    }

    encoder.end()
}
```
