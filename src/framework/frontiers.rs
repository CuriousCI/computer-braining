use std::{
    cmp::Reverse,
    collections::{BinaryHeap, VecDeque},
    hash::Hash,
    rc::Rc,
};

use crate::framework::{problem::Problem, search::*};

pub struct BFS<T>(VecDeque<T>);

impl<T> Default for BFS<T> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<T> Frontier<T> for BFS<T> {
    fn pop(&mut self) -> Option<T> {
        self.0.pop_front()
    }

    fn insert(&mut self, node: T) {
        self.0.push_back(node);
    }
}

// impl<P: Problem> Frontier<P, ()> for BFS<Rc<Node<P, ()>>> {
//     fn next(&mut self) -> Option<Rc<Node<P, ()>>> {
//         self.0.pop_front()
//     }
//
//     fn insert(&mut self, node: Rc<Node<P, ()>>) {
//         self.0.push_back(node);
//     }
// }

pub struct DFS<T>(Vec<T>);

impl<T> Default for DFS<T> {
    fn default() -> Self {
        Self(Default::default())
    }
}

impl<T> Frontier<T> for DFS<T> {
    fn pop(&mut self) -> Option<T> {
        self.0.pop()
    }

    fn insert(&mut self, node: T) {
        self.0.push(node);
    }
}

// impl<P: Problem> Frontier<P, ()> for DFS<Rc<Node<P, ()>>> {
//     fn next(&mut self) -> Option<Rc<Node<P, ()>>> {
//         self.0.pop()
//     }
//
//     fn insert(&mut self, node: Rc<Node<P, ()>>) {
//         self.0.push(node);
//     }
// }

use crate::framework::search::Priority;

struct Pair<T, V>(T, Reverse<V>);

impl<T, V: Ord> Ord for Pair<T, V> {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.1.cmp(&other.1)
    }
}

impl<T, V: Eq> Eq for Pair<T, V> {}

impl<T, V: PartialOrd> PartialOrd for Pair<T, V> {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        self.1.partial_cmp(&other.1)
    }
}

impl<T, V: PartialEq> PartialEq for Pair<T, V> {
    fn eq(&self, other: &Self) -> bool {
        self.1 == other.1
    }
}

pub struct TreePriorityFrontier<T, V> {
    heap: BinaryHeap<Pair<T, V>>,
}

impl<T, V: Ord> Default for TreePriorityFrontier<T, V> {
    fn default() -> Self {
        Self {
            heap: Default::default(),
        }
    }
}

impl<T: Priority<V>, V: Ord> Frontier<T> for TreePriorityFrontier<T, V> {
    fn pop(&mut self) -> Option<T> {
        self.heap.pop().map(|Pair(t, _)| t)
    }

    fn insert(&mut self, node: T) {
        let priority = Reverse(node.priority());
        self.heap.push(Pair(node, priority))
    }
}

// pub struct TreePriorityFrontier<P: Problem, T, V> {
//     heap: BinaryHeap<Pair<V, Rc<Node<P, T>>>>,
// }
//
// impl<P: Problem, T, V: Ord> Default for TreePriorityFrontier<P, T, V> {
//     fn default() -> Self {
//         Self {
//             heap: Default::default(),
//         }
//     }
// }
//
// impl<P: Problem, T: Priority<V>, V: Ord> Frontier<P, T> for TreePriorityFrontier<P, T, V> {
//     fn next(&mut self) -> Option<Rc<Node<P, T>>> {
//         self.heap.pop().map(|Pair(_, s)| s)
//     }
//
//     fn insert(&mut self, node: Rc<Node<P, T>>) {
//         self.heap.push(Pair(Reverse(node.f.priority()), node))
//     }
// }

// type TreeItem<P: Search> = (Reverse<P::Value>, Rc<Node<P>>);
// where
// P::Value: Ord,
// where
// P::Value: PartialEq,
// std::marker::PhantomData<(S, A, P)>,

// struct TreeItem<P: Problem, T: Priority<V>, V>(Reverse<V>, Rc<Node<P, T>>);
// struct TreeItem<P: Problem, T: Priority<V>, V>(Reverse<V>, Rc<Node<P, T>>);

