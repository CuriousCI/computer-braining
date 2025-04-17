use std::{
    cmp::Reverse,
    collections::{BinaryHeap, VecDeque},
    hash::Hash,
    ops::Add,
    rc::Rc,
};

use crate::exploration::*;

pub trait Policy<V> {
    fn f(g: V, h: V) -> V;
}

pub struct BFS<S, A, V>(VecDeque<Rc<Node<S, A, V>>>);

impl<S, A, V> Default for BFS<S, A, V> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<S, A, V> Frontier<S, A, V> for BFS<S, A, V> {
    fn next(&mut self) -> Option<Rc<Node<S, A, V>>> {
        self.0.pop_front()
    }

    fn insert(&mut self, node: Rc<Node<S, A, V>>) {
        self.0.push_back(node);
    }
}

pub struct DFS<S, A, V>(Vec<Rc<Node<S, A, V>>>);

impl<S, A, V> Default for DFS<S, A, V> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<S, A, V> Frontier<S, A, V> for DFS<S, A, V> {
    fn next(&mut self) -> Option<Rc<Node<S, A, V>>> {
        self.0.pop()
    }

    fn insert(&mut self, node: Rc<Node<S, A, V>>) {
        self.0.push(node);
    }
}

type TreeItem<S, A, V> = (Reverse<V>, Rc<Node<S, A, V>>);

pub struct TreePriorityFrontier<S, A, V, P>(
    BinaryHeap<TreeItem<S, A, V>>,
    std::marker::PhantomData<(S, A, P)>,
)
where
    P: Policy<V>;

impl<S, A, V, P> Default for TreePriorityFrontier<S, A, V, P>
where
    V: Ord,
    P: Policy<V>,
{
    fn default() -> Self {
        Self(Default::default(), Default::default())
    }
}

impl<S, A, V, P> Frontier<S, A, V> for TreePriorityFrontier<S, A, V, P>
where
    V: Ord + Clone,
    P: Policy<V>,
{
    fn next(&mut self) -> Option<Rc<Node<S, A, V>>> {
        self.0.pop().map(|(_, s)| s)
    }

    fn insert(&mut self, node: Rc<Node<S, A, V>>) {
        self.0.push((
            Reverse(P::f(node.cost.clone(), node.heuristic.clone())),
            node,
        ))
    }
}

use priority_queue::PriorityQueue;

struct PriorityNode<S, A, V>(Rc<Node<S, A, V>>);

impl<S, A, V> PartialEq for PriorityNode<S, A, V>
where
    S: Eq,
{
    fn eq(&self, other: &Self) -> bool {
        self.0.state == other.0.state
    }
}

impl<S, A, V> Eq for PriorityNode<S, A, V> where S: Eq {}

impl<S, A, V> Hash for PriorityNode<S, A, V>
where
    S: Hash,
{
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.0.state.hash(state);
    }
}

pub struct PriorityFrontier<S, A, V, P>(
    PriorityQueue<PriorityNode<S, A, V>, Reverse<V>>,
    std::marker::PhantomData<P>,
)
where
    S: Eq + Hash,
    P: Policy<V>;

impl<S, A, V, P> Default for PriorityFrontier<S, A, V, P>
where
    S: Eq + Hash,
    V: Ord,
    P: Policy<V>,
{
    fn default() -> Self {
        Self(Default::default(), Default::default())
    }
}

impl<S, A, V, P> Frontier<S, A, V> for PriorityFrontier<S, A, V, P>
where
    S: Eq + Hash,
    V: Ord + Clone,
    P: Policy<V>,
{
    fn next(&mut self) -> Option<Rc<Node<S, A, V>>> {
        self.0.pop().map(|(PriorityNode(node), _)| node)
    }

    fn insert(&mut self, node: Rc<Node<S, A, V>>) {
        let cost = node.cost.clone();
        let heuristic = node.heuristic.clone();

        self.0
            .push(PriorityNode(node), Reverse(P::f(cost, heuristic)));
    }

    fn update(&mut self, node: Rc<Node<S, A, V>>) {
        let new_priority = Reverse(P::f(node.cost.clone(), node.heuristic.clone()));
        if self
            .0
            .get(&PriorityNode(node.clone()))
            .is_none_or(|(_, prev_priority)| prev_priority > &new_priority)
        {
            self.0.change_priority(&PriorityNode(node), new_priority);
        }
    }
}

pub struct MinCostPolicy;

impl<V> Policy<V> for MinCostPolicy {
    fn f(g: V, _: V) -> V {
        g
    }
}

pub struct BestFirstPolicy;

impl<V> Policy<V> for BestFirstPolicy {
    fn f(_: V, h: V) -> V {
        h
    }
}

pub struct AStarPolicy;

impl<V> Policy<V> for AStarPolicy
where
    V: Add<Output = V>,
{
    fn f(g: V, h: V) -> V {
        g + h
    }
}

