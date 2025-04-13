use std::{
    cmp::Reverse,
    collections::{BinaryHeap, HashMap, VecDeque},
    // fmt::Display,
    hash::Hash,
    ops::Add,
};

use crate::exploration::*;

#[derive(Default)]
pub struct BFS(VecDeque<(usize, usize)>);

impl<A, H> Frontier<A, H> for BFS {
    fn next(&mut self) -> Option<(usize, usize)> {
        self.0.pop_front()
    }

    fn insert(&mut self, state: usize, node: usize, _info: &[Node<A, H>]) {
        self.0.push_back((state, node));
    }
}

#[derive(Default)]
pub struct DFS(Vec<(usize, usize)>);

impl<A, H> Frontier<A, H> for DFS {
    fn next(&mut self) -> Option<(usize, usize)> {
        self.0.pop()
    }

    fn insert(&mut self, state: usize, node: usize, _info: &[Node<A, H>]) {
        self.0.push((state, node));
    }
}

use priority_queue::PriorityQueue;

pub struct TreePriorityFrontier<A, N, H>(BinaryHeap<(H, usize)>, std::marker::PhantomData<(A, N)>)
where
    N: FromNode<A, H>;

impl<A, N, H> Default for TreePriorityFrontier<A, N, H>
where
    H: Ord,
    N: FromNode<A, H>,
{
    fn default() -> Self {
        Self(Default::default(), Default::default())
    }
}

impl<A, N, H> Frontier<A, H> for TreePriorityFrontier<A, N, H>
where
    H: Ord,
    N: FromNode<A, H>,
{
    fn next(&mut self) -> Option<(usize, usize)> {
        self.0.pop().map(|(_, s)| (s, s))
    }

    fn insert(&mut self, state: usize, node: usize, nodes: &[Node<A, H>]) {
        self.0.push((N::value(&nodes[node]), state))
    }
}

pub struct PriorityFrontier<A, N, H>(
    PriorityQueue<usize, Reverse<H>>,
    Vec<usize>,
    // HashMap<usize, usize>,
    std::marker::PhantomData<(A, N)>,
)
where
    N: FromNode<A, H>;

impl<A, N, H> Default for PriorityFrontier<A, N, H>
where
    H: Ord,
    N: FromNode<A, H>,
{
    fn default() -> Self {
        Self(Default::default(), Default::default(), Default::default())
    }
}

impl<A, N, H> Frontier<A, H> for PriorityFrontier<A, N, H>
where
    H: Ord,
    N: FromNode<A, H>,
{
    fn next(&mut self) -> Option<(usize, usize)> {
        self.0.pop().map(|(state, _)| (state, self.1[state]))
    }

    // let node = self.1[state];
    // let node = self.1.get(&state)?;
    // Some((state, *node))
    // self.1.insert(state, node);

    fn insert(&mut self, state: usize, node: usize, nodes: &[Node<A, H>]) {
        self.0.push(state, Reverse(N::value(&nodes[node])));
        self.1.push(node);
    }

    fn update(&mut self, state: &usize, node: usize, nodes: &[Node<A, H>]) {
        if self
            .1
            .get(*state)
            .is_none_or(|&prev| N::value(&nodes[prev]) > N::value(&nodes[node]))
        {
            self.0
                .change_priority(state, Reverse(N::value(&nodes[node])));

            self.1.insert(*state, node);
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

pub type MinCost<A, H> = PriorityFrontier<A, MinCostPolicy, H>;
pub type MinCostTree<A, H> = TreePriorityFrontier<A, MinCostPolicy, H>;
pub type BestFirst<A, H> = PriorityFrontier<A, BestFirstPolicy, H>;
pub type AStar<A, H> = PriorityFrontier<A, AStarPolicy, H>;
pub type AStarTree<A, H> = TreePriorityFrontier<A, AStarPolicy, H>;

// impl Default for BFS {
//     fn default() -> Self {
//         Self(Default::default())
//     }
// }

// impl Default for DFS {
//     fn default() -> Self {
//         Self(Default::default())
//     }
// }

// Reverse((N::value(&nodes[node]), state.clone())),
// self.0
//     .change_priority(state, Reverse((N::value(&nodes[node]), state.clone())));

// hash::Hash,

// impl<S> Default for BFS {
//     fn default() -> Self {
//         Self(Default::default())
//     }
// }

// pub struct DFS<S>(Vec<(S, usize)>);
//
// impl<S> Default for DFS<S> {
//     fn default() -> Self {
//         Self(Default::default())
//     }
// }
//
// impl<S, A, H> Frontier<S, A, H> for DFS<S> {
//     fn next(&mut self) -> Option<(S, usize)> {
//         self.0.pop()
//     }
//
//     fn insert(&mut self, state: S, node: usize, _nodes: &[Node<A, H>]) {
//         self.0.push((state, node));
//     }
// }
// impl<S> Default for DFS<S> {
//     fn default() -> Self {
//         Self(Default::default())
//     }
// }
// PriorityQueue<S, Reverse<(H, S)>>,
// S: Ord + Hash,
// S: Ord + Hash + Clone,
// S: Hash + Ord + Clone,

// pub struct BFS<S, A, U>(VecDeque<(S, Rc<Node<A, U>>)>);
// fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
//     self.0.pop_front()
// }
//
// fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
//     self.0.push_back((state, node));
// }

// pub struct DFS<S, A, U>(Vec<(S, Rc<Node<A, U>>)>);
// fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
//     self.0.pop()
// }
//
// fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
//     self.0.push((state, node));
// }

// pub struct PriorityFrontier<S, A, N, H>(
//     PriorityQueue<S, Reverse<(H, S)>>,
//     HashMap<S, Rc<Node<A, H>>>,
//     std::marker::PhantomData<N>,
// )
// where
//     S: Ord + Hash,
//     N: FromNode<A, H>;

// if self
//     .1
//     .get(state)
//     .is_none_or(|prev| N::value(prev) > N::value(&node))
// {
//     self.0
//         .change_priority(state, Reverse((N::value(&node), state.clone())));
//     self.1.insert(state.clone(), node);
// }

// fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
//     self.0
//         .push(state.clone(), Reverse((N::value(&node), state.clone())));
//     self.1.insert(state, node);
// }
//

// fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
//     self.0.pop().and_then(|(state, _)| {
//         let node = self.1.get(&state)?.clone();
//         Some((state, node))
//     })
// }
//

// fn change(&mut self, state: &S, node: Rc<Node<A, U>>) {
//     if self
//         .1
//         .get(state)
//         .is_none_or(|prev| N::value(prev) > N::value(&node))
//     {
//         self.0
//             .change_priority(state, Reverse((N::value(&node), state.clone())));
//         self.1.insert(state.clone(), node);
//     }
// }
