// use std::collections::BTreeSet;
//
// use computer_braining::framework::encoder::*;
// use serde::Serialize;
//
// #[derive(PartialEq, Eq, PartialOrd, Ord, Hash, Debug, Serialize)]
// struct X(usize, usize, usize);
//
// fn main() {
//     use Literal::Neg;
//
//     let addresses_cardinality = 5;
//
//     let addresses = 1..=addresses_cardinality;
//     let steps = 1..=addresses_cardinality;
//     let vips = BTreeSet::from([2]);
//
//     #[rustfmt::skip]
//     // Already sorted
//     let buses: Vec<(usize, usize)> = vec![
//         (1, 2), (1, 3), (2, 4), (2, 5), (3, 1), (3, 5), (4, 1), (4, 5), (5, 2), (5, 3)
//     ];
//
//     let mut encoder = EncoderSAT::new();
//
//     // Almeno un arco per passo
//     for t in steps.clone() {
//         let mut c = encoder.clause();
//         for &(i, j) in buses.iter() {
//             c.add(X(t, i, j));
//         }
//         encoder = c.end()
//     }
//
//     // Al più un arco per passo
//     for t in steps.clone() {
//         for (index, &(i1, j1)) in buses.iter().enumerate() {
//             for &(i2, j2) in buses.iter().skip(index + 2) {
//                 let mut c = encoder.clause();
//                 c.add(Neg(X(t, i1, j1)));
//                 c.add(Neg(X(t, i2, j2)));
//                 encoder = c.end();
//             }
//         }
//     }
//
//     // Almeno un arco per indirizzo
//     for j in addresses.clone() {
//         let mut c = encoder.clause();
//         for t in steps.clone() {
//             for &(i, k) in buses.iter() {
//                 if k == j {
//                     c.add(X(t, i, j));
//                 }
//             }
//         }
//         encoder = c.end();
//     }
//
//     // Al più un arco per indirizzo
//     for t1 in steps.clone() {
//         for t2 in t1 + 1..=*steps.end() {
//             for j in addresses.clone() {
//                 for i1 in addresses.clone() {
//                     for i2 in i1 + 1..=*addresses.end() {
//                         if buses.contains(&(i1, j)) && buses.contains(&(i2, j)) {
//                             let mut c = encoder.clause();
//                             c.add(Neg(X(t1, i1, j)));
//                             c.add(Neg(X(t2, i2, j)));
//                             encoder = c.end();
//                         }
//                     }
//                 }
//             }
//         }
//     }
//
//     // Clienti VIP nella prima metà
//     for &v in vips.iter() {
//         let mut c = encoder.clause();
//         for t in 1..=steps.end().div_ceil(2) {
//             for i in addresses.clone() {
//                 if buses.contains(&(i, v)) {
//                     c.add(X(t, i, v));
//                 }
//             }
//         }
//         encoder = c.end();
//     }
//
//     // Partenza da casa
//     let mut c = encoder.clause();
//     for i in 2..=*addresses.end() {
//         if buses.contains(&(1, i)) {
//             c.add(X(1, 1, i));
//         }
//     }
//     encoder = c.end();
//
//     // Arrivo a casa
//     let mut c = encoder.clause();
//     for i in 2..=*addresses.end() {
//         if buses.contains(&(i, 1)) {
//             c.add(X(*steps.end(), i, 1));
//         }
//     }
//     encoder = c.end();
//
//     // Percorso valido
//     for t in *steps.start()..=*steps.end() - 1 {
//         for &(i, j) in buses.iter() {
//             let mut c = encoder.clause();
//             c.add(Neg(X(t, i, j)));
//             for k in addresses.clone() {
//                 if buses.contains(&(j, k)) {
//                     c.add(X(t + 1, j, k))
//                 }
//             }
//             encoder = c.end();
//         }
//     }
//
//     encoder.end();
// }
