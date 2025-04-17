pub trait Problem {
    type State;
}

pub trait Transition: Problem {
    type Action;

    fn new_state(&self, state: &Self::State, action: &Self::Action) -> Self::State;
}

pub trait Goal: Problem {
    fn is_goal(&self, state: &Self::State) -> bool;
}

// pub trait Heuristic<V>: Problem {
//     fn heuristic(&self, state: &Self::State) -> V;
// }

pub trait Heuristic: Problem {
    type Value;

    fn heuristic(&self, state: &Self::State) -> Self::Value;
}

// pub trait Exploration<V>: Transition + Heuristic<V> {
//     fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::Action, V)>;
// }

pub trait Search: Transition + Heuristic {
    fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::Action, Self::Value)>;
}

pub trait Local: Transition {
    fn expand(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;
}

use rayon::iter::ParallelIterator;

pub trait ParallelLocal: Transition {
    fn expand(&self, state: &Self::State) -> impl ParallelIterator<Item = Self::Action>;
}
