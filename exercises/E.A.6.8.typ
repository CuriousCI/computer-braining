#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
#import "template.typ": *

#show: doc => conf([E.A.6.8 (Graph Colouring with Red Self-Loops)], doc)

== Modellazione

Dati i parametri $G = (V, E)$ siano
- $cal(C) = {R, B, C}$
- $X = { X_v^c | v in V and c in cal(C) }$ l'insieme di variabili dove
  - $X_v^c$ è vera se il nodo $v$ ha colore $c$

Il problema presenta 4 vincoli

$
  phi.alt = phi.alt_1 and phi.alt_2 and phi.alt_3 and phi.alt_4
$

(ALO) Ogni nodo ha almeno un colore

$
  phi.alt_1 = and.big_(v in V) or.big_(c in cal(C)) x_v^c
$

(AMO) Ogni nodo ha al più un colore

$
  phi.alt_2 & =
  and.big_(v in V \ c_1, c_2 in cal(C) \ c_1 < c_2)
  X_v^c_1 -> not X_v^c_2
$


1. Non esistono nodi collegati da un arco colorati con lo stesso colore.


$
  phi.alt_3 = and.big_((u, v) in E \ c in cal(C) \ u < v) X_u^c -> not X_v^c
$

2. Ogni nodo $v in V$ che ha un cappio (un arco da $v$ a $v$) è colorato con il colore $R$.

$
  phi.alt_4 = and.big_((v, v) in E) X_v^R
$

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

=== Variabili

$V = {
  #for (index, v) in V.enumerate() {
    $#v$
    if index + 1 < V.len() { $,$ }
  }
}$


$& E = { \
  #for (index, (u, v)) in E.enumerate() {
    if calc.rem-euclid(index, 5) == 0 { $& quad$ }
    $(#u, #v)$
    if u != v { $, (#v, #u),$ }
    if calc.rem-euclid(index, 5) == 4 { linebreak() }
  }
  & }$

$&X = { \
  #let index = 0
  #for v in V {
    for c in C {
      if index == 0 { $& quad$ }
      $X_#v^#c,$
      index += 1
      if calc.rem-euclid(index, 9) == 8 { linebreak() }
    }
  } \
  & }$

// #let index = 0;
// index += 1
// index = 0


=== Vincoli

$
  & phi.alt_"almeno_un_colore" = \
  #let i = 0;
  #for v in V {
    $#if i == 0 { $& quad$ } ($
    for c in C { $X_#v^#c #if c != "C" { $ or $ }$ }
    $) #if v != "S" { $and$ }$
    i += 1
    if i == 3 {
      i = 0
      linebreak()
    }
  } \
$

\

$
  & phi.alt_"al_più_un_colore" = \
  #let i = 0;
  #for v in V {
    for c1 in C {
      for c2 in C {
        if c1 < c2 {
          $#if i == 0 { $& quad$ }$
          $(not X_#v^#c1 or not X_#v^c2) and$
          i += 1
          if i == 3 {
            i = 0
            linebreak()
          }
        }
      }
    }
  } \
$

\

