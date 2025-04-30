use ai::framework::{
    clean,
    frontiers::{TreeAStar, TreeAStarArena, TreeUniformCost, TreeUniformCostArena},
    local_search::{
        genetic_algorithm, hill_climping, local_beam, simulated_annealing, steepest_ascent,
    },
    problem::{Heuristic, Problem},
    search::{AStar, Agent, UniformCost},
};
use bumpalo::Bump;
use model::hp_2d_protein_folding::{
    Sequence,
    local_search::{self, Local2dProteinFolding},
    search::{AminoAcid, Conformation, Contacts, MissedContacts, ProteinFolding},
};
// use rand::{Rng, rng};
use rayon::prelude::*;
use std::{
    // collections::HashMap,
    // rc::Rc,
    collections::BTreeSet,
    time::Instant,
};

pub mod model;
use rand::prelude::*;

use std::alloc::System;

#[global_allocator]
static GLOBAL: System = System;

// Properties constraints GAIRS

fn main() {
    use model::hp_2d_protein_folding::Alphabet::*;

    // let sequence = vec![
    //     H, H, P, H, P, P, H, H, H, P, P, P, P, H, H, P, H, P, H, P, P, H, P, H, P, H, H, P, H, P,
    //     P, H,
    // ];
    let sequence = vec![
        H, H, P, H, P, P, H, H, H, P, P, P, P, H, H, P, H, P, H, P, P, H, P, H, P, H, H,
    ];

    // frontiers::{AStar, AStarTree, MinCost, MinCostTree},
    // frontiers::{AStar, AStarTree, MinCost, MinCostTree},
    // let sequence = vec![H, H, P, H, P, P, H, H, H, P, P, P, P, H, H, P, H, P, H, P];
    // let sequence = vec![H, P, P, P, P, P, P, P, P, P, P, P,P, P, P, P, P, P, P, H];
    // let sequence = vec![H, H, P, H, P, P, H, H, H, P, P, P, P, H, H, P];
    // println!("{}", sequence.len());
    // let mut rng = rand::rng();
    // let mut sequence: Sequence = (0..10)
    //     .filter_map(|_| [P, H].choose(&mut rng))
    //     .map(Clone::clone)
    //     .collect();
    // sequence.push(H);

    // let protein = LocalProteinFolding::new(sequence.clone());
    // // let initial_state = Conformation::
    // let mut rng = rand::rng();
    // let time = Instant::now();
    // let result = steepest_ascent(&protein, protein.sample(&mut rng));
    // println!("{:?}", time.elapsed());
    // debug_conformation(&ProteinFolding::new(sequence.clone()), &result.positions());

    // let protein = LocalProteinFolding::new(sequence.clone());
    // // let initial_state = Conformation::
    // let mut rng = rand::rng();
    // let time = Instant::now();
    // let result = hill_climping(&protein, &mut rng, 100);
    // println!("{:?}", time.elapsed());
    // println!("{:?}", result);
    // if let Some(result) = result {
    //     println!("{:?}", protein.heuristic(&result));
    //     debug_conformation(&ProteinFolding::new(sequence.clone()), &result.positions());
    // }

    //        &n_queens,
    //        &mut rand::rng(),
    //        |t| -0.0001 * (t as f64) + 20f64,
    //        |Reverse(u1), Reverse(u2)| u1.abs_diff(*u2) as f64,

    let time = Instant::now();
    let protein = Local2dProteinFolding::new(sequence.clone());
    let mut rng = rand::rng();
    let result = genetic_algorithm(&protein, 100, 10000, &mut rng);
    println!("{:?}", time.elapsed());
    println!("best result: {:?}", protein.heuristic(&result));
    debug_conformation(&ProteinFolding::new(sequence.clone()), &result.positions());

    let time = Instant::now();
    let protein = Local2dProteinFolding::new(sequence.clone());
    let mut rng = rand::rng();
    let result = local_beam(&protein, 10, 1000, &mut rng);
    println!("{:?}", time.elapsed());
    println!("best result: {:?}", protein.heuristic(&result));
    debug_conformation(&ProteinFolding::new(sequence.clone()), &result.positions());

    // &mut rng,
    // |t| -0.01 * (t as f64) + 20f64,
    // |x, y| x.cost().abs_diff(y.cost()) as f64,

    let time = Instant::now();
    let mut best = None;
    let protein = Local2dProteinFolding::new(sequence.clone());
    let mut rng = rand::rng();
    for _ in 0..=100 {
        let result = simulated_annealing(
            &protein,
            &mut rng,
            |t| -0.01 * (t as f64) + 20f64,
            |x, y| x.cost().abs_diff(y.cost()) as f64,
        );
        if let Some(result) = result {
            if best.clone().is_none_or(|best| {
                protein
                    .heuristic(&result)
                    .is_better(protein.heuristic(&best))
            }) {
                best = Some(result);
            }
        }
    }
    println!("{:?}", time.elapsed());
    if let Some(result) = best {
        println!("best result: {:?}", protein.heuristic(&result));
        debug_conformation(&ProteinFolding::new(sequence.clone()), &result.positions());
    }

    let time = Instant::now();
    let mut rng = rand::rng();
    let mut best = None;
    let protein = Local2dProteinFolding::new(sequence.clone());
    for _ in 0..=10000 {
        let result = steepest_ascent(&protein, protein.sample(&mut rng));
        if best.clone().is_none_or(|best| {
            protein
                .heuristic(&result)
                .is_better(protein.heuristic(&best))
        }) {
            best = Some(result);
        }
    }
    println!("{:?}", time.elapsed());
    if let Some(result) = best {
        println!("best result: {:?}", protein.heuristic(&result));
        debug_conformation(&ProteinFolding::new(sequence.clone()), &result.positions());
    }

    let time = Instant::now();
    let mut best = None;
    let protein = Local2dProteinFolding::new(sequence.clone());
    let mut rng = rand::rng();
    for _ in 0..=10000 {
        let result = hill_climping(&protein, &mut rng, 100);
        if let Some(result) = result {
            if best.clone().is_none_or(|best| {
                protein
                    .heuristic(&result)
                    .is_better(protein.heuristic(&best))
            }) {
                best = Some(result);
            }
        }
    }
    println!("{:?}", time.elapsed());
    if let Some(result) = best {
        println!("best result: {:?}", protein.heuristic(&result));
        debug_conformation(&ProteinFolding::new(sequence.clone()), &result.positions());
    }

    // let mut set = BTreeSet::new();
    // for pos in result.positions() {
    //     set.insert(pos);
    // }
    // let overlaps = (result.positions().len() - set.len()) as i32;
    // println!("overlaps: {overlaps}");

    // let protein = ProteinFolding::new(sequence.clone());
    // let arena = Bump::new();
    // let time = Instant::now();
    // let conformation = clean::search_on_tree_arena::<_, clean::TreePriorityFrontier<_, _>, Contacts>(
    //     protein.clone(),
    //     AminoAcid::default().into(),
    //     &arena,
    // );
    // println!("{:?}", time.elapsed());
    // debug_conformation(&protein, &conformation.unwrap().into_iter().collect());
    //
    // let bump = Bump::new();
    // let protein = ProteinFolding::new(sequence.clone());
    // let mut agent = Agent::new(protein.clone());
    // let mut conformation = vec![(0, 0)];
    // let time = Instant::now();
    // // agent.function_on_tree::<TreeUniformCost<Cost>>(AminoAcid::default())
    // while let Some(pos) =
    //     // agent.function_on_tree::<TreeUniformCost<_, Cost>, _>(AminoAcid::default())
    //     agent
    //         .function_on_tree_arena::<TreeUniformCostArena<'_, _, Contacts>, _>(
    //             AminoAcid::default(),
    //             &bump,
    //         )
    // {
    //     conformation.push(pos);
    // }
    // println!("{:?}", time.elapsed());
    // debug_conformation(&protein, &conformation);
    //
    let bump = Bump::new();
    let protein = ProteinFolding::new(sequence.clone());
    let mut agent = Agent::new(protein.clone());
    let mut conformation = vec![(0, 0)];
    let time = Instant::now();
    // agent.function_on_tree::<TreeUniformCost<Cost>>(AminoAcid::default())
    while let Some(pos) =
        // agent.function_on_tree::<TreeUniformCost<_, Cost>, _>(AminoAcid::default())
        agent
            .function_on_tree_arena::<TreeUniformCostArena<'_, _, MissedContacts>, _>(
                AminoAcid::default(),
                &bump,
            )
    {
        conformation.push(pos);
    }
    println!("{:?}", time.elapsed());
    debug_conformation(&protein, &conformation);
    //
    // let bump = Bump::new();
    // let protein = ProteinFolding::new(sequence.clone());
    // let mut agent = Agent::new(protein.clone());
    // let mut conformation = vec![(0, 0)];
    // let time = Instant::now();
    // // while let Some(pos) = agent.function_on_tree::<TreeAStar<_, Cost>, _>(AminoAcid::default()) {
    // while let Some(pos) = agent.function_on_tree_arena::<TreeAStarArena<'_, _, MissedContacts>, _>(
    //     AminoAcid::default(),
    //     &bump,
    // ) {
    //     conformation.push(pos);
    // }
    // println!("{:?}", time.elapsed());
    // debug_conformation(&protein, &conformation);
}

