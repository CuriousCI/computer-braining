use computer_braining::framework::encoder::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
enum Color {
    R,
    B,
    C,
}

type Node = &'static str;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
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

    let mut encoder = EncoderSAT::new();

    // ALO
    for v in nodes {
        encoder.add(colors.into_iter().map(|color| X(v, color).into()).collect());
    }

    // AMO
    for v in nodes {
        for (i_1, &color_1) in colors.iter().enumerate() {
            for &color_2 in colors.iter().skip(i_1 + 1) {
                encoder.add(vec![Neg(X(v, color_1)), Neg(X(v, color_2))]);
            }
        }
    }

    // 1. + 2.
    for (u, v) in edges {
        if u == v {
            encoder.add(vec![X(v, R).into()])
        } else {
            for color in colors {
                encoder.add(vec![Neg(X(u, color)), Neg(X(v, color))]);
            }
        }
    }

    encoder.end();
}

// let mut clause = encoder.clause();
// clause.add(Neg(X(u, color)));
// clause.add(Neg(X(v, color)));
// encoder = clause.end();
// let mut clause = encoder.clause();
// clause.add(X(v, R));
// encoder = clause.end();

// let mut clause = vec![]
// let mut clause = encoder.clause();
// for color in colors {
//     clause.add(X(v, color));
// }
// encoder = clause.end();

// let mut clause = encoder.clause();
// clause.add(Neg(X(v, color_1)));
// clause.add(Neg(X(v, color_2)));
// encoder = clause.end();
