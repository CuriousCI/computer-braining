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

    let nodes = ["A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S"];

    #[rustfmt::skip]
    let edges = [
        ("A", "E"), ("A", "H"), ("A", "I"), ("A", "S"),
        ("B", "C"), ("B", "G2"), ("B", "I"), ("B", "J"), ("B", "S"),
        ("C", "D"), ("C", "G2"), ("C", "S"),
        ("D", "E"), ("D", "S"),
        ("E", "G1"), ("E", "H"),
        ("G1", "H"), ("G2", "J"), ("H", "I"),
        ("J", "J")
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
