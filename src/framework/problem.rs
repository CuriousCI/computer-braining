pub trait Problem {
    type State;
}

pub trait TransitionModel: Problem {
    type Action;

    fn actions(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;

    fn result(&self, state: &Self::State, action: &Self::Action) -> Self::State;
}

pub trait GoalBased: Problem {
    fn goal_test(&self, state: &Self::State) -> bool;
}

pub trait Utility<T>: TransitionModel {
    fn utility(&self, prev: &Self::State, next: &Self::State, action: &Self::Action) -> T;
}

pub trait Heuristic: Problem {
    type Value;

    fn heuristic(&self, state: &Self::State) -> Self::Value;
}

pub trait Mutable: Problem {
    fn mutate(&self, state: Self::State, rng: &mut impl rand::Rng) -> Self::State;
}

pub trait CrossOver: Problem {
    fn cross_over(&self, l: &Self::State, r: &Self::State, rng: &mut impl rand::Rng)
    -> Self::State;
}