fn debug_conformation(protein: &ProteinFolding, conformation: &Conformation) {
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
                    print!("{:?}", protein[i])
                }
            } else {
                print!(".")
            }
        }
        println!()
    }

    // for (i, pos) in conformation.iter().enumerate() {
    //     println!("{:?}: {:?}", protein[i], pos)
    // }

    println!("{:?}\n\n", protein.energy(conformation));
}

// let mut agent = Agent::new(protein.clone());
// let mut conformation = vec![(0, 0)];
// let time = Instant::now();
// while let Some(pos) =
//     agent.function_on_tree::<_, GraphUniformCost<_, Cost>, _>(AminoAcid::default())
// {
//     conformation.push(pos);
// }
// println!("{:?}", time.elapsed());
// debug_conformation(&protein, &conformation);
//
// let mut agent = Agent::new(protein.clone());
// let mut conformation = vec![(0, 0)];
// let time = Instant::now();
// while let Some(pos) = agent.function::<_, GraphAStar<_, Cost>, _>(AminoAcid::default()) {
//     conformation.push(pos);
// }
// println!("{:?}", time.elapsed());
// debug_conformation(&protein, &conformation);

// let cards = [1, 1, 2, 2, 3, 3, 4];
// let n = 7;
// for i in 1..=n {
//     println!("⟨{{P_1, V, P_2, X_{i}, X{}}}, ", i + 1);
//     for p1 in 1..=n {
//         for v in 1..=n {
//             for p2 in 1..=n {
//                 for l in 1..=n {
//                     for m in 1..=n {
//                         if (1 <= i && i < p1 - 1) || (v <= i && i < p2 - 1) {
//                             if l < m {
//                                 println!("({p1}, {v}, {p2}, {l}, {m}),");
//                             }
//                         } else if (p1 <= i && i < v - 1) || (p2 <= i && i < n - 1) {
//                             if l > m {
//                                 println!("({p1}, {v}, {p2}, {m}, {l}),");
//                                 // println!("(),")
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }
//     println!("⟩");
// }

