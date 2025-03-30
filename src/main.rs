use ai::frontiers::{AStar, BFS, DFS, MinCost};
use ai::problem_solving_agent::Agent;
use models::hp_2d_protein_folding::{Alphabet, AminoAcid, Energy, Pos, ProteinFolding, Sequence};
use rand::rng;
use rand::seq::IndexedRandom;
use std::rc::Rc;
use std::time::Instant;

// cplex optimization studio
// pruning dell'albero di ricerca
// MILP: mixed integer linear programming
// GAC e framework

pub mod models;

fn main() {
    use Alphabet::*;

    let mut rng = rng();
    let sequence: Sequence = (0..20)
        .filter_map(|_| [P, H].choose(&mut rng))
        //.filter_map(|_| [P, H, H, H, H, H, H, H].choose(&mut rng))
        .map(Clone::clone)
        .collect();

    //let sequence = vec![H, H, P, H, P, P, H, H, H, P, P, P, P, H, H, P];
    //let sequence = vec![P, H, H, P, H, P, P, H, P];

    //let sequence = vec![P, P, P, P, P, P, P, P, P];
    //let sequence = vec![P, P, P, P, P, P, P, P, H];
    //let sequence = vec![P, P, P, P, P, P, H, P, H];
    let sequence = vec![H, P, P, P, P, H, P, P, P, H, P, P, P, P, H, P, P, P, H];
    //let sequence = vec![P, P, H, P, H, P, H, P, H];
    //let sequence = vec![H, P, H, P, H, P, H, P, H];
    //let sequence = vec![H, P, H, P, H, P, H, H, H];
    //let sequence = vec![H, P, H, P, H, H, H, H, H];
    //let sequence = vec![H, P, H, H, H, H, H, H, H];
    //let sequence = vec![H, H, H, H, H, H, H, H, H];

    // TODO: la distanza "pari" fra due H è interessante... si potrebbe precalcolare
    // guacamole: la distanza "pari" gioca un ruolo fondamentale, vaccaccia

    let mut agent = Agent::new(ProteinFolding(sequence.clone()));

    let mut conformation = vec![(0, 0)];

    let time = Instant::now();

    while let Some(pos) =
        agent.function::<Rc<AminoAcid>, MinCost<Rc<AminoAcid>, Pos, Energy>>(Rc::new(AminoAcid {
            pos: (0, 0),
            prev: None,
            depth: 0,
        }))
    {
        conformation.push(pos);
    }

    println!("{:?}", time.elapsed());

    let max_col = conformation.iter().map(|(x, _)| *x).max().unwrap_or(0);
    let max_row = conformation.iter().map(|(_, y)| *y).max().unwrap_or(0);
    let min_col = conformation.iter().map(|(x, _)| *x).min().unwrap_or(0);
    let min_row = conformation.iter().map(|(_, y)| *y).min().unwrap_or(0);

    for y in min_row..max_row + 2 {
        for x in min_col..max_col + 2 {
            if let Some((i, _)) = conformation
                .iter()
                .enumerate()
                .find(|(_, (p_x, p_y))| x == *p_x && y == *p_y)
            {
                if x == 0 && y == 0 {
                    print!("X")
                } else {
                    print!("{:?}", sequence[i])
                }
            } else {
                print!(".")
            }
        }
        println!()
    }

    for (i, pos) in conformation.iter().enumerate() {
        println!("{:?}: {:?}", sequence[i], pos)
    }

    let mut agent = Agent::new(ProteinFolding(sequence.clone()));

    let mut conformation = vec![(0, 0)];

    let time = Instant::now();

    while let Some(pos) =
        agent.function::<Rc<AminoAcid>, AStar<Rc<AminoAcid>, Pos, Energy>>(Rc::new(AminoAcid {
            pos: (0, 0),
            prev: None,
            depth: 0,
        }))
    {
        conformation.push(pos);
    }

    println!("\n{:?}", time.elapsed());

    let max_col = conformation.iter().map(|(x, _)| *x).max().unwrap_or(0);
    let max_row = conformation.iter().map(|(_, y)| *y).max().unwrap_or(0);
    let min_col = conformation.iter().map(|(x, _)| *x).min().unwrap_or(0);
    let min_row = conformation.iter().map(|(_, y)| *y).min().unwrap_or(0);

    for y in min_row..max_row + 2 {
        for x in min_col..max_col + 2 {
            if let Some((i, _)) = conformation
                .iter()
                .enumerate()
                .find(|(_, (p_x, p_y))| x == *p_x && y == *p_y)
            {
                if x == 0 && y == 0 {
                    print!("X")
                } else {
                    print!("{:?}", sequence[i])
                }
            } else {
                print!(".")
            }
        }
        println!()
    }

    for (i, pos) in conformation.iter().enumerate() {
        println!("{:?}: {:?}", sequence[i], pos)
    }
}

//while let Some(pos) = agent.function::<Conformation, MinCost<Conformation, Pos, Energy>>(vec![])

// use ai::problem::Utility;
// use models::n_queens::NQueens;

//for i in 1..=5_i32 {
//    for j in 1..=5 {
//        if i != j {
//            println!("{{Q_{i}, Q_{j}}}");
//
//            println!("{{");
//            for x in 1..=5_i32 {
//                for y in 1..=5 {
//                    if i.abs_diff(j) != x.abs_diff(y) {
//                        print!("({x}, {y}), ")
//                    }
//                }
//            }
//            println!("\n}}")
//        }
//    }
//}

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