$
  & phi.alt_"nodi_adiacenti_colore_diverso" = \
  #let i = 0;
  #for (u, v) in E {
    for c in C {
      $#if i == 0 { $& quad$ }$
      if u != v { $(not X_#u^c or not X_#v^c) and$ }
      i += 1
      if i == 3 {
        i = 0
        linebreak()
      }
    }
  } \
$

$
  &phi.alt_"cappi" = X_J^R
$


// phi.alt = & phi.alt and \
// & phi.alt and \
// & phi.alt and \
// & phi.alt
// Siano $phi.alt_i, i in {1, ..., 4}$ i vincoli dell'insieme
// phi.alt = phi.alt_1 and phi.alt_2 and phi.alt_3 and phi.alt_4
// phi.alt = & phi.alt_"almeno_un_colore_per_nodo" and \
// & phi.alt_"al_più_un_colore_per_nodo" and \
// & phi.alt_"nodi_adiacenti_colore_diverso" and \
// & phi.alt_"cappi_colore_rosso"

// $
//   phi.alt_"almeno_un_colore" & =
//   and.big_(v in V)
//   or.big_(c in cal(C)) x_v^c
//   \
//   phi.alt_"al_più_un_colore" & =
//   and.big_(v in V \ c_1, c_2 in cal(C) \ c_1 < c_2)
//   X_v^c_1 -> not X_v^c_2
//   \
//   phi.alt_"nodi_adiacenti_colore_diverso" & =
//   and.big_((u, v) in E \ c in cal(C) \ u < v) X_u^c -> not X_v^c
//   \
//   phi.alt_"cappi" & =
//   and.big_((v, v) in E) X_v^R
// $

// #pagebreak()

// Almeno un colore
// for v in nodes.iter() {
//     let mut c = encoder.clause_builder();
//     for color in colors {
//         c.add(X(v, color));
//     }
//     encoder = c.end();
// }


// Al più un colore
// for v in nodes.iter() {
//     for (i_1, &color_1) in colors.iter().enumerate() {
//         for &color_2 in colors.iter().skip(i_1 + 1) {
//             let mut c = encoder.clause_builder();
//             c.add(Neg(X(v, color_1)));
//             c.add(Neg(X(v, color_2)));
//             encoder = c.end();
//         }
//     }
// }

// Nodi adiacenti colore diverso + Cappi
// for (u, v) in edges.iter() {
//     if u == v {
//         let mut c = encoder.clause_builder();
//         c.add(X(v, R));
//         encoder = c.end();
//     } else {
//         for color in colors {
//             let mut c = encoder.clause_builder();
//             c.add(Neg(X(u, color)));
//             c.add(Neg(X(v, color)));
//             encoder = c.end();
//         }
//     }
// }

#pagebreak()

== Codifica

```rust
use computer_braining::framework::sat_codec::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
enum Color {
    R,
    B,
    C,
}

type Node = &'static str;

#[derive(Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
struct X(Node, Color);

fn main() {
    use Color::*;
    use Literal::Neg;

    #[rustfmt::skip]
    let nodes = [
        "A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S"
    ];

    #[rustfmt::skip]
    let edges = [
        ("A", "E"), ("A", "H"), ("A", "I"), ("A", "S"),
        ("B", "C"), ("B", "G2"), ("B", "I"), ("B", "J"),
        ("B", "S"), ("C", "D"), ("C", "G2"), ("C", "S"),
        ("D", "E"), ("D", "S"), ("E", "G1"), ("E", "H"),
        ("G1", "H"), ("G2", "J"), ("H", "I"), ("J", "J")
    ];

    let colors = [R, B, C];

    let mut encoder = Encoder::new();

    // Almeno un colore
    for v in nodes.iter() {
        let mut c = encoder.clause_builder();
        for color in colors {
            c.add(X(v, color));
        }
        encoder = c.end();
    }

    // Al più un colore
    for v in nodes.iter() {
        for (i_1, &color_1) in colors.iter().enumerate() {
            for &color_2 in colors.iter().skip(i_1 + 1) {
                let mut c = encoder.clause_builder();
                c.add(Neg(X(v, color_1)));
                c.add(Neg(X(v, color_2)));
                encoder = c.end();
            }
        }
    }

    // Nodi adiacenti colore diverso + Cappi
    for (u, v) in edges.iter() {
        if u == v {
            let mut c = encoder.clause_builder();
            c.add(X(v, R));
            encoder = c.end();
        } else {
            for color in colors {
                let mut c = encoder.clause_builder();
                c.add(Neg(X(u, color)));
                c.add(Neg(X(v, color)));
                encoder = c.end();
            }
        }
    }

    encoder.end();
}
```

\
\

#let yellow = rgb("#fabd2f")
#let green = rgb("#b8bb26")
#let blue = rgb("#83a598")
#let red = rgb("#cc241d")

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
