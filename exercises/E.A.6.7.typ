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

Si definiscono le seguenti variabili:

- $T = |I|$ è il numero di #bus da prendere in un percorso che parte da #casa, visita tutti gli indirizzi esattamente una volta e ritorna a #casa
  - servono $|I| - 1$ #bus per visitare tutti gli indirizzi esattamente una volta più $1$ #bus per tornare a casa a fine giornata
- $cal(T) = {1, ..., T}$
- $cal(I) = {1, ..., |I|}$ l'insieme di identificatori per cui esiste una funzione $id$ biettiva t.c.
  $ id : cal(I) -> I " e " id(1) = #casa $
- $cal(V) = { i | i in cal(I) and exists v space v in V and id(i) = v}$
- $X = { X_(i, j)^t | (i, j) in #bus and t in cal(T)}$ l'insieme di variabili dove
  - $X_(i, j)^t$ è vera se l'arco $(i, j) in #bus$ è stato percorso al $t$-esimo passo

\

$
  phi.alt = & phi.alt_"almeno_un_arco_per_passo" and \
  & phi.alt_"al_più_un_arco_per_passo" and \
  & phi.alt_"almeno_un_arco_per_indirizzo" and \
  & phi.alt_"al_più_un_arco_per_indirizzo" and \
  & phi.alt_"clienti_VIP_nella_prima_metà" and \
  & phi.alt_"partenza_da_casa" and \
  & phi.alt_"arrivo_a_casa" and \
  & phi.alt_"percorso_valido"
$

\

$
  phi.alt_"almeno_un_arco_per_passo" & =
  and.big_(t in cal(T))
  or.big_((i, j) in #bus)
  X_(i, j)^t
  \
  phi.alt_"al_più_un_arco_per_passo" & =
  and.big_(t in cal(T) \ (i_1, j_1), (i_2, j_2) in #bus \ (i_1, j_1) < (i_2, j_2))
  X_(i_1, j_1)^t -> not X_(i_2, j_2)^t
  \
  phi.alt_"almeno_un_arco_per_indirizzo" & =
  and.big_(j in cal(I))
  or.big_(t in cal(T) \ (i, j) in #bus)
  X_(i, j)^t
  \
  phi.alt_"al_più_un_arco_per_indirizzo" & =
  and.big_(t_1, t_2 in cal(T) \ (i_1, j), (i_2, j) in #bus \ t_1 <= t_2 \ i_1 < i_2 )
  X_(i_1, j)^(t_1) -> not X_(i_2, j)^(t_2)
  \
  phi.alt_"clienti_VIP_nella_prima_metà" & =
  and.big_(v in cal(V) )
  or.big_(t in cal(T) \ t <= ceil(T / 2) \ (i, v) in #bus )
  X_(i, v)^t
  \
  phi.alt_"partenza_da_casa" & =
  or.big_(i in cal(I) \\ {1} \ (1, i) in #bus)
  X_(1, i)^1
  \
  phi.alt_"arrivo_a_casa" & =
  or.big_(i in cal(I) \\ {1} \ (i, 1) in #bus)
  X_(i, 1)^T
  \
  phi.alt_"percorso_valido" & =
  and.big_(t in cal(T) \\ {T} \ (i, j) in #bus)
  X_(i, j)^t ->
  or.big_((j, k) in #bus)
  X_(j, k)^(t + 1)
$


#pagebreak()

== Istanziazione

=== Variabili

// Dati i parametri $I, V, G = (I, "bus")$ t.c.
// - $#casa in I$
// - $V subset.eq I \/ {#casa}$
// - $#bus subset.eq I times I$
// - $|V| <= (|I|) / 2$
//
// Si definiscono le seguenti variabili:
//
// - $T = |I|$ è il numero di #bus da prendere in un percorso che parte da #casa, visita tutti gli indirizzi esattamente una volta e ritorna a #casa
//   - servono $|I| - 1$ #bus per visitare tutti gli indirizzi esattamente una volta più $1$ #bus per tornare a casa a fine giornata
// - $cal(T) = {1, ..., T}$
// - $cal(I) = {1, ..., |I|}$ l'insieme di identificatori per cui esiste una funzione $id$ biettiva t.c.
//   $ id : cal(I) -> I " e " id(1) = #casa $
// - $cal(V) = { i | i in cal(I) and exists v space v in V and id(i) = v}$
// - $X = { X_(i, j)^t | (i, j) in #bus and t in cal(T)}$ l'insieme di variabili dove
//   - $X_(i, j)^t$ è vera se l'arco $(i, j) in #bus$ è stato percorso al $t$-esimo passo

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

- $I = {#casa, i_1, i_2, i_3, i_4, i_5}$
- $V = {i_1}$
- $bus = {(casa, i_1), (casa, i_2), (i_1, i_3), (i_1, i_4), (i_2, casa), (i_3, casa), (i_3, i_4), (i_4, i_1), (i_4, i_2)}$

- $cal(T) = {1, 2, 3, 4, 5}$
- $cal(I) = {1, 2, 3, 4, 5}$
- $cal(V) = {2}$
- $& X = { \
    #let x = 0;
    #for t in range(1, 6) {
      for (i, j) in E {
        if x == 0 { $& quad$ }
        $X_(#i, #j)^#t$
        x += 1
        if x == 5 {
          x = 0
          linebreak()
        }
      }
    }
    \
    & }$

=== Vincoli

La codifica che ho generato ha 293 clausole anche per un problema così piccolo... non vale la pena elencarle tutte, metto
un vincolo d'esempio.

$
  & phi.alt_"al_più_un_arco_per_passo" = { \
    #let x = 0;
    #for t in range(1, 6) {
      for (i1, j1) in E {
        for (i2, j2) in E {
          if (i1, j1) < (i2, j2) {
            if x == 0 { $& quad$ }
            $(X_(#i1, #j1)^#t -> not X_(#i2, #j2)^#t) and$
            x += 1
            if x == 5 {
              linebreak()
              x = 0
            }
          }
        }
      }
    }
    & }
$

#pagebreak()

== Codifica SATCodec (a questo giro in `Rust`)

```rust
use std::collections::BTreeSet;

use computer_braining::framework::sat_codec::*;
use serde::Serialize;

#[derive(PartialEq, Eq, PartialOrd, Ord, Hash, Debug, Serialize)]
struct X(usize, usize, usize);

fn main() {
    use Literal::Neg;

    let addresses_cardinality = 5;

    let addresses = 1..=addresses_cardinality;
    let steps = 1..=addresses_cardinality;
    let vips = BTreeSet::from([2]);

    #[rustfmt::skip]
    // Already sorted
    let buses: Vec<(usize, usize)> = vec![
        (1, 2), (1, 3), (2, 4), (2, 5), (3, 1), (3, 5), (4, 1), (4, 5), (5, 2), (5, 3)
    ];

    let mut encoder = Encoder::new();

    // Almeno un arco per passo
    for t in steps.clone() {
        let mut c = encoder.clause_builder();
        for &(i, j) in buses.iter() {
            c.add(X(t, i, j));
        }
        encoder = c.end()
    }

    // Al più un arco per passo
    for t in steps.clone() {
        for (index, &(i1, j1)) in buses.iter().enumerate() {
            for &(i2, j2) in buses.iter().skip(index + 2) {
                let mut c = encoder.clause_builder();
                c.add(Neg(X(t, i1, j1)));
                c.add(Neg(X(t, i2, j2)));
                encoder = c.end();
            }
        }
    }

    // Almeno un arco per indirizzo
    for j in addresses.clone() {
        let mut c = encoder.clause_builder();
        for t in steps.clone() {
            for &(i, k) in buses.iter() {
                if k == j {
                    c.add(X(t, i, j));
                }
            }
        }
        encoder = c.end();
    }

    // Al più un arco per indirizzo
    for t1 in steps.clone() {
        for t2 in t1 + 1..=*steps.end() {
            for j in addresses.clone() {
                for i1 in addresses.clone() {
                    for i2 in i1 + 1..=*addresses.end() {
                        if buses.contains(&(i1, j)) && buses.contains(&(i2, j)) {
                            let mut c = encoder.clause_builder();
                            c.add(Neg(X(t1, i1, j)));
                            c.add(Neg(X(t2, i2, j)));
                            encoder = c.end();
                        }
                    }
                }
            }
        }
    }

    // Clienti VIP nella prima metà
    for &v in vips.iter() {
        let mut c = encoder.clause_builder();
        for t in 1..=steps.end().div_ceil(2) {
            for i in addresses.clone() {
                if buses.contains(&(i, v)) {
                    c.add(X(t, i, v));
                }
            }
        }
        encoder = c.end();
    }

    // Partenza da casa
    let mut c = encoder.clause_builder();
    for i in 2..=*addresses.end() {
        if buses.contains(&(1, i)) {
            c.add(X(1, 1, i));
        }
    }
    encoder = c.end();

    // Arrivo a casa
    let mut c = encoder.clause_builder();
    for i in 2..=*addresses.end() {
        if buses.contains(&(i, 1)) {
            c.add(X(*steps.end(), i, 1));
        }
    }
    encoder = c.end();

    // Percorso valido
    for t in *steps.start()..=*steps.end() - 1 {
        for &(i, j) in buses.iter() {
            let mut c = encoder.clause_builder();
            c.add(Neg(X(t, i, j)));
            for k in addresses.clone() {
                if buses.contains(&(j, k)) {
                    c.add(X(t + 1, j, k))
                }
            }
            encoder = c.end();
        }
    }

    encoder.end();
}
```

=== ...

Devo ancora implementare il decodificatore. La decodifica l'ho fatta a mano a questo giro, e negli esempi che ho provato funziona perfettamente.
