use std::collections::BTreeSet;

use computer_braining::framework::sat_codec::*;
use serde::Serialize;

#[derive(PartialEq, Eq, PartialOrd, Ord, Hash, Debug, Serialize)]
struct X(usize, usize, usize);

fn main() {
    use Literal::Neg;

    let card_addresses = 5;

    let addresses = 1..=card_addresses;
    let steps = 1..=card_addresses;
    let vips = BTreeSet::from([2]);

    #[rustfmt::skip]
    // Already sorted
    let buses: Vec<(usize, usize)> = vec![
        (1, 2), (1, 3), (2, 4), (2, 5), (3, 1), (3, 5), (4, 1), (4, 5), (5, 2), (5, 3)
    ];

    let mut encoder: Encoder<X> = Encoder::new();

    // Almeno un arco per passo
    for p in steps.clone() {
        for &(i, j) in buses.iter() {
            let mut c = encoder.clause_builder();
            c.add(X(p, i, j));
            encoder = c.end()
        }
    }

    // Al più un arco per passo
    for p in steps.clone() {
        for (index, &(i1, j1)) in buses.iter().enumerate() {
            for &(i2, j2) in buses.iter().skip(index + 1) {
                let mut c = encoder.clause_builder();
                c.add(Neg(X(p, i1, j1)));
                c.add(X(p, i2, j2));
                encoder = c.end();
            }
        }
    }

    // Almeno un arco per indirizzo
    for j in addresses.clone() {
        let mut c = encoder.clause_builder();
        for p in steps.clone() {
            for i in addresses.clone() {
                if buses.contains(&(i, j)) {
                    c.add(X(p, i, j));
                }
            }
        }
        encoder = c.end();
    }

    // Al più un arco per indirizzo
    for p in steps.clone() {
        for j in addresses.clone() {
            for i1 in addresses.clone() {
                for i2 in i1 + 1..=*addresses.end() {
                    if buses.contains(&(i1, j)) && buses.contains(&(i2, j)) {
                        let mut c = encoder.clause_builder();
                        c.add(Neg(X(p, i1, j)));
                        c.add(Neg(X(p, i2, j)));
                        encoder = c.end();
                    }
                }
            }
        }
    }

    // Clienti VIP nella prima metà
    for &v in vips.iter() {
        let mut c = encoder.clause_builder();
        for p in 1..=steps.end().div_ceil(2) {
            for i in addresses.clone() {
                if buses.contains(&(i, v)) {
                    c.add(X(p, i, v));
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
    for p in *steps.start()..=*steps.end() - 1 {
        for &(i, j) in buses.iter() {
            let mut c = encoder.clause_builder();
            c.add(Neg(X(p, i, j)));
            for k in addresses.clone() {
                if buses.contains(&(j, k)) {
                    c.add(X(p + 1, j, k))
                }
            }
            encoder = c.end();
        }
    }

    encoder.end();
}
