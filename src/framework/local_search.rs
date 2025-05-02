use super::problem::{CrossOver, Heuristic, Mutable, TransitionModel};
use rand::{
    Rng,
    distr::{
        Distribution,
        uniform::SampleUniform,
        weighted::{Weight, WeightedIndex},
    },
    prelude::*,
    seq::IteratorRandom,
};

// 1. steepest ascent/descent with restarts
// 2. first-choice hill climbing with restarts
// 3. simulated annealing
// 4. local beam search
// 5. genetic algorithms

pub fn steepest_ascent<P>(problem: &P, initial_state: P::State) -> P::State
where
    P: TransitionModel + Heuristic,
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

pub fn hill_climping<P>(problem: &P, rng: &mut impl Rng, threshold: usize) -> Option<P::State>
where
    P: TransitionModel + Heuristic + Distribution<P::State>,
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
    P: TransitionModel + Heuristic + Distribution<P::State>,
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

pub fn local_beam<P>(problem: &P, k: usize, threshold: usize, rng: &mut impl Rng) -> P::State
where
    P: TransitionModel + Heuristic + Distribution<P::State>,
    P::Value: Ord,
    P::State: Clone,
{
    let mut instances = Vec::from_iter((0..k).map(|_| problem.sample(rng)));

    for _ in 0..threshold {
        let mut successors: Vec<_> = instances
            .iter()
            .flat_map(|state| {
                problem
                    .actions(state)
                    .map(|action| problem.result(state, &action))
            })
            .collect();

        successors.sort_unstable_by_key(|state| problem.heuristic(state));
        instances = successors.into_iter().take(k).collect();
    }

    instances[0].clone()
}

pub fn genetic_algorithm<P>(problem: &P, k: usize, threshold: usize, rng: &mut impl Rng) -> P::State
where
    P: Mutable + CrossOver + Heuristic + Distribution<P::State>,
    P::Value: Ord + Into<f32>,
    P::State: Clone,
{
    let mut population = Vec::from_iter((0..k).map(|_| problem.sample(rng)));
    let mut index: WeightedIndex<f32> = WeightedIndex::new(
        population
            .iter()
            .map(|state| problem.heuristic(state).into()),
    )
    .unwrap();

    for _ in 0..threshold {
        let mut successors = vec![];

        while successors.len() < k {
            // let l = population.iter().choose(rng).unwrap();
            // let r = population.iter().choose(rng).unwrap();
            let l = &population[index.sample(rng)];
            let r = &population[index.sample(rng)];

            let mut child = problem.cross_over(l, r, rng);
            problem.mutate(&mut child, rng);

            successors.push(child);
        }

        population = successors;
        // population.sort_unstable_by_key(|state| problem.heuristic(state));
        index = WeightedIndex::new(
            population
                .iter()
                .map(|state| problem.heuristic(state).into()),
        )
        .unwrap();
    }

    population.sort_unstable_by_key(|state| problem.heuristic(state));
    population[0].clone()
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
