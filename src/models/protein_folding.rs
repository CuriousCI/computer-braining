// use std::{
//     cmp::Reverse,
//     fmt::Display,
//     ops::{Add, Deref},
//     rc::Rc,
// };
// // numero di h - contatti totali
//
// use ai::problem::{Actions, GoalBased, Heuristic, Problem, Search};
// use rayon::iter::{IntoParallelIterator, ParallelBridge};
//
// #[derive(Clone, Debug)]
// pub enum Alphabet {
//     H,
//     P,
// }
//
// pub enum Move {
//     Left,
//     Right,
//     Up,
// }
//
// // massimo contatti persi è un certo k
// // l'incrocio costa più di k, ma non troppo, se aumento i contatti si riduce il costo
// // e peggiora se ci sono più
//
// // quand'è che c'è una sovrapposizione, solamente guardando gli spostamenti?
// // ^ ^ >
// // se c'è un certo tipo di azioni si deve per forza intersecare ad un certo punto?
// // senza dover salvare le posizoni esplorate?
//
// pub type Sequence = Vec<Alphabet>;
//
// pub type Conformation = Vec<(i16, i16)>;
//
// // pub type Cost = i16;
// // #[derive(Default, Clone, Eq, PartialEq, PartialOrd, Ord)]
// // pub struct Cost(i16, bool);
//
// // impl Add for Cost {
// //     type Output = Cost;
// //
// //     fn add(self, rhs: Self) -> Self::Output {
// //         if rhs.1 { self } else { rhs }
// //     }
// // }
//
// pub type Cost = i16;
//
// // #[derive(Default, Clone, Eq, PartialEq, PartialOrd, Ord)]
// // pub struct Cost {
// //     contacts: i16,
// //     depth: Reverse<usize>,
// //     heuristic: bool,
// // }
// // impl Add for Cost {
// //     type Output = Cost;
// //
// //     fn add(self, rhs: Self) -> Self::Output {
// //         Cost {
// //             contacts: if rhs.heuristic {
// //                 self.contacts
// //             } else {
// //                 self.contacts + rhs.contacts
// //                 // rhs.contacts
// //             },
// //             depth: rhs.depth.min(self.depth),
// //             heuristic: false,
// //         }
// //     }
// // }
//
// pub type Pos = (i16, i16);
//
// // #[derive()]
// // pub struct Pos {
// //     x: i16,
// //     y: i16,
// // }
// // heuristic: usize,
//
// #[derive(Clone)]
// pub struct Protein(Sequence);
//
// #[derive(Hash, Eq, PartialEq, Default)]
// pub struct AminoAcid {
//     pos: Pos,
//     prev: Option<Rc<AminoAcid>>,
//     depth: usize,
//     first_turn: bool,
// }
//
// impl Protein {
//     pub fn new(sequence: Sequence) -> Self {
//         Self(sequence)
//     }
//
//     pub fn energy(&self, conformation: &Conformation) -> Reverse<usize> {
//         let mut energy = 0;
//         for (i, &(u_x, u_y)) in conformation.iter().enumerate() {
//             for (j, &(v_x, v_y)) in conformation[..0.max(i.abs_diff(1))].iter().enumerate() {
//                 if let (Alphabet::H, Alphabet::H) = (&self[i], &self[j]) {
//                     if u_x.abs_diff(v_x) + u_y.abs_diff(v_y) == 1 {
//                         energy += 1;
//                     }
//                 }
//             }
//         }
//
//         Reverse(energy)
//     }
// }
//
// impl Deref for Protein {
//     type Target = Sequence;
//
//     fn deref(&self) -> &Self::Target {
//         &self.0
//     }
// }
//
// impl Problem for Protein {
//     type State = Rc<AminoAcid>;
// }
//
// impl Actions for Protein {
//     type Action = Pos;
//
//     fn result(&self, amino_acid: &Self::State, &pos: &Self::Action) -> Self::State {
//         Rc::new(AminoAcid {
//             pos,
//             prev: Some(amino_acid.clone()),
//             depth: amino_acid.depth + 1,
//             first_turn: amino_acid.first_turn || pos.0 != 0,
//         })
//     }
// }
//
// impl GoalBased for Protein {
//     fn goal_test(&self, amino_acid: &Self::State) -> bool {
//         amino_acid.depth + 1 == self.len()
//     }
// }
//
// impl Heuristic for Protein {
//     type Value = Cost;
//
//     fn heuristic(&self, amino_acid: &Self::State) -> Cost {
//         // 3 non made contacts only for the first and final
//         // amminoacid, otherwise an amminoacid in the middle can make
//         // only two contacts
//         //
//         // heuristic... think of it as
//         // "minimize the number of 'not made contacts'"
//         //
//         // given a conformation, the heuristic is the
//         // "number of contacts I don't expect to make"
//         // (and it should be smaller than the actual
//         // contacts I don't make, so I have to be certain
//         // that a certain contact can be made... I also
//         // need to check I don't count twice the same contact,
//         // or at least consider the fact that they are mutually exclusive,
//         // maybe a contact can't be made if ANY of the previous already assigned
//         // proteins can't be reached)
//         // at this point the problem is the same, but inverted, how can I simplify it?
//         // and in some way keep it in the state (with a low overhead) without needing
//         // to recalculate again? (does it depend on the whole protein or just the
//         // new amminoacid added?)
//         //
//         // Given an H not yet assigned, a contact can be made iff
//         // - I have an H with an even distance
//         // - I have enough spots for it
//         // Not enough... there's a limited number of H
//         // I can consider for "non made contacts" at most the 2 previous candidates
//         // So I can basically look at the last 3 H at even distance
//         // from the current H (not assigned), and check if a contact can be made for
//         // those amminoacids, and it can't be made if
//         // - the distance needed to touch is greater than 1/2 the distance
//         // - the amminoacid has no empty neighbours covered
//         //
//         // ...thechnically one should store the empty
//         // precalc the "next H"
//
//         // Cost(0, true)
//
//         // amino_acid.depth.try_into().unwrap()
//         // 0
//
//         // Cost {
//         //     depth: Reverse(amino_acid.depth),
//         //     ..Default::default()
//         // }
//
//         // Questa info si può portare dietro nello stato
//         // - costa poco memorizzarla
//         // - evito O(n) calcoli
//
//         // si può calcolare in modo incrementale?
//         // la calcolo una volta all'inizio, e poi la espando,
//         // tecnicamente mi devo mantenere gli estremi, sia in verticale sia in orizzontale
//         // praticamente non serve più di tanto
//
//         let mut h = 0;
//
//         let mut grandpa = amino_acid.prev.as_ref().and_then(|a| a.prev.as_ref());
//         let mut curr = Some(amino_acid);
//
//         while let (Some(p), Some(c)) = (grandpa, curr) {
//             if let (Alphabet::H, Alphabet::H) = (&self[p.depth], &self[c.depth]) {
//                 if p.pos.0.abs_diff(c.pos.0) + p.pos.1.abs_diff(c.pos.1) > 1 {
//                     h += 1;
//                 }
//             }
//
//             grandpa = p.prev.as_ref();
//             curr = c.prev.as_ref();
//         }
//
//         (self.len() - h) as i16
//         // -h
//     }
// }
//
// // costo di cammino somma dei costi di passo
// // g > 0
// // immaginare che per quel costo la proteina si conformerà idealmente
// //
// // problema di massimizzazione, non di minimizzazione
// // cammino che costa di più
// // ricerca di costo massimo
// //
// // 1 - utilità
// // numero di contatti mancati con amminoacidi precedenti
// // capire bene il problema dell'approccio attuale
// //
// // mantenere le violazioni nell'approccio iterativo, e costi per numero di violazioni
// // numero vicino
//
// impl Search for Protein {
//     fn expand(&self, amino_acid: &Self::State) -> impl Iterator<Item = (Self::Action, Cost)> {
//         let (x, y) = amino_acid.pos;
//
//         let actions = if amino_acid.depth == 0 {
//             vec![(x, y + 1)]
//         } else if !amino_acid.first_turn {
//             vec![(x + 1, y), (x, y + 1)]
//             // vec![(x + 1, y)]
//         } else {
//             // if amino_acid
//             //     .prev
//             //     .as_ref()
//             //     .is_some_and(|prev| prev.pos.0.abs_diff(amino_acid.pos.0) == 1)
//             // {
//             //     // vec![(x, y + 1), (x, y - 1)]
//             // } else {
//             //     // vec![(x + 1, y), (x - 1, y)]
//             // }
//             vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//                 .into_iter()
//                 .filter(|pos| {
//                     let mut prev = amino_acid.prev.as_ref();
//                     while let Some(prev_amino_acid) = prev {
//                         if &prev_amino_acid.pos == pos {
//                             return false;
//                         }
//
//                         prev = prev_amino_acid.prev.as_ref();
//                     }
//
//                     true
//                 })
//                 .collect()
//         };
//
//         actions
//             .into_iter()
//             .map(|pos| match self[amino_acid.depth + 1] {
//                 // Alphabet::P => (pos, 0),
//                 // Alphabet::P => (pos, Cost(0, false)),
//                 Alphabet::P => (
//                     pos,
//                     0, // Cost {
//                       //     depth: Reverse(amino_acid.depth + 1),
//                       //     heuristic: false,
//                       //     ..Default::default()
//                       // },
//                 ),
//                 Alphabet::H => {
//                     let mut count = 0;
//                     let mut prev = amino_acid
//                         .prev
//                         .as_ref()
//                         .and_then(|amino_acid| amino_acid.prev.as_ref());
//
//                     while let Some(p) = prev {
//                         if let Alphabet::H = self[p.depth] {
//                             if p.pos.0.abs_diff(pos.0) + p.pos.1.abs_diff(pos.1) == 1 {
//                                 count += 1;
//                             }
//                         }
//                         prev = p.prev.as_ref();
//                     }
//                     // (pos, if amino_acid.depth == 0 { 3 } else { 2 } - count)
//                     // (pos, count)
//                     // (pos, Cost(count, false))
//                     (pos, if amino_acid.depth == 0 { 3 } else { 2 } - count)
//                     // Cost {
//                     //     contacts: count,
//                     //     depth: Reverse(amino_acid.depth + 1),
//                     //     heuristic: false,
//                     // },
//                 }
//             })
//             .collect::<Vec<_>>()
//             .into_iter()
//     }
// }
//
// // for i in 0..self.len() - 2 {
// //     match (self.get(i), self.get(i + 2)) {
// //         (Some(&Alphabet::H), Some(&Alphabet::H)) => {
// //             if
// //         }
// //         _ => (),
// //     }
// // }
// // let mut min_x = amino_acid.pos.0;
// // let mut max_x = amino_acid.pos.0;
// // let mut min_y = amino_acid.pos.1;
// // let mut max_y = amino_acid.pos.1;
// //
// // let mut prev = amino_acid.prev.as_ref();
// // while let Some(p) = prev {
// //     if let Alphabet::H = self[p.depth] {
// //         min_x = min_x.min(p.pos.0);
// //         max_x = max_x.max(p.pos.0);
// //         min_y = min_y.min(p.pos.1);
// //         max_y = max_y.max(p.pos.1);
// //     }
// //
// //     prev = p.prev.as_ref();
// // }
// //
// // ((max_x - min_x) + (max_y - min_y)) / 3

