use crate::encoder_sat::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub enum LP {
    X(usize, usize),
    S(usize, usize),
}

// pub fn encode_instance(
//     cards: Vec<usize>,
//     cards_number: usize,
//     max_value: usize,
//     distance: usize,
// ) -> (String, Vec<LP>) {
//     use Literal::Neg;
//
//     let mut encoder = EncoderSAT::new();
//     let positions = cards_number;
//
//     // ALO_pos
//     for i in 1..=cards_number {
//         encoder.add((1..=positions).map(|p| LP::X(i, p).into()).collect());
//     }
//
//     // AMO_pos
//     for i in 1..=cards_number {
//         for p1 in 1..=positions {
//             for p2 in p1 + 1..=positions {
//                 encoder.add(vec![Neg(LP::X(i, p1)), Neg(LP::X(i, p2))]);
//             }
//         }
//     }
//
//     // alldiff
//     for p in 1..=positions {
//         for i1 in 1..=cards_number {
//             for i2 in i1 + 1..=cards_number {
//                 encoder.add(vec![Neg(LP::X(i1, p)), Neg(LP::X(i2, p))]);
//             }
//         }
//     }
//
//     // ALO_staz
//     for j in 1..=3 {
//         encoder.add((1..=positions).map(|p| LP::S(j, p).into()).collect());
//     }
//
//     // AMO_staz
//     for j in 1..=3 {
//         for p1 in 1..=positions {
//             for p2 in p1 + 1..=positions {
//                 encoder.add(vec![Neg(LP::S(j, p1)), Neg(LP::S(j, p2))])
//             }
//         }
//     }
//
//     // staz
//     for j1 in 1..=3 {
//         for j2 in j1 + 1..=3 {
//             for p1 in 1..=positions {
//                 for p2 in 1..=p1 {
//                     encoder.add(vec![Neg(LP::S(j1, p1)), Neg(LP::S(j2, p2))])
//                 }
//             }
//         }
//     }
//
//     // dist
//     for p in 1..=positions {
//         if p + distance <= positions {
//             encoder.add(vec![Neg(LP::S(1, p)), LP::S(3, p + distance).into()])
//         }
//     }
//
//     // ord_1
//     for p in 1..=positions {
//         for q in 1..p {
//             for i in 1..=cards_number {
//                 for j in 1..=cards_number {
//                     if cards[j - 1] <= cards[i - 1] {
//                         encoder.add(vec![
//                             Neg(LP::S(1, p)),
//                             Neg(LP::X(i, q)),
//                             Neg(LP::X(j, q + 1)),
//                         ])
//                     }
//                 }
//             }
//         }
//     }
//
//     // ord_2
//     for p1 in 1..=positions {
//         for p2 in p1 + 1..=positions {
//             for q in p1..p2 {
//                 for i in 1..=cards_number {
//                     for j in 1..=cards_number {
//                         if cards[j - 1] >= cards[i - 1] {
//                             encoder.add(vec![
//                                 Neg(LP::S(1, p1)),
//                                 Neg(LP::S(2, p2)),
//                                 Neg(LP::X(i, q)),
//                                 Neg(LP::X(j, q + 1)),
//                             ])
//                         }
//                     }
//                 }
//             }
//         }
//     }
//
//     // ord_3
//     for p1 in 1..=positions {
//         for p2 in p1 + 1..=positions {
//             for q in p1..p2 {
//                 for i in 1..=cards_number {
//                     for j in 1..=cards_number {
//                         if cards[j - 1] <= cards[i - 1] {
//                             encoder.add(vec![
//                                 Neg(LP::S(2, p1)),
//                                 Neg(LP::S(3, p2)),
//                                 Neg(LP::X(i, q)),
//                                 Neg(LP::X(j, q + 1)),
//                             ])
//                         }
//                     }
//                 }
//             }
//         }
//     }
//
//     // ord_4
//     for p in 1..=positions {
//         for q in p..positions {
//             for i in 1..=cards_number {
//                 for j in 1..=cards_number {
//                     if cards[j - 1] >= cards[i - 1] {
//                         encoder.add(vec![
//                             Neg(LP::S(3, p)),
//                             Neg(LP::X(i, q)),
//                             Neg(LP::X(j, q + 1)),
//                         ])
//                     }
//                 }
//             }
//         }
//     }
//
//     encoder.add(vec![Neg(LP::S(1, 1))]);
//     encoder.add(vec![Neg(LP::S(3, cards_number))]);
//
//     // encoder.end()
// }
