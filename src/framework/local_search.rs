use crate::framework::problem::{Heuristic, Problem};
use rand::{Rng, distr::Distribution, seq::IteratorRandom};
use rayon::prelude::*;

pub fn steepest_ascent<P>(problem: &P, initial_state: P::State) -> P::State
where
    P: Problem + Heuristic,
    P::Value: Ord + Clone,
{
    let mut state = initial_state;
    let mut heuristic = problem.heuristic(&state);

    loop {
        (state, heuristic) = match problem
            .actions(&state)
            .filter_map(|action| {
                let new_state = problem.result(&state, &action);
                let new_heuristic = problem.heuristic(&new_state);

                (new_heuristic < heuristic).then_some((new_state, new_heuristic))
            })
            .max_by_key(|(_, h)| h.clone())
        {
            Some(new) => new,
            _ => return state,
        };
    }
}

// P: Sync + ParallelLocal + Heuristic + Distribution<P::State>,
// pub fn parallel_steepest_ascent<P>(problem: &P, rng: &mut impl Rng) -> Option<P::State>
// where
//     P::State: Send + Sync,
//     P::Value: Ord + Copy + Send + Sync,
//     P: TransitionModel + Heuristic + Distribution<P::State> + Sync,
//     // ParallelTransitionModel
// {
//     let mut state = problem.sample(rng);
//     let mut utility = problem.heuristic(&state);
//
//     loop {
//         (state, utility) = match problem
//             .actions(&state)
//             .filter_map(|action| {
//                 let new_state = problem.result(&state, &action);
//                 let new_utility = problem.heuristic(&new_state);
//
//                 (new_utility > utility).then_some((new_state, new_utility))
//             })
//             .max_by_key(|&(_, value)| value)
//         {
//             Some(new) => new,
//             _ => return Some(state),
//         };
//     }
// }

pub fn hill_climping<P>(problem: &P, rng: &mut impl Rng, threshold: usize) -> Option<P::State>
where
    P: Problem + Distribution<P::State> + Heuristic,
    P::Value: Ord,
{
    let mut state = problem.sample(rng);
    let mut utility = problem.heuristic(&state);
    let mut counter = 0;

    loop {
        let new_state = problem
            .actions(&state)
            .filter_map(|action| {
                let new_state = problem.result(&state, &action);
                let new_utility = problem.heuristic(&new_state);

                (new_utility >= utility).then_some((new_state, new_utility))
            })
            .next();

        (state, utility) = match new_state {
            Some((new_state, new_utility)) => {
                if new_utility == utility {
                    counter += 1;
                }

                if counter >= threshold {
                    return Some(new_state);
                }

                (new_state, new_utility)
            }
            _ => return Some(state),
        };
    }
}

pub fn simulated_annealing<P, F, D>(
    problem: &P,
    rng: &mut impl Rng,
    temperature: F,
    delta: D,
) -> Option<P::State>
where
    P::Value: Ord + Clone,
    // P: LocalSearch + Heuristic + Distribution<P::State>,
    P: Heuristic + Distribution<P::State>,
    F: Fn(usize) -> f64,
    D: Fn(&P::Value, &P::Value) -> f64,
{
    let mut state = problem.sample(rng);
    let mut utility = problem.heuristic(&state);

    for time in 0.. {
        let temp = temperature(time);
        if temp <= 10e-6 {
            return Some(state);
        }

        let action = match problem.actions(&state).choose(rng) {
            Some(action) => action,
            None => return Some(state),
        };

        let new_state = problem.result(&state, &action);
        let new_utility = problem.heuristic(&new_state);
        if new_utility > utility
            || rng.random_bool((-(delta(&new_utility, &utility)).abs() / temp).exp())
        {
            (state, utility) = (new_state, new_utility)
        }
    }

    None
}

// Due to floating-point ISSUES, it's better to use an epsilon here

// let action = match problem.result(&state).choose(rng) {
//     Some(action) => action,
//     None => return Some(state),
// };
// either the new state is better, or pick it with a certain probability

// Same as above, but
// - parallelization helps a lot with bigger instances
// - it requires a stricter contract on the problems (with Send + Sync)

pub fn local_beam() {}

//1 function local_beam(problema, k): stato ottimo locale
//2 popolazione_corrente ← lista di k stati random di problema;
//3 while true do
//4 successori ← insieme vuoto;
//5 foreach s in popolazione_corrente do
//6 aggiungi a successori tutti gli stati vicini di s;
//7 if successori contiene uno stato soluzione sol then
//8 return sol;
//9 else
//10 popolazione_corrente ← i k elementi migliori di successori

pub fn genetic_algorithm() {}

//function genetic_algorithm(problema, k, pmut): stato ottimo locale
//2 pop_corr ← insieme di k stati random di problema;
//3 while true do
//4 if pop_corr contiene soluzioni suff. buone or tempo scaduto then
//5 return la migliore soluzione in pop_corr;
//6 successori ← insieme vuoto;
//7 while |successori| < k do
//8 gen1 ← stato random di pop_corr, favorendo i migliori;
//9 gen2 ← stato random di pop_corr, favorendo i migliori;
//10 xover ← intero random tra 1 ed S;
//11 substr1 ← sottostringa di gen1 fino a xover − 1;
//12 substr2 ← sottostringa di gen2 da xover in poi;
//13 figlio ← concatena substr1 e substr2;
//14 con probabilità pmut, effettua una modifica random del valore di
//un gene random di figlio;
//15 aggiungi figlio a successori;
//16 pop_corr ← successori;
