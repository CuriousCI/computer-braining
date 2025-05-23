#import "template.typ": *

#show: doc => conf([E.A.6.9 (Cards)], doc)

== Modellazione

Dati i paramentri $n, k$ siano
- $cal(N) = {1, ..., n}$
- $cal(K) = {1, ..., k}$
- $cal(P) = {1, ..., n dot.c k}$
- $"LP" = { X_(n, k, p) | n in cal(N) and k in cal(K) and p in cal(P) }$ l'insieme di lettere proposizionali t.c.
  - $X_(n, k, p)$ è vera se la $k$-esima variabile di valore $n$ è in posizione $p$

Il problema si può modellare con una serie di vincoli

$
  phi.alt = phi.alt_"ALO_pos" and phi.alt_"AMO_pos" and phi.alt_"dist_1" and phi.alt_"dist_2" and phi.alt_"alldiff"
$

(ALO) Ogni carta ha almeno una posizione.

$
  phi.alt_"ALO_pos" = and.big_(n in cal(N) \ k in cal(K)) or.big_(p in cal(P)) X_(n, k, p)
$

(AMO) Ogni carta ha al più una posizione.

$
  phi.alt_"AMO_pos" =
  and.big_(n in cal(N) \ k in cal(K) \ p_1, p_2 in cal(P) \ p_1 < p_2)
  X_(n, k, p_1) -> not X_(n, k, p_2)
$

Ogni carta contrassegnata dal numero $n$ deve essere in posizione tale da avere esattamente $n$ carte che la dividono dalla precedente carta contrassegnata dal numero $n$ (se esiste).

$
  phi.alt_"dist_1" =
  and.big_( n in cal(N) \ k in cal(K) \\ {K} \ p in cal(P) \ p + n + 1 in cal(P))
  X_(n, k, p) -> X_(n, k + 1, p + n + 1)
$

Bisogna restringere le posizioni possibili per una carta in modo che la carta successiva (dello lo stesso valore) possa essere posizionata.

$
  phi.alt_"dist_2" =
  and.big_( n in cal(N) \ k in cal(K) \\{K} \ p in cal(P) \ p + n + 1 in.not cal(P))
  not X_(n, k, p)
$

(alldifferent) Tutte le carte devono avere una posizione diversa

$
  phi.alt_"alldiff" =
  and.big_( n_1, n_2 in cal(N) \ k_1, k_2 in cal(N) \ p in cal(P) \ (n_1, k_1) < (n_2, k_2))
  X_(n_1, k_1, p) -> not X_(n_2, k_2, p)
$

#pagebreak()

== Istanziazione

#let (N, K) = (4, 2)

=== Parametri e variabili

$(n, k) = (#N, #K)$

$
  & "LP" = { \
    #let index = 0;
    #for n in range(1, N + 1) {
      for k in range(1, K + 1) {
        for p in range(1, K * N + 1) {
          if calc.rem(index, 8) == 0 { $& quad$ }
          $X_(#n, #k, #p)$
          if n <= N and k <= K and p < K * N { $,$ }
          if calc.rem(index, 8) == 7 { linebreak() }
          index += 1
        }
      }
    } \
    & }
$

=== Vincoli


(ALO) Ogni carta ha almeno una posizione.

#math.equation(block: true, numbering: none)[
  $
    & phi.alt_"ALO_pos" = \
    #let index = 0;
    #for n in range(1, N + 1) {
      for k in range(1, K + 1) {
        $& quad ($
        for p in range(1, K * N + 1) {
          $X_(#n, #k, #p)$
          if p != K * N { $or$ }
        }
        $)$
        index += 1
        if index < 8 { $and$ }
        linebreak()
      }
    }
  $
]

(AMO) Ogni carta ha al più una posizione.

#math.equation(block: true, numbering: none)[
  $
    & phi.alt_"AMO_pos" = \
    #let index = 0
    #for n in range(1, N + 1) {
      for k in range(1, K + 1) {
        for p1 in range(1, K * N + 1) {
          for p2 in range(p1 + 1, K * N + 1) {
            if calc.rem(index, 5) == 0 { $& quad$ }
            $(X_(#n, #k, #p1) -> not X_(#n, #k, #p2))$
            if index < 223 { $and$ }
            if calc.rem(index, 5) == 4 { linebreak() }
            index += 1
          }
        }
      }
    }
  $
]