// TODO: interesting, sealed traits

// struct Item<P: Problem, T, V>(Reverse<V>, Rc<Node<P, T>>);
//
// impl<P: Problem, T, V: Ord> Ord for Item<P, T, V> {
//     fn cmp(&self, other: &Self) -> std::cmp::Ordering {
//         self.0.cmp(&other.0)
//     }
// }
//
// impl<P: Problem, T, V: PartialOrd> Eq for Item<P, T, V> {}
//
// impl<P: Problem, T, V: PartialOrd> PartialOrd for Item<P, T, V> {
//     fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
//         self.0.partial_cmp(&other.0)
//     }
// }
//
// impl<P: Problem, T, V: PartialEq> PartialEq for Item<P, T, V> {
//     fn eq(&self, other: &Self) -> bool {
//         self.0 == other.0
//     }
// }

// std::marker::PhantomData<V>,
// where
//     V: Policy<P::Value>;
// Self(Default::default(), Default::default())
// where
//     P: Search,
//     P::Value: Ord,
//     V: Policy<P::Value>,

// where
//     P: Search,
//     P::Value: Ord + Clone,
//     V: Policy<P::Value>,

// Reverse(V::f(node.cost.clone(), node.heuristic.clone())),

use priority_queue::PriorityQueue;

use super::problem::TransitionModel;

struct HashNode<P: TransitionModel, T>(Rc<Node<P, T>>);

impl<P: TransitionModel, T> Eq for HashNode<P, T> where P::State: Eq {}

impl<P: TransitionModel, T> PartialEq for HashNode<P, T>
where
    P::State: PartialEq,
{
    fn eq(&self, other: &Self) -> bool {
        self.0.state == other.0.state
    }
}

impl<P: TransitionModel, T> Hash for HashNode<P, T>
where
    P::State: Hash,
{
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.0.state.hash(state);
    }
}

// pub struct PriorityFrontier<P: Problem, T, V> {
//     priority_queue: PriorityQueue<HashNode<P, T>, Reverse<V>>, _marker: std::marker::PhantomData<V>,
// }

// where

// P: Problem,
// P::State: Eq + Hash,
// V: Policy<P::Value>,

// P::Value: Ord,
// V: Policy<P::Value>,

// impl<P, T, V> Default for PriorityFrontier<P, T, V>
// where
//     P: Problem,
//     P::State: Eq + Hash,
//     V: Ord,
// {
//     fn default() -> Self {
//         Self {
//             priority_queue: Default::default(),
//             _marker: Default::default(),
//         }
//     }
// }

// Self(Default::default(), Default::default())

// impl<P, T, V> Frontier<P, T> for PriorityFrontier<P, T, V>
// where
//     P: Problem,
//     P::State: Eq + Hash,
//     T: Priority<V>,
//     V: Ord,
// {
//     fn next(&mut self) -> Option<Rc<Node<P, T>>> {
//         self.priority_queue.pop().map(|(HashNode(node), _)| node)
//     }
//
//     fn insert(&mut self, node: Rc<Node<P, T>>) {
//         let priority = Reverse(node.f.priority());
//         self.priority_queue.push(HashNode(node), priority);
//     }
//
//     fn update(&mut self, node: Rc<Node<P, T>>) {
//         let new_priority = Reverse(node.f.priority());
//
//         if self
//             .priority_queue
//             .get(&HashNode(node.clone()))
//             .is_none_or(|(_, prev_priority)| prev_priority > &new_priority)
//         {
//             self.priority_queue
//                 .change_priority(&HashNode(node), new_priority);
//         }
//     }
// }

// pub type GraphUniformCost<P, V> = PriorityFrontier<P, UniformCost<V>, V>;
pub type TreeUniformCost<P, V> = TreePriorityFrontier<Rc<Node<P, UniformCost<V>>>, V>;
pub type TreeUniformCostArena<'a, P, V> =
    TreePriorityFrontier<&'a NodeArena<'a, P, UniformCost<V>>, V>;
