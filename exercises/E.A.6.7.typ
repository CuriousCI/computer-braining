#import "template.typ": *

#show: doc => conf([E.A.6.7 (HC-VIP)], doc)

#let casa = emph(math.italic[casa])
#let bus = emph(math.italic[bus])

== Modellazione

Dati i parametri $I, V, G = (I, "bus")$ t.c.
- $#casa in I$
- $V subset.eq I \/ {#casa}$
- $#bus subset.eq I times I$
- $|V| <= (|I|) / 2$

Si definiscono le variabili

- $P = |I| - 1$ è il numero di #bus da prendere (o il numero di _passi_ da effettuare) per visitare tutti i nodi escluso #casa
- $cal(P) = {1, ..., P}$
- $cal(I) = I \\ {#casa}$
- $"LP" = { X_i^p | i in cal(I) and p in cal(P)}$ l'insieme di lettere proposizionali dove
  - $X_i^p$ è vera se l'indirizzo $i$ è stato visitato al passo $p$

Il problema si può modellare nel seguente modo

#math.equation(block: true, numbering: none)[
  $
    phi.alt =
    phi.alt_"ALO_ind" and
    phi.alt_"AMO_ind" and
    phi.alt_"ALO_pass" and
    phi.alt_"AMO_pass" and
    phi.alt_(#casa\_1) and
    phi.alt_(#casa\_2) and
    phi.alt_#bus and
    phi.alt_"VIP"
  $
]

(ALO) Ad ogni passo viene visitato almeno un indirizzo

$
  phi.alt_"ALO_ind" =
  and.big_(p in cal(P))
  or.big_(i in cal(I))
  X_i^p
$

(AMO) Ad ogni passo viene visitato al più un indirizzo

$
  phi.alt_"AMO_ind" =
  and.big_(p in cal(P) \ i_1, i_2 in cal(I) \ i_1 < i_2)
  X_(i_1)^p -> not X_(i_2)^p
$

(ALO) Ogni indirizzo viene visitato ad almeno un passo

$
  phi.alt_"ALO_pass" =
  and.big_(i in cal(I))
  or.big_(p in cal(P))
  X_i^p
$

(AMO) Ogni indirzzo viene visitatao ad al più un passo

$
  phi.alt_"AMO_pass" =
  and.big_(i in cal(I) \ p_1, p_2 in cal(P) \ p_1 < p_2 )
  X_i^(p_1) -> not X_i^(p_2)
$

1. Partenza da casa la mattina (se l'indirizzo $i$ *non è raggiungibile* tramite #bus da #casa, allora non può essere il primo passo)

$
  phi.alt_(#casa\_1) =
  and.big_(i in cal(I) \ (#casa, i) in.not #bus)
  not X_i^1
$

2. Ritorno a casa la sera (se dall'indirizzo $i$ *non si può raggiungere* #casa tramite #bus, $i$ non può essere l'ultimo passo)

$
  phi.alt_(#casa\_2) =
  and.big_(i in cal(I) \ (i, #casa) in.not #bus)
  not X_i^P
$

3. Dal cliente al passo $p$ bisogna usare un #bus per raggiungere il cliente al passo $p + 1$
  - Se al passo $p$ si visita l'indirizzo $i$, al passo $p + 1$ *non si può raggiungere* l'indirizzo $j$ se non c'è un #bus da $i$ a $j$

$
  phi.alt_#bus =
  and.big_(p in cal(P) \\ {P} \ i, j in cal(I) \ (i, j) in.not #bus)
  X_i^p -> not X_j^(p + 1)
$

4. I clienti VIP devono essere visitati nella prima metà del percorso
  - I clienti VIP *non* si possono visitare nella seconda metà del percorso

$
  phi.alt_"VIP"
  and.big_(v in cal(V) \ p in cal(P) \ p > ceil(P / 2))
  not X_v^p
$

#pagebreak()

== Istanziazione

=== Parametri e variabili

#let E = (
  (1, 2),
  (1, 3),
  (2, 4),
  (2, 5),
  (3, 1),
  (3, 5),
  (4, 1),
  (4, 5),
  (5, 2),
  (5, 3),
)

#let I = (2, 3, 4, 5)
#let P = (1, 2, 3, 4)
#let V = (2,)

- $I = {#casa, i_2, i_3, i_4, i_5}$
- $V = {i_2}$
- $& bus = { \
    & quad (casa, i_2), (casa, i_3), (i_2, i_4), (i_2, i_5), (i_3, casa), \
    & quad (i_3, i_5), (i_4, casa), (i_4, i_5), (i_5, i_2), (i_5, i_3) \
    & }$

- $P = 4$
- $cal(P) = {1, 2, 3, 4}$
- $cal(I) = {i_2, i_3, i_4, i_5}$

#set math.equation(numbering: none)

$& "LP" = { \
  #let index = 0;
  #for p in P {
    for i in I {
      if calc.rem(index, 8) == 0 { $& quad$ }
      $X_(i_#i)^#p$
      if index < 15 { $,$ }
      if calc.rem(index, 8) == 7 { linebreak() }
      index += 1
    }
  }
  & }$

=== Vincoli

(ALO) Ad ogni passo viene visitato almeno un indirizzo

$
  & phi.alt_"ALO_ind" = \
  #let index = 0
  #for p in P {
    if calc.rem(index, 2) == 0 { $& quad$ }
    $($
    for i in I {
      $X_(i_#i)^#p$
      if i < 5 { $or$ }
    }
    $)$
    if index < 3 { $and$ }
    if calc.rem(index, 2) == 1 { linebreak() }
    index += 1
  }
$

(AMO) Ad ogni passo viene visitato al più un indirizzo

$
  & phi.alt_"AMO_ind" = \
  #let index = 0
  #for p in P {
    for i1 in I {
      for i2 in I {
        if i1 < i2 {
          if calc.rem(index, 3) == 0 { $& quad$ }
          $(X_(i_#i1)^#p -> not X_(i_#i2)^#p)$
          if index < 23 { $and$ }
          if calc.rem(index, 3) == 2 { linebreak() }
          index += 1
        }
      }
    }
  }
$

(ALO) Ogni indirizzo viene visitato ad almeno un passo

$
  & phi.alt_"ALO_pass" = \
  #let index = 0
  #for i in I {
    if calc.rem(index, 2) == 0 { $& quad$ }
    $($
    for p in P {
      $X_(i_#i)^#p$
      if p < 4 { $or$ }
    }
    $)$
    if index < 3 { $and$ }
    if calc.rem(index, 2) == 1 { linebreak() }
    index += 1
  }
$

(AMO) Ogni indirzzo viene visitatao ad al più un passo

$
  & phi.alt_"AMO_pass" = \
  #let index = 0
  #for i in I {
    for p1 in P {
      for p2 in P {
        if p1 < p2 {
          if calc.rem(index, 3) == 0 { $& quad$ }
          $(X_(i_#i)^#p1 -> not X_(i_#i)^#p2)$
          if index < 23 { $and$ }
          if calc.rem(index, 3) == 2 { linebreak() }
          index += 1
        }
      }
    }
  }
$

1. Partenza da casa la mattina (se l'indirizzo $i$ *non è raggiungibile* tramite #bus da #casa, allora non può essere il primo passo)

$
  phi.alt_(#casa\_1) =
  #for i in I {
    if not ((1, i) in E) {
      $not X_#i^1$
      if i == 4 { $and$ }
    }
  }
$

2. Ritorno a casa la sera (se dall'indirizzo $i$ *non si può raggiungere* #casa tramite #bus, $i$ non può essere l'ultimo passo)

$
  phi.alt_(#casa\_2) =
  #for i in I {
    if not ((i, 1) in E) {
      $not X_#i^4$
      if i == 2 { $and$ }
    }
  }
$

3. Dal cliente al passo $p$ bisogna usare un #bus per raggiungere il cliente al passo $p + 1$
  - Se al passo $p$ si visita l'indirizzo $i$, al passo $p + 1$ *non si può raggiungere* l'indirizzo $j$ se non c'è un #bus da $i$ a $j$

$
  & phi.alt_#bus = \
  #let index = 0
  #for p in P {
    for i in I {
      for j in I {
        if not ((i, j) in E) {
          if calc.rem(index, 4) == 0 { $& quad$ }
          $(X_#i^#p -> not X_#j^#{ p + 1 })$
          if index < 39 { $and$ }
          if calc.rem(index, 4) == 3 { linebreak() }
          index += 1
        }
      }
    }
  }
$

4. I clienti VIP devono essere visitati nella prima metà del percorso
  - I clienti VIP *non* si possono visitare nella seconda metà del percorso

$
  phi.alt_"VIP" =
  #for v in V {
    for p in P {
      if p > 2 {
        $not X_#v^#p$
        if p == 3 { $and$ }
      }
    }
  }
$

#pagebreak()

== Codifica (a questo giro in Rust)

```rust
use crate::encoder::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub struct X(usize, usize);

pub fn encode_instance(
    addresses: usize, // esclusa "casa"
    buses: &[(usize, usize)],
    vips: &[usize],
) -> (String, Vec<X>) {
    use Literal::Neg;
    let steps = addresses;

    let mut encoder = EncoderSAT::new();

    // ALO_ind
    for p in 1..=steps {
        encoder.add((2..=addresses + 1).map(|i| X(i, p).into()).collect())
    }

    // AMO_ind
    for p in 1..=steps {
        for i1 in 2..=addresses + 1 {
            for i2 in i1 + 2..addresses + 1 {
                encoder.add(vec![Neg(X(i1, p)), Neg(X(i2, p))])
            }
        }
    }

    // ALO_pass
    for i in 2..=addresses + 1 {
        encoder.add((1..=steps).map(|p| X(i, p).into()).collect());
    }

    // AMO_pass
    for i in 2..=addresses + 1 {
        for p1 in 1..=steps {
            for p2 in p1 + 1..=steps {
                encoder.add(vec![Neg(X(i, p1)), Neg(X(i, p2))]);
            }
        }
    }

    // casa_1
    for i in 2..=addresses + 1 {
        if !buses.contains(&(1, i)) {
            encoder.add(vec![Neg(X(i, 1))]);
        }
    }

    // casa_2
    for i in 2..=addresses + 1 {
        if !buses.contains(&(i, 1)) {
            encoder.add(vec![Neg(X(i, steps))]);
        }
    }

    // bus
    for p in 1..steps {
        for i in 2..=addresses + 1 {
            for j in 2..=addresses + 1 {
                if !buses.contains(&(i, j)) {
                    encoder.add(vec![Neg(X(i, p)), Neg(X(j, p + 1))]);
                }
            }
        }
    }

    // VIP
    for &v in vips {
        for p in steps.div_ceil(2) + 1..=steps {
            encoder.add(vec![Neg(X(v, p))]);
        }
    }

    encoder.end()
}
```
