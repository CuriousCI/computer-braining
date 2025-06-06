#import "template.typ": *

#show: doc => conf([E.A.6.10 (Cards, 2)], doc)

== Modellazione

Dati i paramentri $italic("Cards"), N, M, D$ siano
- $cal(I) = {1, ..., N}$ è l'insieme di _identificatori_ per cui esiste una funzione $pi$ t.c.
  $
    pi : cal(I) & -> {1, ..., D} \
    pi(i) & |-> "valore dell'" i"-esima carta"
  $
- $cal(P) = {1, ..., N}$ è l'insieme di posizioni possibili per una carta
- $"LP" = { X_p^i | i in cal(I) and p in cal(P) } union { S_p^j | j in {1, 2, 3} and p in cal(P) }$ è l'insieme di lettere proposizionali t.c.
  - $X_p^i$ è vera se la carta con id $i$ è in posizione $p$
  - $S_p^j$ è vera se il punto stazionario $j$ è in posizione $p$

Il problema si può modellare con una serie di vincoli


#math.equation(block: true, numbering: none)[
  $
    phi.alt = & phi.alt_"ALO_pos" and phi.alt_"AMO_pos" and phi.alt_"alldiff" and \
    & phi.alt_"ALO_staz" and phi.alt_"AMO_staz" and phi.alt_"staz" and phi.alt_"dist" and \
    & phi.alt_"ord_1" and phi.alt_"ord_2" and phi.alt_"ord_3" and phi.alt_"ord_4" and not S^1_1 and not S^3_N
  $
]


(ALO) Ogni carta ha almeno una posizione.

$
  phi.alt_"ALO_pos" =
  and.big_(i in cal(I))
  or.big_(p in cal(P)) X_p^i
$

(AMO) Ogni carta ha al più una posizione.

$
  phi.alt_"AMO_pos" =
  and.big_(i in cal(I) \ p_1, p_2 in cal(P) \ p_1 < p_2)
  X_(p_1)^i -> not X_(p_2)^i
$

(alldiff) Non ci sono due carte nella stessa posizione

$
  phi.alt_"alldiff" =
  and.big_(p in cal(P) \ i_1, i_2 in cal(I) \ i_1 < i_2)
  X_p^(i_1) -> not X_p^(i_2)
$

(ALO) Ogni punto stazionario ha almeno una posizione.

$
  phi.alt_"ALO_staz" =
  and.big_(j in {1, 2, 3})
  or.big_(p in cal(P)) S_p^j
$

(AMO) Ogni punto stazionario ha al più una posizione.

$
  phi.alt_"AMO_staz" =
  and.big_(j in {1, 2, 3} \ p_1, p_2 in cal(P) \ p_1 < p_2)
  S_(p_1)^j -> not S_(p_2)^j
$

#pagebreak()

I punti stazionari sono posizionati in ordine. Quindi se il punto $S^1$ è in posizione $p$ allora i punti successivi _non_ possono essere posizionati in $p$ o in una posizione precedente a $p$

$
  phi.alt_"staz" =
  and.big_(j_1, j_2 in {1, 2, 3} \ p_1, p_2 in cal(P) \ j_1 < j_2 \ p_1 >= p_2)
  S_(p_1)^(j_1) -> not S_(p_2)^(j_2)
$

La distanza fra i due _punti di massimo_ è esattamente $D$

$
  phi.alt_"dist" =
  and.big_(p in cal(P) \ p + D in cal(P))
  S_p^1 -> S_(p + D)^3
$

Se il punto stazionario $S^1$ è in posizione $p$, e l'$i$-esima carta è in posizione $q$ t.c. $q < p$, allora in posizione $q + 1$ non ci può essere una carta di valore inferiore o uguale a $pi(i)$

$
  phi.alt_"ord_1" =
  and.big_(p, q in cal(P) \ i, j in cal(I) \ q < p \ pi(j) <= pi(i))
  S^1_p and X^i_q -> not X^j_(q+1)
