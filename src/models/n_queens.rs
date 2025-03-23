use rayon::prelude::*;
use std::cmp::Reverse;

use ai::problem::{Goal, IterativeImprovement, ParallelImprovement, TransitionModel, Utility};
use rand::distr::Distribution;
use rayon::iter::ParallelIterator;

/// The _"state of the board"_ is known as _"position"_ in chess
type Position = Vec<usize>;

/// An action corresponds to moving the queen in col i to row j
type Move = (usize, usize);

/// Definition of the n-queens problem
pub struct NQueens(pub usize);

impl TransitionModel for NQueens {
    type State = Position;
    type Action = Move;

    /// Generates a new state s.t. the queen in column `col` is in row `row`
    ///
    /// I tried a solution which in which the position isn't cloned, but it's less efficient. I'll trust Rust on this one.
    fn new_state(&self, position: &Position, &(col, row): &Move) -> Position {
        let mut new_position = position.clone();
        new_position[col] = row;
        new_position
    }
}

impl Goal for NQueens {
    fn is_goal(&self, state: &Self::State) -> bool {
        self.utility(state) == Reverse(0)
    }
}

impl Utility<Reverse<usize>> for NQueens {
    /// This heuristic counts both the number of *direct* attacks and *indirect* attacks. It has
    /// proven to be more effecting at finding results (it carries more information than just the
    /// direct attacks)
    fn utility(&self, position: &Self::State) -> Reverse<usize> {
        let mut attacks = 0;

        for (col_i, row_i) in position.iter().enumerate() {
            for (col_j, row_j) in position.iter().skip(col_i + 1).enumerate() {
                if row_i == row_j || row_i.abs_diff(*row_j) == col_i.abs_diff(col_j) {
                    attacks += 1;
                }
            }
        }

        Reverse(attacks)
    }
}

impl IterativeImprovement<Reverse<usize>> for NQueens {
    /// The simplest way to implement the neighbourhood is to allow a queen to move only above or
    /// below.
    ///
    /// I tried allowing movement in all positions, and this happened:
    /// - with steepest_ascent time went from 50ms to 2s
    /// - the resulting attacks went from 50 to 0
    ///
    /// So allowing more moves takes way more time, but finds way better results.
    /// By using this idea I tried implementing a "halo region" _(by allowing certain number of
    /// moves above and below)_.
    ///
    /// The halo region balances the quality of the results and the time take (a good enough halo
    /// region size can be both very fast and effecting at finding a solution)
    fn expand(&self, position: &Position) -> impl Iterator<Item = Move> {
        let mut moves = vec![];

        for (col, &row) in position.iter().enumerate() {
            if row > 0 {
                moves.push((col, row - 1));
            }
            if row < position.len() - 1 {
                moves.push((col, row + 1));
            }
        }

        // All moves
        //for i in 0..position.len() {
        //    if i != row {
        //        moves.push((col, i));
        //    }
        //}

        // Halo region
        //for offset in 1..=20.min(position.len()) {
        //    if row >= offset {
        //        moves.push((col, row - offset));
        //    }
        //
        //    if row < position.len() - offset {
        //        moves.push((col, row + offset));
        //    }
        //}

        moves.into_iter()
    }
}

impl ParallelImprovement<Reverse<usize>> for NQueens {
    /// Used by parallel_steepest_ascent to parallelize the calculation of the utility
    ///
    /// By using parallelization for 1000-queens times went down from 460s to 75s (on my 6 core computer)
    fn expand(&self, state: &Position) -> impl ParallelIterator<Item = Move> {
        IterativeImprovement::expand(self, state)
            .collect::<Vec<(usize, usize)>>()
            .into_par_iter()
    }
}

impl Distribution<Position> for NQueens {
    /// Used to generate the initial state bu iterative improvement algorithms
    fn sample<R: rand::Rng + ?Sized>(&self, rng: &mut R) -> Position {
        (0..self.0).map(|_| rng.random_range(0..self.0)).collect()
    }
}
