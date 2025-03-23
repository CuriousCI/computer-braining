use rayon::iter::ParallelIterator;

/// A trait to define problems.
///
/// It only requires a transition model.
/// Different algorithms may require different ways to generate the initial state, so it's not a part of the contract.
pub trait TransitionModel {
    type State;
    type Action;

    fn new_state(&self, state: &Self::State, action: &Self::Action) -> Self::State;
}

/// A trait to define goal-based problems.
pub trait Goal: TransitionModel {
    fn is_goal(&self, state: &Self::State) -> bool;
}

/// A trait to define utility-based problems
///
/// Different algorithms have different interpretations for the utility
/// _(eg. genetic algorithms try to maximize the "fitness", exploration algorithms try to minimize the "cost")_.
///
/// The generic parameter allows for multiple utility functions for the same problem, to adapt the
/// problem definition to multiple algorithms.
pub trait Utility<U>: TransitionModel {
    fn utility(&self, state: &Self::State) -> U;
}

/// A trait used by exploration algorithms
///
/// The utility in state-space exploration is interpreted as the heuristics.
/// The expand method returns a `Self::Action` and its actual cost.
pub trait Exploration<U>: Utility<U> + Goal {
    fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::Action, U)>;
}

/// A trait used by iterative improvement algorithms
pub trait IterativeImprovement<U>: Utility<U> {
    fn expand(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;
}

/// Some iterative improvement algorithms might be parallelizable
pub trait ParallelImprovement<U>: Utility<U> {
    fn expand(&self, state: &Self::State) -> impl ParallelIterator<Item = Self::Action>;
}
