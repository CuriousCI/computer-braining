use std::{
    cmp::Reverse,
    collections::{BinaryHeap, VecDeque},
};

use bumpalo::Bump;

use crate::framework::problem::{GoalBased, Problem, Utility};

pub trait Frontier<T>: Default {
    fn pop(&mut self) -> Option<T>;
    fn insert(&mut self, t: T);
}

pub trait Priority<T> {
    fn priority(&self) -> T;
}

pub struct Node<'a, S, A, C> {
    parent: Option<(&'a Self, A)>,
    pub state: S,
    pub cost: C,
}

// ma scusa un attimo... non posso definire un ordine per C, in cui dico semplicemente
// - "yo bro", fatte du conti, e vedi chi va prima
// quante volte dovrei fare sti conti? O faccio prima a memorizzare?
// secondo me faccio prima a definire la relazione d'ordine, al posto della depth memorizzo la percentuale
// la priorità del nodo è proprio il clone
impl<S, A, C: Clone> Priority<C> for &Node<'_, S, A, C> {
    fn priority(&self) -> C {
        self.cost.clone()
    }
}

// - [x] 'a
// - [x] Problem
// - [ ] Frontier<_> (da specificare)
// - [ ] Cost (da specificare)
pub fn search_on_tree_arena<'a, P, F, C>(
    problem: P,
    state: P::State,
    arena: &'a Bump,
) -> Option<VecDeque<P::Action>>
where
    F: Frontier<&'a Node<'a, P::State, P::Action, C>>,
    C: Default + Clone + std::ops::Add<Output = C> + 'a,
    P: Problem + GoalBased + Utility<C> + 'a,
    P::Action: Clone,
{
    let mut frontier = F::default();

    frontier.insert(arena.alloc(Node {
        parent: None,
        state,
        cost: Default::default(),
    }));

    while let Some(node) = frontier.pop() {
        if problem.goal_test(&node.state) {
            let mut plan = VecDeque::new();
            let mut node = &node;
            while let Some((parent, action)) = &node.parent {
                plan.push_front(action.clone());
                node = parent;
            }

            return Some(plan);
        }

        for action in problem.actions(&node.state) {
            let state = problem.result(&node.state, &action);

            frontier.insert(arena.alloc(Node {
                cost: node.cost.clone() + problem.utility(&node.state, &state, &action),
                parent: Some((node, action)),
                state,
            }));
        }
    }

    None
}

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

// Tree è un nome un po' brutto, duplicateless, redundant, unrendudant

// Ref to S?
// Costo si misura in patate, e la priorità in kg

// let node = arena.alloc(Node {
//     parent: None,
//     state,
//     cost: Default::default(),
// });
//
// frontier.insert(node);

// let node = arena.alloc(Node {
//     cost: node.cost.clone() + problem.utility(&node.state, &state, &action),
//     parent: Some((node, action)),
//     state,
// });
//
// frontier.insert(node);