// --- OLD

// use std::{cmp::Reverse, ops::Deref, rc::Rc};
//
// use ai::problem::{Actions, GoalBased, Heuristic, Problem, Search};
//
// #[derive(Clone, Debug)]
// pub enum Alphabet {
//     H,
//     P,
// }
//
// pub enum Move {
//     Left,
//     Right,
//     Up,
// }
//
// pub enum Direction {
//     North,
//     South,
//     East,
//     West,
// }
//
// // massimo contatti persi è un certo k
// // l'incrocio costa più di k, ma non troppo, se aumento i contatti si riduce il costo
// // e peggiora se ci sono più
//
// // quand'è che c'è una sovrapposizione, solamente guardando gli spostamenti?
// // ^ ^ >
// // se c'è un certo tipo di azioni si deve per forza intersecare ad un certo punto?
// // senza dover salvare le posizoni esplorate?
//
// pub type Sequence = Vec<Alphabet>;
//
// pub type Conformation = Vec<(i16, i16)>;
//
// pub type Energy = i16;
//
// pub type Pos = (i16, i16);
//
// // #[derive()]
// // pub struct Pos {
// //     x: i16,
// //     y: i16,
// // }
//
// #[derive(Clone)]
// pub struct Protein(Sequence);
//
// #[derive(Hash, Eq, PartialEq, Default)]
// pub struct AminoAcid {
//     pos: Pos,
//     prev: Option<Rc<AminoAcid>>,
//     depth: usize,
//     first_turn: bool,
//     // heuristic: usize,
// }
//
// impl Protein {
//     pub fn new(sequence: Sequence) -> Self {
//         Self(sequence)
//     }
//
//     pub fn energy(&self, conformation: Conformation) -> Reverse<usize> {
//         let mut energy = 0;
//         for (i, &(u_x, u_y)) in conformation.iter().enumerate() {
//             for (j, &(v_x, v_y)) in conformation[..0.max(i.abs_diff(1))].iter().enumerate() {
//                 if let (Alphabet::H, Alphabet::H) = (&self[i], &self[j]) {
//                     if u_x.abs_diff(v_x) + u_y.abs_diff(v_y) == 1 {
//                         energy += 1;
//                     }
//                 }
//             }
//         }
//
//         Reverse(energy)
//     }
// }
//
// impl Deref for Protein {
//     type Target = Sequence;
//
//     fn deref(&self) -> &Self::Target {
//         &self.0
//     }
// }
//
// impl Problem for Protein {
//     type State = Rc<AminoAcid>;
// }
//
// impl Actions for Protein {
//     type Action = Pos;
//
//     fn result(&self, amino_acid: &Self::State, &pos: &Self::Action) -> Self::State {
//         Rc::new(AminoAcid {
//             pos,
//             prev: Some(amino_acid.clone()),
//             depth: amino_acid.depth + 1,
//             first_turn: amino_acid.first_turn || pos.0 != 0,
//         })
//     }
// }
//
// impl GoalBased for Protein {
//     fn goal_test(&self, amino_acid: &Self::State) -> bool {
//         amino_acid.depth + 1 == self.len()
//     }
// }
//
// impl Heuristic for Protein {
//     type Value = Energy;
//
//     fn heuristic(&self, amino_acid: &Self::State) -> Energy {
//         // 3 non made contacts only for the first and final
//         // amminoacid, otherwise an amminoacid in the middle can make
//         // only two contacts
//         //
//         // heuristic... think of it as
//         // "minimize the number of 'not made contacts'"
//         //
//         // given a conformation, the heuristic is the
//         // "number of contacts I don't expect to make"
//         // (and it should be smaller than the actual
//         // contacts I don't make, so I have to be certain
//         // that a certain contact can be made... I also
//         // need to check I don't count twice the same contact,
//         // or at least consider the fact that they are mutually exclusive,
//         // maybe a contact can't be made if ANY of the previous already assigned
//         // proteins can't be reached)
//         // at this point the problem is the same, but inverted, how can I simplify it?
//         // and in some way keep it in the state (with a low overhead) without needing
//         // to recalculate again? (does it depend on the whole protein or just the
//         // new amminoacid added?)
//         //
//         // Given an H not yet assigned, a contact can be made iff
//         // - I have an H with an even distance
//         // - I have enough spots for it
//         // Not enough... there's a limited number of H
//         // I can consider for "non made contacts" at most the 2 previous candidates
//         // So I can basically look at the last 3 H at even distance
//         // from the current H (not assigned), and check if a contact can be made for
//         // those amminoacids, and it can't be made if
//         // - the distance needed to touch is greater than 1/2 the distance
//         // - the amminoacid has no empty neighbours covered
//         //
//         // ...thechnically one should store the empty
//         // precalc the "next H"
//
//         0
//
//         // Questa info si può portare dietro nello stato
//         // - costa poco memorizzarla
//         // - evito O(n) calcoli
//
//         // si può calcolare in modo incrementale?
//         // la calcolo una volta all'inizio, e poi la espando,
//         // tecnicamente mi devo mantenere gli estremi, sia in verticale sia in orizzontale
//         // praticamente non serve più di tanto
//
//         // let mut h = 0;
//         //
//         // let mut grandpa = amino_acid.prev.as_ref().and_then(|a| a.prev.as_ref());
//         // let mut curr = Some(amino_acid);
//         //
//         // while let (Some(p), Some(c)) = (grandpa, curr) {
//         //     if let (Alphabet::H, Alphabet::H) = (&self[p.depth], &self[c.depth]) {
//         //         if p.pos.0.abs_diff(c.pos.0) + p.pos.1.abs_diff(c.pos.1) > 1 {
//         //             h += 1;
//         //         }
//         //     }
//         //
//         //     grandpa = p.prev.as_ref();
//         //     curr = c.prev.as_ref();
//         // }
//         //
//         // -h
//     }
// }
//
// // costo di cammino somma dei costi di passo
// // g > 0
// // immaginare che per quel costo la proteina si conformerà idealmente
// //
// // problema di massimizzazione, non di minimizzazione
// // cammino che costa di più
// // ricerca di costo massimo
// //
// // 1 - utilità
// // numero di contatti mancati con amminoacidi precedenti
// // capire bene il problema dell'approccio attuale
// //
// // mantenere le violazioni nell'approccio iterativo, e costi per numero di violazioni
// // numero vicino
//
// impl Search for Protein {
//     fn expand(&self, amino_acid: &Self::State) -> impl Iterator<Item = (Self::Action, Energy)> {
//         let (x, y) = amino_acid.pos;
//
//         let actions = if amino_acid.depth == 0 {
//             vec![(x, y + 1)]
//         } else if !amino_acid.first_turn {
//             vec![(x + 1, y), (x, y + 1)]
//         } else {
//             vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//                 .into_iter()
//                 .filter(|pos| {
//                     let mut prev = amino_acid.prev.as_ref();
//                     while let Some(prev_amino_acid) = prev {
//                         if &prev_amino_acid.pos == pos {
//                             return false;
//                         }
//
//                         prev = prev_amino_acid.prev.as_ref();
//                     }
//
//                     true
//                 })
//                 .collect()
//         };
//
//         actions
//             .into_iter()
//             .map(|pos| match self[amino_acid.depth + 1] {
//                 Alphabet::P => (pos, 0),
//                 Alphabet::H => {
//                     let mut count = 0;
//                     let mut prev = amino_acid
//                         .prev
//                         .as_ref()
//                         .and_then(|amino_acid| amino_acid.prev.as_ref());
//
//                     while let Some(p) = prev {
//                         if let Alphabet::H = self[p.depth] {
//                             if p.pos.0.abs_diff(pos.0) + p.pos.1.abs_diff(pos.1) == 1 {
//                                 count += 1;
//                             }
//                         }
//                         prev = p.prev.as_ref();
//                     }
//                     (pos, if amino_acid.depth == 0 { 3 } else { 2 } - count)
//                     // (pos, 3 - count)
//                 }
//             })
//             .collect::<Vec<_>>()
//             .into_iter()
//     }
// }
//
// // for i in 0..self.len() - 2 {
// //     match (self.get(i), self.get(i + 2)) {
// //         (Some(&Alphabet::H), Some(&Alphabet::H)) => {
// //             if
// //         }
// //         _ => (),
// //     }
// // }
// // let mut min_x = amino_acid.pos.0;
// // let mut max_x = amino_acid.pos.0;
// // let mut min_y = amino_acid.pos.1;
// // let mut max_y = amino_acid.pos.1;
// //
// // let mut prev = amino_acid.prev.as_ref();
// // while let Some(p) = prev {
// //     if let Alphabet::H = self[p.depth] {
// //         min_x = min_x.min(p.pos.0);
// //         max_x = max_x.max(p.pos.0);
// //         min_y = min_y.min(p.pos.1);
// //         max_y = max_y.max(p.pos.1);
// //     }
// //
// //     prev = p.prev.as_ref();
// // }
// //
// // ((max_x - min_x) + (max_y - min_y)) / 3