Ogni carta contrassegnata dal numero $n$ deve essere in posizione tale da avere esattamente $n$ carte che la dividono dalla precedente carta contrassegnata dal numero $n$ (se esiste)

#math.equation(block: true, numbering: none)[
  $
    & phi.alt_"dist_1" = \
    #let index = 0;
    #for n in range(1, N + 1) {
      for k in range(1, K) {
        for p in range(1, K * N + 1) {
          if p + n + 1 <= K * N {
            if calc.rem(index, 3) == 0 { $& quad$ }
            $(X_(#n, #k, #p) -> X_(#n, #{ k + 1 }, #{ p + n + 1 }))$
            if index < 17 { $and$ }
            if calc.rem(index, 3) == 2 { linebreak() }
            index += 1
          }
        }
      }
    }
  $
]

Bisogna restringere le posizioni possibili per una carta in modo che la carta successiva (con lo stesso valore) possa essere posizionata.

#math.equation(block: true, numbering: none)[
  $
    & phi.alt_"dist_2" = \
    #let index = 0
    #for n in range(1, N + 1) {
      for k in range(1, K) {
        for p in range(1, K * N + 1) {
          if p + n + 1 > K * N {
            if calc.rem(index, 7) == 0 { $& quad$ }
            $not X_(#n, #k, #p)$
            if index < 13 { $and$ }
            if calc.rem(index, 7) == 6 { linebreak() }
            index += 1
          }
        }
      }
    }
  $
]

(alldifferent) Tutte le carte devono avere una posizione diversa

#math.equation(block: true, numbering: none)[
  $
    & phi.alt_"alldiff" = \
    #let index = 0
    #for n1 in range(1, N + 1) {
      for n2 in range(1, N + 1) {
        for k1 in range(1, K + 1) {
          for k2 in range(1, K + 1) {
            for p in range(1, K * N + 1) {
              if (n1, k1) < (n2, k2) {
                if calc.rem(index, 5) == 0 { $& quad$ }
                $(X_(#n1, #k1, #p) -> not X_(#n2, #k2, #p))$
                if index < 223 { $and$ }
                if calc.rem(index, 5) == 4 { linebreak() }
                index += 1
              }
            }
          }
        }
      }
    }
  $
]

#pagebreak()

== Codifica

```rust
use crate::encoder::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub struct X(usize, usize, usize);

pub fn encode_instance(card_k: usize, card_n: usize) -> (String, Vec<X>) {
    use Literal::Neg;

    let mut encoder = EncoderSAT::new();
    let card_p = card_n * card_k;

    // ALO_pos
    for n in 1..=card_n {
        for k in 1..=card_k {
            encoder.add((1..=card_p).map(|p| X(n, k, p).into()).collect());
        }
    }

    // AMO_pos
    for n in 1..=card_n {
        for k in 1..=card_k {
            for p1 in 1..=card_p {
                for p2 in p1 + 1..=card_p {
                    encoder.add(vec![Neg(X(n, k, p1)), Neg(X(n, k, p2))])
                }
            }
        }
    }

    // dist_1 + dist_2
    for n in 1..=card_n {
        for k in 1..card_k {
            for p in 1..=card_p {
                if p + n < card_p {
                    encoder.add(vec![Neg(X(n, k, p)), X(n, k + 1, p + n + 1).into()])
                } else {
                    encoder.add(vec![Neg(X(n, k, p))]);
                }
            }
        }
    }

    // alldifferent
    for n1 in 1..=card_n {
        for n2 in 1..=card_n {
            for k1 in 1..=card_k {
                for k2 in 1..=card_k {
                    for p in 1..=card_p {
                        if (n1, k1) < (n2, k2) {
                            encoder.add(vec![Neg(X(n1, k1, p)), Neg(X(n2, k2, p))]);
                        }
                    }
                }
            }
        }
    }

    encoder.end()
}
```

#pagebreak()

== Statistiche
