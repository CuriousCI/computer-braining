use std::{
    collections::{HashSet, VecDeque},
    hash::Hash,
    ops::{Add, Deref},
    rc::Rc,
};

use crate::problem::{Goal, Search};

pub struct Node<P>
where
    P: Search,
{
    prev: Option<(Rc<Self>, P::Action)>,
    pub state: P::State,
    pub cost: P::Value,
    pub heuristic: P::Value,
}

// pub struct Node<S, A, V> {
//     prev: Option<(Rc<Self>, A)>,
//     pub state: S,
//     pub cost: V,
//     pub heuristic: V,
// }

impl<P: Search> Eq for Node<P> {}

impl<P: Search> PartialEq for Node<P> {
    fn eq(&self, _other: &Self) -> bool {
        true
    }
}

impl<P: Search> PartialOrd for Node<P> {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl<P: Search> Ord for Node<P> {
    fn cmp(&self, _other: &Self) -> std::cmp::Ordering {
        std::cmp::Ordering::Equal
    }
}

pub trait Frontier<S, A, V>: Default {
    fn next(&mut self) -> Option<Rc<Node<S, A, V>>>;
    fn insert(&mut self, node: Rc<Node<S, A, V>>);
    fn update(&mut self, _node: Rc<Node<S, A, V>>) {}
}

// pub struct Agent<S, A, P, V>
// where
//     P: Exploration<V, State = S, Action = A>,
// {
//     plan: Option<VecDeque<A>>,
//     problem: P,
//     _marker: std::marker::PhantomData<V>,
// }
// _marker: std::marker::PhantomData<V>,

// impl<S, A, P, V> Deref for Agent<S, A, P, V>
// where
//     P: Exploration<V, State = S, Action = A>,
// {
//     type Target = P;
//
//     fn deref(&self) -> &Self::Target {
//         &self.problem
//     }
// }

pub struct Agent<P>
where
    P: Search,
{
    plan: Option<VecDeque<P::Action>>,
    problem: P,
}

impl<P> Deref for Agent<P>
where
    P: Search,
{
    type Target = P;

    fn deref(&self) -> &Self::Target {
        &self.problem
    }
}

impl<P> Agent<P>
where
    P: Search,
{
    pub fn new(problem: P) -> Self {
        Self {
            plan: None,
            problem,
        }
    }
}
// _marker: Default::default(),

// impl<S, A, P, V> Agent<S, A, P, V>
// where
//     P: Exploration<V, State = S, Action = A>,
// {
//     pub fn new(problem: P) -> Self {
//         Self {
//             plan: None,
//             problem,
//             _marker: Default::default(),
//         }
//     }
// }

// impl<S, A, P, V> Agent<S, A, P, V>
// S: Eq + Hash + Clone,
// A: Clone,
// P: Exploration<V, State = S, Action = A> + Goal,

impl<P> Agent<P>
where
    P::State: Eq + Hash + Clone,
    P::Action: Clone,
    P::Value: Default + Clone + Add<Output = P::Value>,
    P: Search + Goal,
{
    pub fn function<Q, F>(&mut self, perception: Q) -> Option<P::Action>
    where
        Q: TryInto<P::State>,
        F: Frontier<P::State, P::Action, P::Value>,
    {
        if self.plan.is_none() {
            self.plan = self.search::<F>(perception.try_into().ok()?);
        };

        self.plan.as_mut()?.pop_front()
    }

    fn search<F>(&self, state: P::State) -> Option<VecDeque<P::Action>>
    where
        F: Frontier<P::State, P::Action, P::Value>,
    {
        let mut frontier = F::default();
        let mut explored = HashSet::new();
        let mut in_frontier = HashSet::new();

        in_frontier.insert(state.clone());
        frontier.insert(
            Node {
                prev: None,
                cost: Default::default(),
                heuristic: self.heuristic(&state),
                state,
            }
            .into(),
        );

        while let Some(node) = frontier.next() {
            if self.is_goal(&node.state) {
                let mut plan = VecDeque::new();
                let mut node = node;
                while let Some((prev, action)) = node.prev.clone() {
                    plan.push_front(action);
                    node = prev;
                }

                return Some(plan);
            }

            explored.insert(node.state.clone());
            in_frontier.remove(&node.state);

            for (action, cost) in self.expand(&node.state) {
                let state = self.new_state(&node.state, &action);

                if !explored.contains(&state) {
                    let is_in_frontier = in_frontier.contains(&state);

                    let node = Rc::new(Node {
                        prev: Some((node.clone(), action)),
                        cost: node.cost.clone() + cost,
                        heuristic: self.heuristic(&state),
                        state,
                    });

                    if is_in_frontier {
                        frontier.update(node);
                    } else {
                        frontier.insert(node);
                    }
                }
            }
        }

        None
    }
}

// let prev = Some((action, node));
// let g = info[node].g.clone() + cost;
// match state_to_id.get(&state) {
//     Some(state) => {
//         let h = self.heuristic(&states[*state]);
//         info.push(Node {
//             prev,
//             cost: g,
//             heuristic: h,
//         });
//
//         if !explored[*state] {
//             frontier.update(state, info.len() - 1, &info);
//         }
//     }
//     None => {
//         states.push(state);
//         state_to_id.insert(states.last()?.clone(), states.len() - 1);
//
//         let h = self.heuristic(states.last()?);
//         info.push(Node {
//             prev,
//             cost: g,
//             heuristic: h,
//         });
//
//         explored.push(false);
//         frontier.insert(states.len() - 1, info.len() - 1, &info);
//     }
// };

// explored.set(state, true);

// let mut info = vec![];
// let mut state_to_id = HashMap::new();
// let mut states = vec![];
// let mut explored = bitvec![];
// info.push(Node {
//     prev: None,
//     heuristic: self.heuristic(&state),
//     cost: Default::default(),
// });
//
// states.push(state.clone());
// state_to_id.insert(state, states.len() - 1);
// explored.push(false);
// frontier.insert(states.len() - 1, info.len() - 1, &info);
// let mut iterations = 0;
// iterations += 1;
// println!("iterations: {iterations}");

// impl<S, A, P, V> Agent<S, A, P, V>

// impl<S, A, P, V> Agent<P, V>
impl<P> Agent<P>
where
    P::Action: Clone,
    P::Value: Default + Clone + Add<Output = P::Value>,
    P: Search + Goal,
{
    pub fn function_on_tree<Q, F>(&mut self, perception: Q) -> Option<P::Action>
    where
        Q: TryInto<P::State>,
        F: Frontier<P::State, P::Action, P::Value>,
    {
        if self.plan.is_none() {
            self.plan = self.search_on_tree::<F>(perception.try_into().ok()?);
        };

        self.plan.as_mut()?.pop_front()
    }

    fn search_on_tree<F>(&self, state: P::State) -> Option<VecDeque<P::Action>>
    where
        F: Frontier<P::State, P::Action, P::Value>,
    {
        let mut frontier = F::default();
        frontier.insert(
            Node {
                prev: None,
                cost: Default::default(),
                heuristic: self.heuristic(&state),
                state,
            }
            .into(),
        );

        while let Some(node) = frontier.next() {
            if self.is_goal(&node.state) {
                let mut plan = VecDeque::new();
                let mut node = node;
                while let Some((prev, action)) = &node.prev {
                    plan.push_front(action.clone());
                    node = prev.clone();
                }

                return Some(plan);
            }

            for (action, cost) in self.expand(&node.state) {
                let state = self.new_state(&node.state, &action);
                frontier.insert(
                    Node {
                        prev: Some((node.clone(), action)),
                        cost: node.cost.clone() + cost,
                        heuristic: self.heuristic(&state),
                        state,
                    }
                    .into(),
                );
            }
        }

        None
    }
}

// IntoIterator for node, on the actions
// and just return the node IntoIterator

// prev: Some((action, node)),
// g: info[node].g.clone() + cost,
// // prev: Some((action, node)),
// g: info[node].g.clone() + cost,
// let mut nodes = vec![];
// let mut states = vec![];
// nodes.push(Node {
//     prev: None,
//     heuristic: self.heuristic(&state),
//     cost: Default::default(),
// });
// states.push(state);
// frontier.insert(states.len() - 1, nodes.len() - 1, &nodes);

// nodes.push(Node {
//     prev: Some((action, node)),
//     cost: nodes[node].g.clone() + cost,
//     heuristic: self.heuristic(&state),
// });
// states.push(state);
// frontier.insert(states.len() - 1, nodes.len() - 1, &nodes);

// fn tree_search<F>(&self, state: S) -> Option<VecDeque<A>>
// where
//     F: Frontier<S, A, V>,
// {
//     let mut nodes = vec![];
//     let mut states = vec![];
//     let mut frontier = F::default();
//
//     nodes.push(Node {
//         prev: None,
//         heuristic: self.heuristic(&state),
//         cost: Default::default(),
//     });
//     states.push(state);
//     frontier.insert(states.len() - 1, nodes.len() - 1, &nodes);
//
//     while let Some((state, node)) = frontier.next() {
//         if self.is_goal(&states[state]) {
//             let mut plan = VecDeque::new();
//             let mut node = node;
//             while let Some((a, prev)) = nodes[node].prev.clone() {
//                 plan.push_front(a);
//                 node = prev;
//             }
//             return Some(plan);
//         }
//
//         for (action, cost) in self.expand(&states[state].clone()) {
//             let state = self.new_state(&states[state], &action);
//
//             nodes.push(Node {
//                 prev: Some((action, node)),
//                 cost: nodes[node].g.clone() + cost,
//                 heuristic: self.heuristic(&state),
//             });
//             states.push(state);
//             frontier.insert(states.len() - 1, nodes.len() - 1, &nodes);
//         }
//     }
//
//     None
// }

// let mut iterations = 0;
//     iterations += 1;
//         println!("iterations: {iterations}");

// let mut state_to_id = HashMap::new();

// let mut explored = bitvec![];
// let mut explored = vec![];

// state_to_id.insert(state, id_to_state.len() - 1);
// explored.push(false);

// explored.set(state, true);
// explored[state] = true;

// match state_to_id.get(&state) {
//     Some(state) => {
//         info.push(Info {
//             prev: Some((action, node)),
//             g: info[node].g.clone() + cost,
//             h: self.problem.heuristic(&id_to_state[*state]),
//         });
//
//         if !explored[*state as usize] {
//             frontier.change(state, info.len() - 1, &info);
//         }
//     }
//     None => {
// state_to_id.insert(id_to_state.last()?.clone(), id_to_state.len() - 1);

// explored.push(false);
//     }
// };

// type Atom = usize;

// pub struct Node<A, H>(Atom, Info<A, H>);

// impl<A, H> PartialEq for Node<A, H> {
//     fn eq(&self, other: &Self) -> bool {
//         self.0 == other.0
//     }
// }
//
// impl<A, H> Eq for Node<A, H> {}
//
// impl<A, U> Hash for Node<A, U> {
//     fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
//         self.0.hash(state);
//     }
// }

// impl<A, H> Default for Node<A, H> {
//     fn default() -> Self {
//         Self(Default::default(), Default::default())
//     }
// }

// fn x<A, H>() {
//     let test: PriorityQueue<Node<A, H>, usize> = PriorityQueue::new();
// }

// fn next(&mut self) -> Option<Node<A, H>>;
// fn insert(&mut self, node: Node<A, H>, info: &Info<A, H>);
// fn change(&mut self, _: &usize, _: usize, _: &[Info<A, H>]) {}

// fn next(&mut self) -> Option<(S, usize)>;
// fn insert(&mut self, state: S, node: usize, info: &[Info<A, H>]);
// fn change(&mut self, _: &S, _: usize, _: &[Info<A, H>]) {}

// state: Option<S>,

// state: None,

// let state = perception.try_into().ok();
// self.state = perception.try_into().ok();

// TODO: btreeset / bitmap
// let mut explored = HashSet::new();
// let mut in_frontier = HashSet::new();
// Nobistar, CardioAspirin, Triatec
// let mut pool: HashMap<S, usize> = HashMap::new();
// let mut info: Vec<Info<A, H>> = vec![];
// let mut states: Vec<S> = vec![];

// prev: None,
// g: Default::default(),

// states.push(self.state.clone()?);
// pool.insert(states.last().unwrap().clone(), states.len() - 1);
// info.push(Info {
//     prev: None,
//     h: self.problem.heuristic(states.last()?),
//     g: Default::default(),
// });
// explored.push(false);
// frontier.insert(states.len() - 1, info.len() - 1, &info);

// if !explored[*state] {

// if !explored.contains(&state) {
//     info.push(Info {
//         prev: Some((action, node)),
//         g: info[node].g.clone() + cost,
//         h: self.problem.heuristic(&state),
//     });
//
//     if !to_explore.contains(&state) {
//         frontier.insert(state.clone(), info.len() - 1, &info);
//         to_explore.insert(state);
//     } else {
//         frontier.change(&state, info.len() - 1, &info);
//     }
// }

// let mut explored = HashSet::new();
// let mut to_explore = HashSet::new();
// explored.push(false);

// frontier.insert(state.clone(), info.len() - 1, &info);
// to_explore.insert(state);
// to_explore.remove(&state);
// explored[state] = true;
// explored.insert(state.clone());

// match pool.get(&state) {
//     Some(state) => {
//         info.push(Info {
//             prev: Some((action, node)),
//             g: info[node].g.clone() + cost,
//             h: self.problem.heuristic(&states[*state]),
//         });
//
//         if !explored[*state] {
//             frontier.change(state, info.len() - 1, &info);
//         }
//     }
//     None => {
//         states.push(state);
//         pool.insert(states.last()?.clone(), states.len() - 1);
//         info.push(Info {
//             prev: Some((action, node)),
//             g: info[node].g.clone() + cost,
//             h: self.problem.heuristic(states.last()?),
//         });
//         explored.push(false);
//         frontier.insert(states.len() - 1, info.len() - 1, &info);
//     }
// };

// explored[state] = true;
// explored.insert(state);

// h: self.problem.heuristic(&self.state.clone()?),

// let mut states: Vec<S> = vec![];
// h: self.problem.heuristic(states.last()?),

// states.push(self.state.clone()?);

// frontier.insert(states.len() - 1, nodes.len() - 1, &nodes);
// frontier.insert(0, 0, &info);
// println!("{:?}", states.len());

// if !explored.contains(state) {
//     frontier.change(state, info.len() - 1, &info);
// }

// explored.insert(states[state]);
// in_frontier.remove(&state);
// if self.problem.is_goal(&states[state]) {

// states.len() - 1;
// if !explored.contains(&new_state) {
//     frontier.insert(new_state, new_state, &info);
// }

// info[new_state] = Info {
//     prev: Some((action, node)),
//     g: info[node].g.clone() + cost,
//     h: self.problem.heuristic(states.last()?),
// };

// if !explored.contains(&state) {
//     states.push(state);
//     let new_state = states.len() - 1;
//
//     info.push(Info {
//         prev: Some((action, node)),
//         g: info[node].g.clone() + cost,
//         h: self.problem.heuristic(states.last()?),
//     });
//
//     if !in_frontier.contains(&new_state) {
//         frontier.insert(new_state, info.len() - 1, &info);
//         in_frontier.insert(new_state);
//     } else {
//         frontier.change(&new_state, info.len() - 1, &info);
//     }
// }

// pub trait Frontier<S, A, H>: Default {
//     fn next(&mut self) -> Option<(S, usize)>;
//     fn insert(&mut self, state: S, node: usize, nodes: &[Node<A, H>]);
//     fn change(&mut self, _: &S, _: usize, _: &[Node<A, H>]) {}
// }

// let arena = Bump::new();
// let state = arena.alloc(self.state.clone()?);
// frontier.insert(state.clone(), nodes.len() - 1, &nodes);

// let state =
// let state = arena.alloc(state);
// let new_state = arena.alloc(self.problem.new_state(&states[state], &action));

// parent: Option<(A, Rc<Node<A, H>>)>,
// depth: usize,
// pub struct IterativeNode<A, H> {
//     node: Node<A, H>,
//     depth: usize,
// }

// frontier.insert(new_state.clone(), new_node);
// frontier.change(new_state, new_node);

// prev: None,
// parent: Some((action, node.clone())),
// depth: node.depth + 1,

// let new_node = Rc::new(Node {
//     prev: None,
//     // parent: Some((action, node.clone())),
//     // depth: node.depth + 1,
//     g: node.g.clone() + cost,
//     h: self.problem.heuristic(new_state),
// });

// Rc::new(Node {
//     h: self.problem.heuristic(state),
//     prev: None,
//     // depth: 0,
//     g: Default::default(),
// }),

// self.plan = self.search::<F>(None);

// if let Some(depth) = depth {
// if node.depth >= depth {
//     continue;
// }
// }

// pub fn iterative_function<Q, F>(&mut self, perception: Q) -> Option<A>
// where
//     Q: TryInto<S>,
//     F: Frontier<S, A, H>,
// {
//     if self.plan.is_none() {
//         self.state = perception.try_into().ok();
//         let mut depth = 1;
//         while self.plan.is_none() {
//             self.plan = self.search::<F>(Some(depth));
//             depth += 1;
//         }
//     };
//
//     self.plan.as_mut()?.pop_front()
// }

// fn search<F>(&self, depth: Option<usize>) -> Option<VecDeque<A>>

//let state = self.state.clone()?;
//let new_state = self.problem.new_state(&state, &action);
//states.push(new_state);
//let new_state = states.last().unwrap();
//states.push(state);
//let state = states.last().unwrap();

// fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)>;
// fn insert(&mut self, state: S, node: Rc<Node<A, U>>);
// fn change(&mut self, _state: &S, _node: Rc<Node<A, U>>) {}

// pub trait FromNode<S, A, H> {
//     fn value(node: &Node<S, A, H>) -> H;
// }

// #[derive(Eq, PartialEq)]
// pub struct Node2<A, H> {
//     prev: Option<(A, usize)>,
//     pub g: H,
//     pub h: H,
// }
//
// #[derive(Eq, PartialEq)]
// pub struct Node3<S, A, H> {
//     prev: Option<(A, Rc<Node3<S, A, H>>)>,
//     state: Box<S>,
//     pub g: H,
//     pub h: H,
// }
// reference to State
// each state is referred to by a single node
// or each node is referred to by a single

// fn next(&mut self) -> Option<(usize, usize)>;
// fn insert(&mut self, state: usize, node: usize, nodes: &[Node<A, H>]);
// fn update(&mut self, _state: &usize, _node: usize, _nodes: &[Node<A, H>]) {}

// just take nodes, and use node state as key? Hmmm

// fn next(&mut self) -> Option<(usize, usize)>;
// fn insert(&mut self, state: usize, node: usize, nodes: &[Node<A, H>]);
// fn update(&mut self, _state: &usize, _node: usize, _nodes: &[Node<A, H>]) {}
// use bitvec::prelude::*;
// #[derive(Eq, PartialEq)]
// prev
// from
// action
// state
// prev

// shall the node take a problem? Shall a node be problem specific, with heuristic distinction
