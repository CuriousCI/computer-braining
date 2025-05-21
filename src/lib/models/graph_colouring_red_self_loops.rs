use crate::encoder::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
enum Color {
    R,
    B,
    C,
}

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
struct X<T>(T, Color);

pub fn encode_instance<T>(vertices: &[T], edges: &[(T, T)]) -> String
where
    T: std::cmp::Eq + std::hash::Hash + std::fmt::Debug + Serialize,
{
    use Literal::Neg;
    let colors = [Color::R, Color::B, Color::C];

    let mut encoder = EncoderSAT::new();

    // ALO
    for v in vertices {
        encoder.add(colors.into_iter().map(|color| X(v, color).into()).collect());
    }

    // AMO
    for v in vertices {
        for (i_1, &color_1) in colors.iter().enumerate() {
            for &color_2 in colors.iter().skip(i_1 + 1) {
                encoder.add(vec![Neg(X(v, color_1)), Neg(X(v, color_2))]);
            }
        }
    }

    // 1. + 2.
    for (u, v) in edges {
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
