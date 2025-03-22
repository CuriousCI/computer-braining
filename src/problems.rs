pub trait Problem<S, A, V, T> {
    fn expansion(&self, state: &S) -> impl Iterator<Item = T>;
    fn new_state(&self, state: &S, action: &A) -> S;
    fn value(&self, state: &S) -> V;
}

pub trait StateSpaceExploration<S, A>: Problem<S, A, usize, (S, A, usize)> {
    fn is_goal(&self, state: &S) -> bool;
}

pub trait IterativeImprovement<S, A, V>: Problem<S, A, V, A> {}
