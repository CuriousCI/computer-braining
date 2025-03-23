use ai::iterative_search::{
    hill_climping, parallel_steepest_ascent, simulated_annealing, steepest_ascent,
};
use ai::problem::Utility;
use models::n_queens::NQueens;
use rayon::prelude::*;
use std::cmp::Reverse;
use std::time::Instant;

pub mod models;

fn bench<F>(n_queens: &NQueens, f: F)
where
    F: Fn() -> Option<Vec<usize>>,
{
    let time = Instant::now();
    let optimal = f();
    println!("{:?}", time.elapsed());
    if let Some(optimal) = optimal {
        println!("{:?}", n_queens.utility(&optimal))
    }
}

fn main() {
    let n_queens = NQueens(128);

    bench(&n_queens, || {
        simulated_annealing(
            &n_queens,
            &mut rand::rng(),
            |t| -0.0001 * (t as f64) + 10f64,
            |Reverse(u1), Reverse(u2)| u1.abs_diff(*u2) as f64,
        )
    });

    bench(&n_queens, || {
        (0..=100)
            .into_par_iter()
            .filter_map(|_| parallel_steepest_ascent(&n_queens, &mut rand::rng()))
            .max_by_key(|b| n_queens.utility(b))
    });

    bench(&n_queens, || {
        (0..=100)
            .into_par_iter()
            .filter_map(|_| steepest_ascent(&n_queens, &mut rand::rng()))
            .max_by_key(|b| n_queens.utility(b))
    });

    bench(&n_queens, || {
        (0..=100)
            .into_par_iter()
            .filter_map(|_| hill_climping(&n_queens, &mut rand::rng(), 1000))
            .max_by_key(|b| n_queens.utility(b))
    });
}
