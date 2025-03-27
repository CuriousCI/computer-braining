use rayon::iter::ParallelIterator;

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

pub trait Heuristic<H>: Problem {
    fn heuristic(&self, state: &Self::State) -> H;
}

pub trait Exploration<H>: Transition + Heuristic<H> {
    fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::Action, H)>;
}

pub trait Local: Transition {
    fn expand(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;
}

pub trait ParallelLocal: Transition {
    fn expand(&self, state: &Self::State) -> impl ParallelIterator<Item = Self::Action>;
}
