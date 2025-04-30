// use rayon::prelude::*;
// use std::cmp::Reverse;
//
// use ai::problem::{Actions, GoalBased, Heuristic, LocalSearch, ParallelLocal, Problem};
// use rand::distr::Distribution;
// use rayon::iter::ParallelIterator;
//
// type Position = Vec<usize>;
//
// type Move = (usize, usize);
//
// type Attacks = usize;
//
// pub struct NQueens(usize);
//
// impl NQueens {
//     pub fn new(n: usize) -> Self {
//         Self(n)
//     }
// }
//
// impl Problem for NQueens {
//     type State = Position;
// }
//
// impl Actions for NQueens {
//     type Action = Move;
//
//     fn result(&self, position: &Self::State, &(col, row): &Self::Action) -> Self::State {
//         let mut new_position = position.clone();
//         new_position[col] = row;
//         new_position
//     }
// }
//
// impl GoalBased for NQueens {
//     fn goal_test(&self, state: &Self::State) -> bool {
//         self.heuristic(state) == Reverse(0)
//     }
// }
//
// impl Heuristic for NQueens {
//     type Value = Reverse<Attacks>;
//     fn heuristic(&self, position: &Self::State) -> Reverse<Attacks> {
//         let mut attacks = 0;
//
//         for (col_i, row_i) in position.iter().enumerate() {
//             for (col_j, row_j) in position.iter().skip(col_i + 1).enumerate() {
//                 if row_i == row_j || row_i.abs_diff(*row_j) == col_i.abs_diff(col_j) {
//                     attacks += 1;
//                 }
//             }
//         }
//
//         Reverse(attacks)
//     }
// }
//
// impl LocalSearch for NQueens {
//     fn result(&self, position: &Position) -> impl Iterator<Item = Move> {
//         let mut moves = vec![];
//
//         for (col, &row) in position.iter().enumerate() {
//             if row > 0 {
//                 moves.push((col, row - 1));
//             }
//             if row < position.len() - 1 {
//                 moves.push((col, row + 1));
//             }
//
//             // All moves
//             //for i in 0..position.len() {
//             //    if i != row {
//             //        moves.push((col, i));
//             //    }
//             //}
//
//             // Halo region
//             //for offset in 1..=20.min(position.len()) {
//             //    if row >= offset {
//             //        moves.push((col, row - offset));
//             //    }
//             //
//             //    if row < position.len() - offset {
//             //        moves.push((col, row + offset));
//             //    }
//             //}
//         }
//
//         moves.into_iter()
//     }
// }
//
// impl ParallelLocal for NQueens {
//     fn result(&self, state: &Position) -> impl ParallelIterator<Item = Move> {
//         LocalSearch::result(self, state)
//             .collect::<Vec<_>>()
//             .into_par_iter()
//     }
// }
//
// impl Distribution<Position> for NQueens {
//     fn sample<R: rand::Rng + ?Sized>(&self, rng: &mut R) -> Position {
//         (0..self.0).map(|_| rng.random_range(0..self.0)).collect()
//     }
// }