pub type MinCost<S, A, V> = PriorityFrontier<S, A, V, MinCostPolicy>;
pub type MinCostTree<S, A, V> = TreePriorityFrontier<S, A, V, MinCostPolicy>;
pub type BestFirst<S, A, V> = PriorityFrontier<S, A, BestFirstPolicy, V>;
pub type AStar<S, A, V> = PriorityFrontier<S, A, V, AStarPolicy>;
pub type AStarTree<S, A, V> = TreePriorityFrontier<S, A, V, AStarPolicy>;

// fn next(&mut self) -> Option<(usize, usize)> {
//     self.0.pop().map(|(_, s)| (s, s))
// }
//
// fn insert(&mut self, state: usize, node: usize, nodes: &[Node<S, A, H>]) {
//     self.0.push((N::value(&nodes[node]), state))
// }
// PriorityQueue<usize, Reverse<V>>,
// Vec<usize>,
// HashMap<S, Rc<Node<S, A, V>>>,
// Self(Default::default(), Default::default(), Default::default())

// self.0.pop().map(|(state, _)| (state, self.1[state]))
// todo!()

// fn next(&mut self) -> Option<(usize, usize)> {
//     self.0.pop().map(|(state, _)| (state, self.1[state]))
// }

// fn insert(&mut self, state: usize, node: usize, nodes: &[Node<S, A, V>]) {
//     self.0.push(state, Reverse(P::value(&nodes[node])));
//     self.1.push(node);
// }
//
// fn update(&mut self, state: &usize, node: usize, nodes: &[Node<S, A, V>]) {
//     if self
//         .1
//         .get(*state)
//         .is_none_or(|&prev| P::value(&nodes[prev]) > P::value(&nodes[node]))
//     {
//         self.0
//             .change_priority(state, Reverse(P::value(&nodes[node])));
//
//         self.1.insert(*state, node);
//     }
// }
// let node = self.1[state];
// let node = self.1.get(&state)?;
// Some((state, *node))
// self.1.insert(state, node);

//
// impl<A, U> FromNode<A, U> for MinCostPolicy
// where
//     U: Clone,
// {
//     fn value(node: &Node<A, U>) -> U {
//         node.cost.clone()
//     }
// }
//
// pub struct BestFirstPolicy;
//
// impl<A, U> FromNode<A, U> for BestFirstPolicy
// where
//     U: Clone,
// {
//     fn value(node: &Node<A, U>) -> U {
//         node.heuristic.clone()
//     }
// }
//
// pub struct AStarPolicy;
//
// impl<A, U> FromNode<A, U> for AStarPolicy
// where
//     U: Clone + Add<Output = U>,
// {
//     fn value(node: &Node<A, U>) -> U {
//         node.cost.clone() + node.heuristic.clone()
//     }
// }

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
// impl<S, S, A, H> Frontier<S, S, A, H> for DFS<S> {
//     fn next(&mut self) -> Option<(S, usize)> {
//         self.0.pop()
//     }
//
//     fn insert(&mut self, state: S, node: usize, _nodes: &[Node<S, A, H>]) {
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
//     HashMap<S, Rc<Node<S, A, H>>>,
//     std::marker::PhantomData<N>,
// )
// where
//     S: Ord + Hash,
//     N: Value<H>;

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

// fmt::Display,
// hash::Hash,, HashMap
// #[derive(Default)]
// pub struct BFS(VecDeque<(usize, usize)>);
// todo!()
// fn next(&mut self) -> Option<(usize, usize)> {
//     self.0.pop_front()
// }
//
// fn insert(&mut self, state: usize, node: usize, _info: &[Node<S, A, H>]) {
//     self.0.push_back((state, node));
// }

// #[derive(Default)]
// todo!()
// fn next(&mut self) -> Option<(usize, usize)> {
//     self.0.pop()
// }
//
// fn insert(&mut self, state: usize, node: usize, _info: &[Node<S, A, H>]) {
//     self.0.push((state, node));
// }

// #[derive(Default)]
// pub struct DFS(Vec<(usize, usize)>);
//
// impl<S, A, H> Frontier<S, A, H> for DFS {
//     fn next(&mut self) -> Option<(usize, usize)> {
//         self.0.pop()
//     }
//
//     fn insert(&mut self, state: usize, node: usize, _info: &[Node<S, A, H>]) {
//         self.0.push((state, node));
//     }
// }

// let new_priority = Reverse(P::f(node.cost.clone(), node.heuristic.clone()));
// let new_node = PriorityNode(node);
//
// match self.0.get(&new_node) {
//     Some((_, prev_priority)) => {
//         if prev_priority > &new_priority {
//             self.0.change_priority(&new_node, new_priority);
//         }
//     }
//     None => {
//         self.0.push(new_node, new_priority);
//     }
// }

// if self
//     .0
//     .get(&PriorityNode(node.clone()))
//     .is_none_or(|(_, prev_priority)| prev_priority > &new_priority)
// {
//     self.0.change_priority(&PriorityNode(node), new_priority);
// }