// for i in 1..=n {
//     for j in i + 1..=n {
//         for k in j + 1..=n {
//             println!("({i}, {j}, {k})")
//         }
//     }
// }

// let sequence = vec![H, H, P, P, H, H];

// println!("{:?}", size_of::<ai::exploration::Node<Pos, u32>>());
// println!("{:?}", size_of::<ai::exploration::Node2<Pos, u32>>());
// println!("{:?}", size_of::<ai::exploration::Node3<Rc<AminoAcid> Pos, u32>>());

// let x = HashMap::new();

// return;

// const LENGTH: usize = 20;
// const EXECUTIONS: usize = 300;
//
// let mut rng = rand::rng();
//
// let sequences: Vec<Vec<_>> = (0..EXECUTIONS)
//     .map(|i| {
//         let mut sequence: Vec<Alphabet> = (1..LENGTH)
//             .map(|_| {
//                 if rng.random_ratio(i as u32, EXECUTIONS as u32) {
//                     H
//                 } else {
//                     P
//                 }
//             })
//             .collect();
//
//         sequence[LENGTH - 2] = H;
//         sequence[0] = H;
//
//         sequence
//     })
//     .collect();
//
// let simulation_time = Instant::now();
// let times: Vec<_> = sequences
//     .into_par_iter()
//     .map(|s| {
//         let h_count = s.iter().filter(|a| matches!(a, H)).count();
//         let time = Instant::now();
//         let mut agent = Agent::new(ProteinFolding::new(s));
//         while agent
//             .tree_function::<AminoAcid, MinCostTree<Pos, Energy>>(AminoAcid::default())
//             .is_some()
//         {}
//
//         (time.elapsed(), h_count)
//     })
//     .collect();
//
// println!("simulation: {:?}", simulation_time.elapsed());
//
// let mut sums = [Duration::new(0, 0); LENGTH];
// let mut cnts = [0; LENGTH];
//
// for (t, h_count) in times {
//     cnts[h_count] += 1;
//     sums[h_count] += t;
// }
//
// let avg: Vec<_> = sums
//     .iter()
//     .zip(cnts)
//     .map(|(s, n)| s.as_millis() as f64 / n as f64)
//     .collect();
//
// println!("{:?}", avg);

