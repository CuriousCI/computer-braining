use ai::frontiers::{AStar, BFS, DFS, MinCost};
use ai::problem::Utility;
use ai::problem_solving_agent::Agent;
use models::hp_2d_protein_folding::{Alphabet, Conformation, Energy, Pos, ProteinFolding};
use models::n_queens::NQueens;
use std::time::Instant;

pub mod models;

fn main() {
    use Alphabet::*;
    let sequence = vec![P, H, H, P, H, P, P, H, P];
    let protein = ProteinFolding::new(sequence.clone());

    for i in 1..=5_i32 {
        for j in 1..=5 {
            if i != j {
                println!("{{Q_{i}, Q_{j}}}");

                println!("{{");
                for x in 1..=5_i32 {
                    for y in 1..=5 {
                        if i.abs_diff(j) != x.abs_diff(y) {
                            print!("({x}, {y}), ")
                        }
                    }
                }
                println!("\n}}")
            }
        }
    }

    //let mut agent = Agent::new(protein);
    //let mut conformation = vec![];

    //while let Some(pos) = agent.function::<Conformation, MinCost<Conformation, Pos, Energy>>(vec![])
    //{
    //    conformation.push(pos);
    //}

    //let max_col = conformation.iter().map(|(x, _)| *x).max().unwrap_or(0);
    //let max_row = conformation.iter().map(|(_, y)| *y).max().unwrap_or(0);

    //for y in 0..max_row + 2 {
    //    for x in 0..max_col + 2 {
    //        if let Some((i, _)) = conformation
    //            .iter()
    //            .enumerate()
    //            .find(|(_, (p_x, p_y))| x == *p_x && y == *p_y)
    //        {
    //            print!("{:?}", sequence[i])
    //        } else {
    //            print!(".")
    //        }
    //    }
    //    println!()
    //}

    //for (i, pos) in conformation.iter().enumerate() {
    //    println!("{:?}: {:?}", sequence[i], pos)
    //}
}

//use ai::iterative_search::{
//    hill_climping, parallel_steepest_ascent, simulated_annealing, steepest_ascent,
//};
//use rayon::prelude::*;
//use std::cmp::Reverse;
//fn bench<F>(n_queens: &NQueens, f: F)
//where
//    F: Fn() -> Option<Vec<usize>>,
//{
//    let time = Instant::now();
//    let optimal = f();
//    println!("{:?}", time.elapsed());
//    if let Some(optimal) = optimal {
//        println!("{:?}", n_queens.utility(&optimal))
//    }
//}

//let n_queens = NQueens(128);
//
//bench(&n_queens, || {
//    simulated_annealing(
//        &n_queens,
//        &mut rand::rng(),
//        |t| -0.0001 * (t as f64) + 20f64,
//        |Reverse(u1), Reverse(u2)| u1.abs_diff(*u2) as f64,
//    )
//});
//
//bench(&n_queens, || {
//    simulated_annealing(
//        &n_queens,
//        &mut rand::rng(),
//        |t| 1f64 / (t as f64),
//        |Reverse(u1), Reverse(u2)| u1.abs_diff(*u2) as f64,
//    )
//});
//
//bench(&n_queens, || {
//    (0..=100)
//        .into_par_iter()
//        .filter_map(|_| parallel_steepest_ascent(&n_queens, &mut rand::rng()))
//        .max_by_key(|b| n_queens.utility(b))
//});
//
//bench(&n_queens, || {
//    (0..=100)
//        .into_par_iter()
//        .filter_map(|_| steepest_ascent(&n_queens, &mut rand::rng()))
//        .max_by_key(|b| n_queens.utility(b))
//});
//
//bench(&n_queens, || {
//    (0..=100)
//        .into_par_iter()
//        .filter_map(|_| hill_climping(&n_queens, &mut rand::rng(), 1000))
//        .max_by_key(|b| n_queens.utility(b))
//});
