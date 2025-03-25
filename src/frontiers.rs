use std::{
    cmp::Reverse,
    collections::{HashMap, VecDeque},
    hash::Hash,
    ops::Add,
    rc::Rc,
};

use crate::problem_solving_agent::*;

pub struct BFS<S, A, U>(VecDeque<(S, Rc<Node<A, U>>)>);

impl<S, A, U> Default for BFS<S, A, U> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<S, A, U> Frontier<S, A, U> for BFS<S, A, U> {
    fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
        self.0.pop_front()
    }

    fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
        self.0.push_back((state, node));
    }
}

pub struct DFS<S, A, U>(Vec<(S, Rc<Node<A, U>>)>);

impl<S, A, U> Default for DFS<S, A, U> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<S, A, U> Frontier<S, A, U> for DFS<S, A, U> {
    fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
        self.0.pop()
    }

    fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
        self.0.push((state, node));
    }
}

use priority_queue::PriorityQueue;

pub struct PriorityFrontier<S, A, N, U>(
    PriorityQueue<S, Reverse<(U, S)>>,
    HashMap<S, Rc<Node<A, U>>>,
    std::marker::PhantomData<N>,
)
where
    S: Ord + Hash,
    N: FromNode<A, U>;

impl<S, A, N, U> Default for PriorityFrontier<S, A, N, U>
where
    U: Default + Ord,
    S: Ord + Hash + Clone,
    N: FromNode<A, U>,
{
    fn default() -> Self {
        Self(Default::default(), Default::default(), Default::default())
    }
}

impl<S, A, N, U> Frontier<S, A, U> for PriorityFrontier<S, A, N, U>
where
    U: Default + Ord,
    S: Hash + Ord + Clone,
    N: FromNode<A, U>,
{
    fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
        self.0.pop().and_then(|(state, _)| {
            let node = self.1.get(&state)?.clone();
            Some((state, node))
        })
    }

    fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
        self.0
            .push(state.clone(), Reverse((N::value(&node), state.clone())));
        self.1.insert(state, node);
    }

    fn change(&mut self, state: &S, node: Rc<Node<A, U>>) {
        if self
            .1
            .get(state)
            .is_none_or(|prev| N::value(prev) > N::value(&node))
        {
            self.0
                .change_priority(state, Reverse((N::value(&node), state.clone())));
            self.1.insert(state.clone(), node);
        }
    }
}

pub struct MinCostPolicy;

impl<A, U> FromNode<A, U> for MinCostPolicy
where
    U: Clone,
{
    fn value(node: &Node<A, U>) -> U {
        node.g.clone()
    }
}

pub struct BestFirstPolicy;

impl<A, U> FromNode<A, U> for BestFirstPolicy
where
    U: Clone,
{
    fn value(node: &Node<A, U>) -> U {
        node.h.clone()
    }
}

pub struct AStarPolicy;

impl<A, U> FromNode<A, U> for AStarPolicy
where
    U: Clone + Add<Output = U>,
{
    fn value(node: &Node<A, U>) -> U {
        node.g.clone() + node.h.clone()
    }
}

pub type MinCost<S, A, U> = PriorityFrontier<S, A, MinCostPolicy, U>;
pub type BestFirst<S, A, U> = PriorityFrontier<S, A, BestFirstPolicy, U>;
pub type AStar<S, A, U> = PriorityFrontier<S, A, AStarPolicy, U>;