// let mut conformation = vec![(0, 0)];
// conformation.push(pos);

// let sequence = vec![H, H, H, P, P, H, P, H, H, P, H, H, P, H, H, P, H, P];

// let sequence = vec![H, H, P, H, P, P, H, H, H, P, P, P, P, H, H, P];
//let sequence = vec![P, H, H, P, H, P, P, H, P];

//let sequence = vec![P, P, P, P, P, P, P, P, P];
//let sequence = vec![P, P, P, P, P, P, P, P, H];
//let sequence = vec![P, P, P, P, P, P, H, P, H];
// let sequence = vec![H, P, P, P, P, H, P, P, P, H, P, P, P, P, H, P, P, P, H];
//let sequence = vec![P, P, H, P, H, P, H, P, H];
//let sequence = vec![H, P, H, P, H, P, H, P, H];
//let sequence = vec![H, P, H, P, H, P, H, H, H];
//let sequence = vec![H, P, H, P, H, H, H, H, H];
//let sequence = vec![H, P, H, H, H, H, H, H, H];
//let sequence = vec![H, H, H, H, H, H, H, H, H];

// TODO: la distanza "pari" fra due H è interessante... si potrebbe precalcolare
// guacamole: la distanza "pari" gioca un ruolo fondamentale, vaccaccia

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
// let cnt = ((i as f64 / EXECUTIONS as f64) * (LENGTH as f64)) as usize;
// if v < cnt { H } else { P }

// let mut rng = rng();
// if rng.random_bool((i as f64 / EXECUT as f64).clamp(0.0, 1.0)) {
// let mut h_count = 0;
// for (i, a) in s[..s.len() - 2].iter().enumerate() {
//     if matches!((a, s[i + 2].clone()), (H, H)) {
//         h_count += 1;
//     }
// }

// il costo è numero di contatti non realizzati
