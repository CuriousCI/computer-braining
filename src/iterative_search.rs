use crate::problem::{Heuristic, Local, ParallelLocal};
use rand::{Rng, distr::Distribution, seq::IteratorRandom};
use rayon::prelude::*;

pub fn steepest_descent<P, S, H>(local_problem: &P, initial_state: S) -> S
where
    H: Ord + Clone,
    P: Local<State = S> + Heuristic<H>,
{
    let mut state = initial_state;
    let mut heuristic = local_problem.heuristic(&state);

    loop {
        (state, heuristic) = match local_problem
            .expand(&state)
            .filter_map(|action| {
                let new_state = local_problem.new_state(&state, &action);
                let new_heuristic = local_problem.heuristic(&new_state);

                (new_heuristic < heuristic).then_some((new_state, new_heuristic))
            })
            .min_by_key(|(_, h)| h.clone())
        {
            Some(new) => new,
            _ => return state,
        };
    }
}

pub fn parallel_steepest_ascent<P, S, H>(problem: &P, rng: &mut impl Rng) -> Option<S>
where
    P: Sync,
    S: Send + Sync,
    H: Ord + Copy + Send + Sync,
    P: ParallelLocal<State = S> + Heuristic<H> + Distribution<S>,
{
    let mut state = problem.sample(rng);
    let mut utility = problem.heuristic(&state);

    loop {
        (state, utility) = match problem
            .expand(&state)
            .filter_map(|action| {
                let new_state = problem.new_state(&state, &action);
                let new_utility = problem.heuristic(&new_state);

                (new_utility > utility).then_some((new_state, new_utility))
            })
            .max_by_key(|&(_, value)| value)
        {
            Some(new) => new,
            _ => return Some(state),
        };
    }
}

pub fn hill_climping<P, S, H>(problem: &P, rng: &mut impl Rng, threshold: usize) -> Option<S>
where
    H: Ord,
    P: Local<State = S> + Distribution<S> + Heuristic<H>,
{
    let mut state = problem.sample(rng);
    let mut utility = problem.heuristic(&state);
    let mut counter = 0;

    loop {
        let new_state = problem
            .expand(&state)
            // Allow only better or lateral movements
            .filter_map(|action| {
                let new_state = problem.new_state(&state, &action);
                let new_utility = problem.heuristic(&new_state);

                (new_utility >= utility).then_some((new_state, new_utility))
            })
            // Get the first one
            .next();

        (state, utility) = match new_state {
            Some((new_state, new_utility)) => {
                if new_utility == utility {
                    // Keep track of plateaus
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

pub fn simulated_annealing<P, S, H, F, D>(
    problem: &P,
    rng: &mut impl Rng,
    temperature: F,
    delta: D,
) -> Option<S>
where
    H: Ord + Clone,
    P: Local<State = S> + Heuristic<H> + Distribution<S>,
    F: Fn(usize) -> f64,
    D: Fn(&H, &H) -> f64,
{
    let mut state = problem.sample(rng);
    let mut utility = problem.heuristic(&state);

    for time in 0.. {
        let temp = temperature(time);
        // Due to floating-point ISSUES, it's better to use an epsilon here
        if temp <= 10e-6 {
            return Some(state);
        }

        let action = match problem.expand(&state).choose(rng) {
            Some(action) => action,
            None => return Some(state),
        };

        let new_state = problem.new_state(&state, &action);
        let new_utility = problem.heuristic(&new_state);
        // either the new state is better, or pick it with a certain probability
        if new_utility > utility
            || rng.random_bool((-(delta(&new_utility, &utility)).abs() / temp).exp())
        {
            (state, utility) = (new_state, new_utility)
        }
    }

    None
}

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
