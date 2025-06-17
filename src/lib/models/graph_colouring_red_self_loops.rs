use crate::sat::dimacs_encoder::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub enum Color {
    R,
    B,
    C,
}

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub struct X<T>(T, Color);

pub fn to_dimacs<T>(nodes: &[T], edges: &[(T, T)]) -> (DIMACS, Vec<X<T>>)
where
    T: std::cmp::Eq + std::hash::Hash + std::fmt::Debug + Serialize + Clone + Copy,
{
    use Literal::Negative as Neg;
    let colors = [Color::R, Color::B, Color::C];

    let mut encoder = Encoder::new();

    // ALO_col
    for &v in nodes {
        encoder.insert_clause(colors.into_iter().map(|color| X(v, color).into()).collect());
    }

    // AMO_col
    // for &v in nodes {
    //     for (i_1, &color_1) in colors.iter().enumerate() {
    //         for &color_2 in colors.iter().skip(i_1 + 1) {
    //             encoder.add(vec![Neg(X(v, color_1)), Neg(X(v, color_2))]);
    //         }
    //     }
    // }

    // col + loop
    for &(u, v) in edges {
        if u == v {
            encoder.insert_clause(vec![X(v, Color::R).into()])
        } else {
            for color in colors {
                encoder.insert_clause(vec![Neg(X(u, color)), Neg(X(v, color))]);
            }
        }
    }

    encoder.to_dimacs()
}
