use std::{
    cmp::Reverse,
    collections::{HashMap, VecDeque},
    fmt::Debug,
    hash::Hash,
    rc::Rc,
};

use crate::problem_solving_agent::*;

pub struct Breadth<S, A>(VecDeque<(S, Rc<Node<A>>)>);

impl<S, A> Debug for Breadth<S, A>
where
    S: Debug,
    A: Debug,
{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

impl<S, A> Default for Breadth<S, A> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<S, A> Frontier<S, A> for Breadth<S, A>
where
    S: Debug,
    A: Debug,
{
    fn next(&mut self) -> Option<(S, Rc<Node<A>>)> {
        self.0.pop_front()
    }

    fn insert(&mut self, state: S, node: Rc<Node<A>>) {
        self.0.push_back((state, node));
    }
}

pub struct Depth<S, A>(Vec<(S, Rc<Node<A>>)>);

impl<S, A> Debug for Depth<S, A>
where
    S: Debug,
    A: Debug,
{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

impl<S, A> Default for Depth<S, A> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<S, A> Frontier<S, A> for Depth<S, A>
where
    S: Debug,
    A: Debug,
{
    fn next(&mut self) -> Option<(S, Rc<Node<A>>)> {
        self.0.pop()
    }

    fn insert(&mut self, state: S, node: Rc<Node<A>>) {
        self.0.push((state, node));
    }
}

use priority_queue::PriorityQueue;

pub struct PriorityFrontier<S, A, N>(
    PriorityQueue<S, Reverse<(usize, S)>>,
    HashMap<S, Rc<Node<A>>>,
    std::marker::PhantomData<N>,
)
where
    S: Ord + Hash,
    N: FromNode<A>;

impl<S, A, N> Default for PriorityFrontier<S, A, N>
where
    S: Ord + Hash + Clone,
    N: FromNode<A>,
{
    fn default() -> Self {
        Self(Default::default(), Default::default(), Default::default())
    }
}

impl<S, A, N> Debug for PriorityFrontier<S, A, N>
where
    S: Ord + Hash + Clone + Debug,
    N: FromNode<A>,
    A: Debug,
{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for x in self.0.clone().into_sorted_iter() {
            if let Some(v) = self.1.get(&x.0) {
                f.write_fmt(format_args!("({:?}, {:?}), ", x.0, v))?
            }
        }
        f.write_str("\n")
    }
}

impl<S, A, N> Frontier<S, A> for PriorityFrontier<S, A, N>
where
    S: Hash + Ord + Clone + Debug,
    N: FromNode<A>,
    A: Debug,
{
    fn next(&mut self) -> Option<(S, Rc<Node<A>>)> {
        self.0.pop().and_then(|(state, _)| {
            let node = self.1.get(&state)?.clone();
            Some((state, node))
        })
    }

    fn insert(&mut self, state: S, node: Rc<Node<A>>) {
        self.0
            .push(state.clone(), Reverse((N::cost(&node), state.clone())));
        self.1.insert(state, node);
    }

    fn change(&mut self, state: &S, node: Rc<Node<A>>) {
        if self
            .1
            .get(state)
            .is_none_or(|prev| N::cost(prev) > N::cost(&node))
        {
            self.0
                .change_priority(state, Reverse((N::cost(&node), state.clone())));
            self.1.insert(state.clone(), node);
        }
    }
}

pub struct MinCostPolicy;

impl<A> FromNode<A> for MinCostPolicy {
    fn cost(node: &Node<A>) -> Cost {
        node.g
    }
}

pub struct BestFirstPolicy;

impl<A> FromNode<A> for BestFirstPolicy {
    fn cost(node: &Node<A>) -> Cost {
        node.h
    }
}

pub struct AStarPolicy;

impl<A> FromNode<A> for AStarPolicy {
    fn cost(node: &Node<A>) -> Cost {
        node.g + node.h
    }
}

pub type MinCost<S, A> = PriorityFrontier<S, A, MinCostPolicy>;
pub type BestFirst<S, A> = PriorityFrontier<S, A, BestFirstPolicy>;
pub type AStar<S, A> = PriorityFrontier<S, A, AStarPolicy>;