$ <ord-1>

Simile all'@ord-1, ma per le posizioni tra $S^1$ e $S^2$

$
  phi.alt_"ord_2" =
  and.big_(
  p_1, p_2, q in cal(P) \ i, j in cal(I) \ p_1 <= q < p_2 \ pi(j) >= pi(i)
  )
  S^1_(p_1) and S^2_(p_2) and X^i_q -> not X^j_(q + 1)
$

Simile all'@ord-1, ma per le posizioni tra $S^2$ e $S^3$

$
  phi.alt_"ord_3" =
  and.big_(
  p_1, p_2, q in cal(P) \ i, j in cal(I) \ p_1 <= q < p_2 \ pi(j) <= pi(i)
  )
  S^2_(p_1) and S^3_(p_2) and X^i_q -> not X^j_(q + 1)
$

Simile all'@ord-1, ma per le posizioni da $S^3$ in poi

$
  phi.alt_"ord_4" =
  and.big_(p, q in cal(P) \ i, j in cal(I) \ p <= q < N \ pi(j) >= pi(i))
  S^3_p and X^i_q -> not X^j_(q+1)
$

#pagebreak()

== Istanziazione

=== Parametri e variabili

$(italic("Cards"), N, M, D) = ({1, 1, 2, 2, 3, 3, 4}, 7, 4, 4)$

#set math.equation(numbering: none)

#let I = (1, 2, 3, 4, 5, 6, 7)
#let P = (1, 2, 3, 4, 5, 6, 7)
#let J = (1, 2, 3)

$
  & "LP" = { \
    #let index = 0
    #for i in I {
      for p in P {
        if calc.rem(index, 14) == 0 { $& quad$ }
        $X^(#i)_(#p),$
        if calc.rem(index, 14) == 13 { linebreak() }
        index += 1
      }
    } \
    #let index = 0
    #for j in J {
      for p in P {
        if calc.rem(index, 14) == 0 { $&quad$ }
        $S^(#j)_(#p),$
        if calc.rem(index, 14) == 13 { linebreak() }
        index += 1
      }
    } \
    & }
$

=== Vincoli

Etc... sono tanti, e si tratterebbe comunque di generarli automaticamente. Nell'encoding generato ci sono 5229 clausole...

#pagebreak()

== Codifica