// pub type GreedyBestFirst<P> = PriorityFrontier<P, BestFirstPolicy>;
// pub type GraphAStar<P, V> = PriorityFrontier<P, AStar<V>, V>;
pub type TreeAStar<P, V> = TreePriorityFrontier<Rc<Node<P, AStar<V>>>, V>;
pub type TreeAStarArena<'a, P, V> = TreePriorityFrontier<&'a NodeArena<'a, P, AStar<V>>, V>;

// P::Value: Ord + Clone,
// V: Policy<P::Value>,
// let cost = node.cost.clone();
// let heuristic = node.heuristic.clone();

// OLD ---

// pub struct MinCostPolicy;
//
// impl<V> Policy<V> for MinCostPolicy {
//     fn f(g: V, _: V) -> V {
//         g
//     }
// }
//
// pub struct BestFirstPolicy;
//
// impl<V> Policy<V> for BestFirstPolicy {
//     fn f(_: V, h: V) -> V {
//         h
//     }
// }
//
// pub struct AStarPolicy;
//
// impl<V> Policy<V> for AStarPolicy
// where
//     V: Add<Output = V>,
// {
//     fn f(g: V, h: V) -> V {
//         g + h
//     }
// }

// pub type MinCost<P> = PriorityFrontier<P, MinCostPolicy>;
// pub type MinCostTree<P> = TreePriorityFrontier<P, MinCostPolicy>;
// pub type BestFirst<P> = PriorityFrontier<P, BestFirstPolicy>;
// pub type AStar<P> = PriorityFrontier<P, AStarPolicy>;
// pub type AStarTree<P> = TreePriorityFrontier<P, AStarPolicy>;

// OLD ----

