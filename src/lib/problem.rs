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

// If implements Utility it automatically implements Cost which is the reverse of the utility?
// Think about it...
// more Utility vs Cost trait
pub trait Heuristic: Problem {
    type Value;

    fn heuristic(&self, state: &Self::State) -> Self::Value;
}

pub trait Mutable: Problem {
    fn mutate(&self, state: &mut Self::State, rng: &mut impl rand::Rng);
}

pub trait CrossOver: Problem {
    fn cross_over(&self, l: &Self::State, r: &Self::State, rng: &mut impl rand::Rng)
    -> Self::State;
}