#align(
  center,
  block(width: 150%)[
    ```rust
    use crate::encoder::*;
    use serde::Serialize;

    #[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
    pub enum LP {
        X(usize, usize),
        S(usize, usize),
    }

    pub fn encode_instance(
        cards: Vec<usize>,
        cards_number: usize,
        max_value: usize,
        distance: usize,
    ) -> (String, Vec<LP>) {
        use Literal::Neg;

        let mut encoder = EncoderSAT::new();
        let positions = cards_number;

        // ALO_pos
        for i in 1..=cards_number {
            encoder.add((1..=positions).map(|p| LP::X(i, p).into()).collect());
        }

        // AMO_pos
        for i in 1..=cards_number {
            for p1 in 1..=positions {
                for p2 in p1 + 1..=positions {
                    encoder.add(vec![Neg(LP::X(i, p1)), Neg(LP::X(i, p2))]);
                }
            }
        }

        // alldiff
        for p in 1..=positions {
            for i1 in 1..=cards_number {
                for i2 in i1 + 1..=cards_number {
                    encoder.add(vec![Neg(LP::X(i1, p)), Neg(LP::X(i2, p))]);
                }
            }
        }

        // ALO_staz
        for j in 1..=3 {
            encoder.add((1..=positions).map(|p| LP::S(j, p).into()).collect());
        }

        // AMO_staz
        for j in 1..=3 {
            for p1 in 1..=positions {
                for p2 in p1 + 1..=positions {
                    encoder.add(vec![Neg(LP::S(j, p1)), Neg(LP::S(j, p2))])
                }
            }
        }

        // staz
        for j1 in 1..=3 {
            for j2 in j1 + 1..=3 {
                for p1 in 1..=positions {
                    for p2 in 1..=p1 {
                        encoder.add(vec![Neg(LP::S(j1, p1)), Neg(LP::S(j2, p2))])
                    }
                }
            }
        }

        // dist
        for p in 1..=positions {
            if p + distance <= positions {
                encoder.add(vec![Neg(LP::S(1, p)), LP::S(3, p + distance).into()])
            }
        }

        // ord_1
        for p in 1..=positions {
            for q in 1..p {
                for i in 1..=cards_number {
                    for j in 1..=cards_number {
                        if cards[j - 1] <= cards[i - 1] {
                            encoder.add(vec![
                                Neg(LP::S(1, p)),
                                Neg(LP::X(i, q)),
                                Neg(LP::X(j, q + 1)),
                            ])
                        }
                    }
                }
            }
        }

        // ord_2
        for p1 in 1..=positions {
            for p2 in p1 + 1..=positions {
                for q in p1..p2 {
                    for i in 1..=cards_number {
                        for j in 1..=cards_number {
                            if cards[j - 1] >= cards[i - 1] {
                                encoder.add(vec![
                                    Neg(LP::S(1, p1)),
                                    Neg(LP::S(2, p2)),
                                    Neg(LP::X(i, q)),
                                    Neg(LP::X(j, q + 1)),
                                ])
                            }
                        }
                    }
                }
            }
        }

        // ord_3
        for p1 in 1..=positions {
            for p2 in p1 + 1..=positions {
                for q in p1..p2 {
                    for i in 1..=cards_number {
                        for j in 1..=cards_number {
                            if cards[j - 1] <= cards[i - 1] {
                                encoder.add(vec![
                                    Neg(LP::S(2, p1)),
                                    Neg(LP::S(3, p2)),
                                    Neg(LP::X(i, q)),
                                    Neg(LP::X(j, q + 1)),
                                ])
                            }
                        }
                    }
                }
            }
        }

        // ord_4
        for p in 1..=positions {
            for q in p..positions {
                for i in 1..=cards_number {
                    for j in 1..=cards_number {
                        if cards[j - 1] >= cards[i - 1] {
                            encoder.add(vec![
                                Neg(LP::S(3, p)),
                                Neg(LP::X(i, q)),
                                Neg(LP::X(j, q + 1)),
                            ])
                        }
                    }
                }
            }
        }

        encoder.add(vec![Neg(LP::S(1, 1))]);
        encoder.add(vec![Neg(LP::S(3, cards_number))]);

        encoder.end()
    }
    ```
  ],
)

// Ci siamo quasi, manca di usare qualcosa tipo

// Non è proprio banale
// - sempre i 3 punti stazionari (3 variabili)
// - per ogni punto stazionario fisso una posizione
//   - ogni punto stazionario ha almeno una posizione
//   - ogni punto stazionario ha al più una posizione
//   - non ci sono due punti stazionari con la stessa posizione
//   - almeno 1
//   - al più x
// - Ok, ora che ho posizionato i punti stazionari
//   - devo dire che la distanza è esattamente $D$
//   - quindi S1 p -> S2 p + D (easy as that)
// - Adesso devo effettivamente provare a fare la scalata
//   - magico S1 p, i1 p1, i2 p2, p1 < p2 < p -> pi(i1) < pi(i2)
//   - magico S1 q, S2 p, i1 p1, i2 p2, p1 < p2 < p -> pi(i1) < pi(i2)
// - Ok, se una carta sta in un certo range (range 1, range 2, range 3, range 4)
//   - dato il suo valore, la carta *successiva* NON può essere ...
// (Negare tutto!)

// - $cal(N) = {1, ..., N}$
// - $cal()$
// questo perché mi serve anche un valore se voglimo, il valore n, per poter ordinare!