// use std::{
//     cmp::Reverse,
//     collections::{BinaryHeap, VecDeque},
//     hash::Hash,
//     ops::Add,
//     rc::Rc,
// };
//
// use crate::{exploration::*, problem::Search};
//
// pub trait Policy<V> {
//     fn f(g: V, h: V) -> V;
// }
//
// pub struct BFS<P: Search>(VecDeque<Rc<Node<P>>>);
//
// impl<P: Search> Default for BFS<P> {
//     fn default() -> Self {
//         Self(Default::default())
//     }
// }
//
// impl<P: Search> Frontier<P> for BFS<P> {
//     fn next(&mut self) -> Option<Rc<Node<P>>> {
//         self.0.pop_front()
//     }
//
//     fn insert(&mut self, node: Rc<Node<P>>) {
//         self.0.push_back(node);
//     }
// }
//
// pub struct DFS<P: Search>(Vec<Rc<Node<P>>>);
//
// impl<P: Search> Default for DFS<P> {
//     fn default() -> Self {
//         Self(Default::default())
//     }
// }
//
// impl<P: Search> Frontier<P> for DFS<P> {
//     fn next(&mut self) -> Option<Rc<Node<P>>> {
//         self.0.pop()
//     }
//
//     fn insert(&mut self, node: Rc<Node<P>>) {
//         self.0.push(node);
//     }
// }
//
// // type TreeItem<P: Search> = (Reverse<P::Value>, Rc<Node<P>>);
// struct TreeItem<P: Search>(Reverse<P::Value>, Rc<Node<P>>);
//
// impl<P: Search> Ord for TreeItem<P>
// where
//     P::Value: Ord,
// {
//     fn cmp(&self, other: &Self) -> std::cmp::Ordering {
//         self.0.cmp(&other.0)
//     }
// }
//
// impl<P: Search> Eq for TreeItem<P> where P::Value: Eq {}
//
// impl<P: Search> PartialOrd for TreeItem<P>
// where
//     P::Value: PartialOrd,
// {
//     fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
//         self.0.partial_cmp(&other.0)
//     }
// }
//
// impl<P: Search> PartialEq for TreeItem<P>
// where
//     P::Value: PartialEq,
// {
//     fn eq(&self, other: &Self) -> bool {
//         // true
//         self.0 == other.0
//     }
// }
//
// // std::marker::PhantomData<(S, A, P)>,
// pub struct TreePriorityFrontier<P: Search, V>(BinaryHeap<TreeItem<P>>, std::marker::PhantomData<V>)
// where
//     V: Policy<P::Value>;
//
// impl<P, V> Default for TreePriorityFrontier<P, V>
// where
//     P: Search,
//     P::Value: Ord,
//     V: Policy<P::Value>,
// {
//     fn default() -> Self {
//         Self(Default::default(), Default::default())
//     }
// }
//
// impl<P, V> Frontier<P> for TreePriorityFrontier<P, V>
// where
//     P: Search,
//     P::Value: Ord + Clone,
//     V: Policy<P::Value>,
// {
//     fn next(&mut self) -> Option<Rc<Node<P>>> {
//         self.0.pop().map(|TreeItem(_, s)| s)
//     }
//
//     fn insert(&mut self, node: Rc<Node<P>>) {
//         self.0.push(TreeItem(
//             Reverse(V::f(node.cost.clone(), node.heuristic.clone())),
//             node,
//         ))
//     }
// }
//
// use priority_queue::PriorityQueue;
//
// struct PriorityNode<P: Search>(Rc<Node<P>>);
//
// impl<P: Search> PartialEq for PriorityNode<P>
// where
//     P::State: Eq,
// {
//     fn eq(&self, other: &Self) -> bool {
//         self.0.state == other.0.state
//     }
// }
//
// impl<P: Search> Eq for PriorityNode<P> where P::State: Eq {}
//
// impl<P: Search> Hash for PriorityNode<P>
// where
//     P::State: Hash,
// {
//     fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
//         self.0.state.hash(state);
//     }
// }
//
// pub struct PriorityFrontier<P, V>(
//     PriorityQueue<PriorityNode<P>, Reverse<P::Value>>,
//     std::marker::PhantomData<V>,
// )
// where
//     P: Search,
//     P::State: Eq + Hash,
//     V: Policy<P::Value>;
//
// impl<P, V> Default for PriorityFrontier<P, V>
// where
//     P: Search,
//     P::State: Eq + Hash,
//     P::Value: Ord,
//     V: Policy<P::Value>,
// {
//     fn default() -> Self {
//         Self(Default::default(), Default::default())
//     }
// }
//
// impl<P, V> Frontier<P> for PriorityFrontier<P, V>
// where
//     P: Search,
//     P::State: Eq + Hash,
//     P::Value: Ord + Clone,
//     V: Policy<P::Value>,
// {
//     fn next(&mut self) -> Option<Rc<Node<P>>> {
//         self.0.pop().map(|(PriorityNode(node), _)| node)
//     }
//
//     fn insert(&mut self, node: Rc<Node<P>>) {
//         let cost = node.cost.clone();
//         let heuristic = node.heuristic.clone();
//
//         self.0
//             .push(PriorityNode(node), Reverse(V::f(cost, heuristic)));
//     }
//
//     fn update(&mut self, node: Rc<Node<P>>) {
//         let new_priority = Reverse(V::f(node.cost.clone(), node.heuristic.clone()));
//         if self
//             .0
//             .get(&PriorityNode(node.clone()))
//             .is_none_or(|(_, prev_priority)| prev_priority > &new_priority)
//         {
//             self.0.change_priority(&PriorityNode(node), new_priority);
//         }
//     }
// }
//
// pub struct MinCostPolicy;
//
// impl<V> Policy<V> for MinCostPolicy {
//     fn f(g: V, _: V) -> V {
//         g
//     }
// }
//
// pub struct BestFirstPolicy;
//
// impl<V> Policy<V> for BestFirstPolicy {
//     fn f(_: V, h: V) -> V {
//         h
//     }
// }
//
// pub struct AStarPolicy;
//
// impl<V> Policy<V> for AStarPolicy
// where
//     V: Add<Output = V>,
// {
//     fn f(g: V, h: V) -> V {
//         g + h
//     }
// }
//
// pub type MinCost<P> = PriorityFrontier<P, MinCostPolicy>;
// pub type MinCostTree<P> = TreePriorityFrontier<P, MinCostPolicy>;
// pub type BestFirst<P> = PriorityFrontier<P, BestFirstPolicy>;
// pub type AStar<P> = PriorityFrontier<P, AStarPolicy>;
// pub type AStarTree<P> = TreePriorityFrontier<P, AStarPolicy>;
//
// // fn next(&mut self) -> Option<(usize, usize)> {
// //     self.0.pop().map(|(_, s)| (s, s))
// // }
// //
// // fn insert(&mut self, state: usize, node: usize, nodes: &[Node<S, A, H>]) {
// //     self.0.push((N::value(&nodes[node]), state))
// // }
// // PriorityQueue<usize, Reverse<V>>,
// // Vec<usize>,
// // HashMap<S, Rc<Node<S, A, V>>>,
// // Self(Default::default(), Default::default(), Default::default())
//
// // self.0.pop().map(|(state, _)| (state, self.1[state]))
// // todo!()
//
// // fn next(&mut self) -> Option<(usize, usize)> {
// //     self.0.pop().map(|(state, _)| (state, self.1[state]))
// // }
//
// // fn insert(&mut self, state: usize, node: usize, nodes: &[Node<S, A, V>]) {
// //     self.0.push(state, Reverse(P::value(&nodes[node])));
// //     self.1.push(node);
// // }
// //
// // fn update(&mut self, state: &usize, node: usize, nodes: &[Node<S, A, V>]) {
// //     if self
// //         .1
// //         .get(*state)
// //         .is_none_or(|&prev| P::value(&nodes[prev]) > P::value(&nodes[node]))
// //     {
// //         self.0
// //             .change_priority(state, Reverse(P::value(&nodes[node])));
// //
// //         self.1.insert(*state, node);
// //     }
// // }
// // let node = self.1[state];
// // let node = self.1.get(&state)?;
// // Some((state, *node))
// // self.1.insert(state, node);
//
// //
// // impl<A, U> FromNode<A, U> for MinCostPolicy
// // where
// //     U: Clone,
// // {
// //     fn value(node: &Node<A, U>) -> U {
// //         node.cost.clone()
// //     }
// // }
// //
// // pub struct BestFirstPolicy;
// //
// // impl<A, U> FromNode<A, U> for BestFirstPolicy
// // where
// //     U: Clone,
// // {
// //     fn value(node: &Node<A, U>) -> U {
// //         node.heuristic.clone()
// //     }
// // }
// //
// // pub struct AStarPolicy;
// //
// // impl<A, U> FromNode<A, U> for AStarPolicy
// // where
// //     U: Clone + Add<Output = U>,
// // {
// //     fn value(node: &Node<A, U>) -> U {
// //         node.cost.clone() + node.heuristic.clone()
// //     }
// // }
//
// // impl Default for BFS {
// //     fn default() -> Self {
// //         Self(Default::default())
// //     }
// // }
//
// // impl Default for DFS {
// //     fn default() -> Self {
// //         Self(Default::default())
// //     }
// // }
//
// // Reverse((N::value(&nodes[node]), state.clone())),
// // self.0
// //     .change_priority(state, Reverse((N::value(&nodes[node]), state.clone())));
//
// // hash::Hash,
//
// // impl<S> Default for BFS {
// //     fn default() -> Self {
// //         Self(Default::default())
// //     }
// // }
//
// // pub struct DFS<S>(Vec<(S, usize)>);
// //
// // impl<S> Default for DFS<S> {
// //     fn default() -> Self {
// //         Self(Default::default())
// //     }
// // }
// //
// // impl<S, S, A, H> Frontier<S, S, A, H> for DFS<S> {
// //     fn next(&mut self) -> Option<(S, usize)> {
// //         self.0.pop()
// //     }
// //
// //     fn insert(&mut self, state: S, node: usize, _nodes: &[Node<S, A, H>]) {
// //         self.0.push((state, node));
// //     }
// // }
// // impl<S> Default for DFS<S> {
// //     fn default() -> Self {
// //         Self(Default::default())
// //     }
// // }
// // PriorityQueue<S, Reverse<(H, S)>>,
// // S: Ord + Hash,
// // S: Ord + Hash + Clone,
// // S: Hash + Ord + Clone,
//
// // pub struct BFS<S, A, U>(VecDeque<(S, Rc<Node<A, U>>)>);
// // fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
// //     self.0.pop_front()
// // }
// //
// // fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
// //     self.0.push_back((state, node));
// // }
//
// // pub struct DFS<S, A, U>(Vec<(S, Rc<Node<A, U>>)>);
// // fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
// //     self.0.pop()
// // }
// //
// // fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
// //     self.0.push((state, node));
// // }
//
// // pub struct PriorityFrontier<S, A, N, H>(
// //     PriorityQueue<S, Reverse<(H, S)>>,
// //     HashMap<S, Rc<Node<S, A, H>>>,
// //     std::marker::PhantomData<N>,
// // )
// // where
// //     S: Ord + Hash,
// //     N: Value<H>;
//
// // if self
// //     .1
// //     .get(state)
// //     .is_none_or(|prev| N::value(prev) > N::value(&node))
// // {
// //     self.0
// //         .change_priority(state, Reverse((N::value(&node), state.clone())));
// //     self.1.insert(state.clone(), node);
// // }
//
// // fn insert(&mut self, state: S, node: Rc<Node<A, U>>) {
// //     self.0
// //         .push(state.clone(), Reverse((N::value(&node), state.clone())));
// //     self.1.insert(state, node);
// // }
// //
//
// // fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)> {
// //     self.0.pop().and_then(|(state, _)| {
// //         let node = self.1.get(&state)?.clone();
// //         Some((state, node))
// //     })
// // }
// //
//
// // fn change(&mut self, state: &S, node: Rc<Node<A, U>>) {
// //     if self
// //         .1
// //         .get(state)
// //         .is_none_or(|prev| N::value(prev) > N::value(&node))
// //     {
// //         self.0
// //             .change_priority(state, Reverse((N::value(&node), state.clone())));
// //         self.1.insert(state.clone(), node);
// //     }
// // }
//
// // fmt::Display,
// // hash::Hash,, HashMap
// // #[derive(Default)]
// // pub struct BFS(VecDeque<(usize, usize)>);
// // todo!()
// // fn next(&mut self) -> Option<(usize, usize)> {
// //     self.0.pop_front()
// // }
// //
// // fn insert(&mut self, state: usize, node: usize, _info: &[Node<S, A, H>]) {
// //     self.0.push_back((state, node));
// // }
//
// // #[derive(Default)]
// // todo!()
// // fn next(&mut self) -> Option<(usize, usize)> {
// //     self.0.pop()
// // }
// //
// // fn insert(&mut self, state: usize, node: usize, _info: &[Node<S, A, H>]) {
// //     self.0.push((state, node));
// // }
//
// // #[derive(Default)]
// // pub struct DFS(Vec<(usize, usize)>);
// //
// // impl<S, A, H> Frontier<S, A, H> for DFS {
// //     fn next(&mut self) -> Option<(usize, usize)> {
// //         self.0.pop()
// //     }
// //
// //     fn insert(&mut self, state: usize, node: usize, _info: &[Node<S, A, H>]) {
// //         self.0.push((state, node));
// //     }
// // }
//
// // let new_priority = Reverse(P::f(node.cost.clone(), node.heuristic.clone()));
// // let new_node = PriorityNode(node);
// //
// // match self.0.get(&new_node) {
// //     Some((_, prev_priority)) => {
// //         if prev_priority > &new_priority {
// //             self.0.change_priority(&new_node, new_priority);
// //         }
// //     }
// //     None => {
// //         self.0.push(new_node, new_priority);
// //     }
// // }
//
// // if self
// //     .0
// //     .get(&PriorityNode(node.clone()))
// //     .is_none_or(|(_, prev_priority)| prev_priority > &new_priority)
// // {
// //     self.0.change_priority(&PriorityNode(node), new_priority);
// // }
