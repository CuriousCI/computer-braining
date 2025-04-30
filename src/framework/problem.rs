pub trait Problem {
    type State;
    type Action;

    fn actions(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;

    fn result(&self, state: &Self::State, action: &Self::Action) -> Self::State;
}

pub trait GoalBased: Problem {
    fn goal_test(&self, state: &Self::State) -> bool;
}

pub trait Utility<T>: Problem {
    fn utility(&self, prev: &Self::State, next: &Self::State, action: &Self::Action) -> T;
}

pub trait Heuristic: Problem {
    type Value;

    fn heuristic(&self, state: &Self::State) -> Self::Value;
}
