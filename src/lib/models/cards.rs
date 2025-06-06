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

    encoder.to_dimacs()
}
