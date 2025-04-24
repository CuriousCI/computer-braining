pub mod csp;
pub mod frontiers;
pub mod local_search;
pub mod problem;
pub mod search;

// pub trait LocalSearch: Problem {
//     fn result(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;
// }

// use rayon::iter::ParallelIterator;

// pub trait ParallelLocal: Problem {
//     fn result(&self, state: &Self::State) -> impl ParallelIterator<Item = Self::Action>;
// }

// pub trait Policy {
// }

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
// pub trait Policy<V> {
//     fn f(g: V, h: V) -> V;
// }

// un T + una policy?

// T praticamente deve essere tale che ha un
// - T: Add<Output = T>
// - T: Ord (posso ordinarli, e posso sommarli, ed è tutto derivabile)
// A quel punto posso fare dei T di default, tipo
// - T = Cost = MinCost (o UniformCost)
//  - lui prende le info da qualcuno che
//  - dato uno stato e l'azione in cui ci sono arrivato mi da un costo (oppure lo stato da cui ci arrivo?)
// - T = Heuristic = BestFirst = GreedyBestFirst
//  - dato uno stato e l'azione in cui ci sono arrivato mi da un'euristica (o basta solo lo stato in realtà?)
// - T = Cost = Cost + Heuristic = AStar
//  - mi servono entrambe le cose di prima
// Bidirectional search!

// Tutti questi casi hanno bisogno di un problema, ma da cui derivano informazioni diverse
// il costo è di passo
// queste sono informazioni che devo dare alla funzione "search", mi aspetterei una roba tipo
// search<DepthFirst>
// search<BestFirst<Banane>>
// search<AStar<Mele>>

// ora, la vera domanda è: come si appiccano queste con la frontiera?
// beh, la frontiera ha l'informazione sui nodi (Node<P, T>), quindi ha l'informazione su quali di queste è
// stata usata da T
// In più, per la priorityFrontier si può specificare T: Priority

// produce a new state, and basically the costs associated with the state
// costs can be either NONE, a cost in it of itself or a heuristic or both
// maybe I can have multiple heuristic functions

// pub trait Search<T>: Problem {
//     fn child_node(node: Rc<Node<Self, T>>, action: &Self::Action) -> Node<Self, T>;
// }

// pub trait Actions: Problem {
// }

// fn result(&self, state: &Self::State, action: &Self::Action) -> Self::State;

// pub cost: P::Value,
// pub heuristic: P::Value,

// either cost only (min-cost)
// either heuristic only (best-first)
// eirther

// struct Uninformed {
//     cost: usize,
// }
//
// struct Informed {
//     cost: Uninformed,
//     heuristic: usize,
// }

// pub trait Actions: Problem {
// }

// pub trait TransitionModel: Problem {
//     type Action;
//
//     fn result(&self, state: &Self::State, action: &Self::Action) -> Self::State;
// }

// pub trait Search: TransitionModel + Heuristic {
//     fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::Action, Self::Value)>;
// }

// use std::alloc::System;
// use std::collections::HashSet;
// use std::{iter::Copied, rc::Rc};

// some kind of trait that from State + Action -> Node
// how would it interact with the frontier?

// cost based
// uninformed
// informed

// pub trait Heuristic<V>: Problem {
//     fn heuristic(&self, state: &Self::State) -> V;
// }

// pub trait Exploration<V>: Transition + Heuristic<V> {
//     fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::Action, V)>;
// }

// pub struct Node<S, A, V> {
//     prev: Option<(Rc<Self>, A)>,
//     pub state: S,
//     pub cost: V,
//     pub heuristic: V,
// }

// pub trait Frontier<S, A, V>: Default {
//     fn next(&mut self) -> Option<Rc<Node<S, A, V>>>;
//     fn insert(&mut self, node: Rc<Node<S, A, V>>);
//     fn update(&mut self, _node: Rc<Node<S, A, V>>) {}
// }

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

// next position, nah
// direction (maybe? Still hard to check for translations)
// impl Eq for AminoAcid, s.t. two amino acids are equal if they have the same directions, but rotated
// rotation... what does rotation mean in this context?
// can I prevent a duplicating move before doing it?

// } else {
//     vec![(x + 1, y), (x, y + 1)]

// let mut result = vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)];
// if let Some(parent) = amino_acid.prev.as_ref() {
//     if let Some(grandpa) = parent.prev.as_ref() {
//         let (p_x, p_y) = parent.pos;
//         let (g_x, g_y) = grandpa.pos;
//
//         if amino_acid.first_turn {
//             result = vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//         } else {
//             result = match (x - p_x, p_x - g_x, y - p_y, p_y - g_y) {
//                 (1, 1, _, _) => vec![(x + 1, y), (x, y + 1)],
//                 (-1, -1, _, _) => vec![(x - 1, y), (x, y - 1)],
//                 (_, _, 1, 1) => vec![(x, y + 1), (x + 1, y)],
//                 (_, _, -1, -1) => vec![(x, y - 1), (x - 1, y)],
//                 _ => vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)],
//             }
//         }
//     }
// }
//
// result
// #[derive(Clone, Hash, Eq, PartialEq, Ord, PartialOrd)]

// let sol = steepest_descent(&Constraints, [3, 1, 4, 5, 2]);
//
// println!("{:?} - {:?}", sol, Constraints.heuristic(&sol));
// csp::{Assignment, CSP, Constraint, Description},
// use ai::frontiers::{AStar, MinCost};
// use ai::problem_solving_agent::Agent;
// use models::hp_2d_protein_folding::{Alphabet, AminoAcid, Energy, Pos, Protein, Sequence};
// use rand::rng;
// use rand::seq::IndexedRandom;
// use std::{collections::BTreeSet, time::Instant};
// use std::rc::Rc;
// use std::time::Instant;

// cplex optimization studio
// pruning dell'albero di ricerca
// MILP: mixed integer linear programming
// GAC e framework

// let mut description = Description::default();
// description.extend(vec![BTreeSet::from_iter(1..=5); 5]);
// description.extend([
//     Constraint(
//         vec![0, 2],
//         Box::new(|ass| matches!((ass[0], ass[2]), (Some(v0), Some(v2)) if v0 > v2)),
//     ),
//     Constraint(
//         vec![1, 2],
//         Box::new(|ass| matches!((ass[1], ass[2]), (Some(v1), Some(v2)) if v1 <= v2)),
//     ),
//     Constraint(
//         vec![2, 3],
//         Box::new(|ass| matches!((ass[2], ass[3]), (Some(v2), Some(v3)) if v2.pow(2) + v3.pow(2) <= 15)),
//     ),
//     Constraint(
//         vec![4],
//         Box::new(|ass| matches!(ass[4], Some(val) if val >= 3)),
//     ),
//     Constraint(
//         vec![0, 4],
//         Box::new(|ass| matches!((ass[0], ass[4]), (Some(v0), Some(v4)) if v0 + v4 >= 3)),
//     ),
// ]);
//
// let mut csp: CSP = description.into();
//
// let time = Instant::now();
// if !csp.make_node_consistent() {
//     println!("there isn't a solution")
// }
// if !csp.gac_3() {
//     println!("there isn't a solution")
// }
// println!("{:?}", time.elapsed());
//
// let time = Instant::now();
// println!("{:?}", csp.backtracking());
// println!("{:?}", time.elapsed());

// let domains = vec![]

// let domains =

// let n = 4;
// let domain = BTreeSet::from_iter(1..=n);
// let mut n_queens = CSP::new(vec![domain; n]);
//
// for i in 0..n {
//     for j in 0..n {
//         if i != j {
//             n_queens.add_constraint(Box::new(move |ass| match (ass[i], ass[j]) {
//                 (Some(q_i), Some(q_j)) => q_i != q_j,
//                 _ => true,
//             }));
//
//             n_queens.add_constraint(Box::new(move |ass| match (ass[i], ass[j]) {
//                 (Some(q_i), Some(q_j)) => i.abs_diff(j) != q_i.abs_diff(q_j),
//                 _ => true,
//             }));
//         }
//     }
// }
//
// let time = Instant::now();
// println!("{:?}", n_queens.backtracking());
// println!("{:?}", time.elapsed());

// let domain = BTreeSet::from_iter([1, 2, 3, 4, 5, 6, 7]);
//
// let mut example = CSP::new(vec![domain.clone(), domain.clone(), domain.clone()]);
// example.add_constraint(|ass: &Assignment| match (ass[0], ass[1]) {
//     (Some(x_0), Some(x_1)) => x_0 > x_1,
//     _ => true,
// });
//
// example.add_constraint(|ass| match (ass[1], ass[2]) {
//     (Some(x_1), Some(x_2)) => x_1 >= x_2 + 2,
//     _ => true,
// });
//
// example.add_constraint(|ass| match ass[2] {
//     Some(x_2) => x_2 == 2,
//     _ => true,
// });
//
// println!("{:?}", example.backtracking())

// match assignment[var] {
//     Some(val) => {},
//     None => continue;
// }

// for value in

// assignment: Assignment,
// variables: usize,

// pub type Constraint = impl Fn(usize) -> usize;

// pub struct Assignment;
//
// pub trait FromAssignment {
//     fn from_assignment(assignment: &Assignment) -> Self;
// }
//
// pub trait Handler<T> {
//     fn call(self, assignment: Assignment);
// }
//
// impl<F, T> Handler<T> for F
// where
//     F: Fn(T),
//     T: FromAssignment,
// {
//     fn call(self, assignment: Assignment) {
//         (self)(T::from_assignment(&assignment))
//     }
// }
//
// impl<F, T1, T2> Handler<(T1, T2)> for F
// where
//     F: Fn(T1, T2),
//     T1: FromAssignment,
//     T2: FromAssignment,
// {
//     fn call(self, assignment: Assignment) {
//         (self)(
//             T1::from_assignment(&assignment),
//             T2::from_assignment(&assignment),
//         )
//     }
// }
//
// pub fn trigger<T, H>(assignment: Assignment, handler: H)
// where
//     H: Handler<T>,
// {
//     handler.call(assignment);
// }
//
// pub struct CSP {}
//
// impl CSP {
//     pub fn new() -> Self {
//         Self {}
//     }
// }

//let context = Context::new("magic".into(), 33);
//
//trigger(context.clone(), print_id);

// The _"state of the board"_ is known as _"position"_ in chess
// An action corresponds to moving the queen in col i to row j
// Definition of the n-queens problem
// Generates a new state s.t. the queen in column `col` is in row `row`
//
// I tried a solution which in which the position isn't cloned, but it's less efficient. I'll trust Rust on this one.
// This heuristic counts both the number of *direct* attacks and *indirect* attacks. It has
// proven to be more effecting at finding results (it carries more information than just the
// direct attacks)
//impl Local<Reverse<usize>> for NQueens {
// The simplest way to implement the neighbourhood is to allow a queen to move only above or
// below.
//
// I tried allowing movement in all positions, and this happened:
// - with steepest_ascent time went from 50ms to 2s
// - the resulting attacks went from 50 to 0
//
// So allowing more moves takes way more time, but finds way better results.
// By using this idea I tried implementing a "halo region" _(by allowing certain number of
// moves above and below)_.
//
// The halo region balances the quality of the results and the time take (a good enough halo
// region size can be both very fast and effecting at finding a solution)

// Used by parallel_steepest_ascent to parallelize the calculation of the utility
//
// By using parallelization for 1000-queens times went down from 460s to 75s (on my 6 core computer)
// Used to generate the initial state bu iterative improvement algorithms

//}
//.into_iter()

//.into_iter()

//.collect::<Vec<_>>()
//.into_iter()
//.filter(|(x, y)| x >= &0 && y >= &0)

//} else if amino_acid.depth == 2 {
//    vec![]

//if amino_acid.depth == 0 {
//    vec![((0, 1), 0)]
//} else {
//[(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]

// let parent = amino_acid.prev.clone();
// let grandpa = parent.clone().and_then(|parent| parent.prev.clone());

// vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]

// // check if it is straight or angle
// let parent = amino_acid.prev.clone();
// let grandpa = parent.clone().and_then(|parent| parent.prev.clone());
//
// if let Some(parent) = parent {
//     if let Some(grandpa) = grandpa {
//         if parent.pos.1.abs_diff(amino_acid.pos.1)
//             + grandpa.pos.1.abs_diff(parent.pos.1)
//             == 2
//             || parent.pos.0.abs_diff(amino_acid.pos.0)
//                 + grandpa.pos.0.abs_diff(parent.pos.0)
//                 == 2
//         {
//             vec![(x + 1, y), (x, y + 1)]
//         // } else if parent.pos.0.abs_diff(amino_acid.pos.0)
//         //     + grandpa.pos.0.abs_diff(parent.pos.0)
//         //     == 2
//         // {
//         //     vec![(x + 1, y), (x, y + 1)]
//         } else {
//             vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//         }
//     } else {
//         vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//     }
// } else {
// }

// let adj = vec![
//     (1, vec![5, 8, 9, 11]),
//     (2, vec![3, 7, 9, 10, 11]),
//     (3, vec![4, 7, 11]),
//     (4, vec![5, 11]),
//     (5, vec![6, 8]),
//     (6, vec![8]),
//     (7, vec![10]),
//     (8, vec![9]),
//     (9, vec![]),
//     (10, vec![]),
//     (11, vec![]),
// ];
//
// for (i, adj) in adj.clone() {
//     for j in adj {
//         println!(
//             "- $angle.l {{C_({i}, {j}), C_({j}, {i})}}, C_({i}, {j}) = C_({j}, {i}) angle.r$"
//         )
//     }
// }
//
// let mut matrix = [[false; 11]; 11];
//
// for (x, edge) in adj {
//     for y in edge {
//         let (x, y) = (x - 1, y - 1);
//         matrix[x][y] = true;
//         matrix[y][x] = true;
//     }
// }
//
// for i in 0..11 {
//     for j in 0..11 {
//         for k in 0..11 {
//             if matrix[i][j] && matrix[i][k] && matrix[j][k] {
//                 println!(
//                     "- $angle.l {{C_({i}, {j}), C_({i}, {k}), C_({j}, {k})}}, C_({i}, {j}) = C_({i}, {k} => C_({i}, {j}) != C_({j}, {k})) angle.r$"
//                 )
//             }
//         }
//     }
// }
//
// let letters = ["A", "B", "C", "D", "E", "1", "2", "H", "I", "J", "S"];
//
// for (i, l) in letters.iter().enumerate() {
//     println!("{l} = {}", i + 1)
// }
//
// let colors = [
//     [1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1],
//     [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2],
//     [1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1],
//     [1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1],
//     [2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1],
//     [1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//     [2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//     [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//     [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1],
// ];
//
// print!("  ");
// for letter in letters {
//     print!(" {letter} ")
// }
// println!();
// for (i, row) in matrix.into_iter().enumerate() {
//     print!("{}:", letters[i]);
//     for col in row {
//         print!(" {} ", if col { 'X' } else { '-' })
//     }
//     println!();
//     // println!("{:?}", row)
// }
//
// print!("  ");
// for letter in letters {
//     print!(" {letter} ")
// }
// println!();
// for (i, row) in colors.into_iter().enumerate() {
//     print!("{}:", letters[i]);
//     for col in row {
//         print!(" {} ", if col == 1 { ' ' } else { '2' })
//     }
//     println!();
//     // println!("{:?}", row)
// }
//
// // for row in matrix {
// //     println!("{:?}", row);
// // }
// // println!("{:?}", matrix);
//
// return;

//pub fn steepest_descent<P, S, H>(problem: &P, rng: &mut impl Rng) -> Option<S>
//where
//    H: Ord + Copy,
//    P: Local<State = S> + Heuristic<H> + Distribution<S>,
//let mut state = problem.sample(rng);
//let mut utility = problem.heuristic(&state);

// The restart is handled outside of the function
// Get the one with best utility
// No better neighbour was found, state is a local minimum
// Filter just neighbours that have better utility

//pub trait Exploration<H>: Transition + Heuristic<H> + Goal {

//pub trait Local<H>: Transition + Heuristic<H> {
//    fn expand(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;
//}

//pub trait ParallelLocal<H>: Transition + Heuristic<H> {
//    fn expand(&self, state: &Self::State) -> impl ParallelIterator<Item = Self::Action>;
//}

//let node = Rc::new(Node {
//    h: self.problem.heuristic(state),
//    parent: None,
//    depth: 0,
//    g: Default::default(),
//});

// A trait to define problems.
//
// It only requires a transition model.
// Different algorithms may require different ways to generate the initial state, so it's not a part of the contract.
// A trait to define goal-based problems.
// A trait to define utility-based problems
//
// Different algorithms have different interpretations for the utility
// _(eg. genetic algorithms try to maximize the "fitness", exploration algorithms try to minimize the "cost")_.
//
// The generic parameter allows for multiple utility functions for the same problem, to adapt the
// problem definition to multiple algorithms.
// A trait used by exploration algorithms
//
// The utility in state-space exploration is interpreted as the heuristics.
// The expand method returns a `Self::Action` and its actual cost.
// A trait used by iterative improvement algorithms
// Some iterative improvement algorithms might be parallelizable

//if count > 0 {
//    println!("{:?}", count);
//}

//pub type Conformation = Vec<Pos>;

//if p.pos == pos {
//return false;
//}

//for (i, (c_x, c_y)) in amino_acid[..amino_acid.len() - 1].iter().enumerate() {
//    if c_x.abs_diff(pos.0) + c_y.abs_diff(pos.1) == 1 {
//        if let Alphabet::H = self.sequence[i] {
//            count += 1;
//        }
//    }
//}
//
//(pos, 100 - count)

//match conformation.last() {
//Some(&(x, y)) => [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//    .into_iter()
//    .filter(|(x, y)| amino_acid.iter().all(|(c_x, c_y)| c_x != x || c_y != y))
//    .map(|pos| match self.sequence[amino_acid.len()] {
//        Alphabet::P => (pos, 0),
//        Alphabet::H => {
//            let mut count = 0;
//
//            for (i, (c_x, c_y)) in
//                amino_acid[..amino_acid.len() - 1].iter().enumerate()
//            {
//                if c_x.abs_diff(pos.0) + c_y.abs_diff(pos.1) == 1 {
//                    if let Alphabet::H = self.sequence[i] {
//                        count += 1;
//                    }
//                }
//            }
//
//            (pos, 100 - count)
//        }
//    })
//.collect(),
//None => vec![((0, 0), 0)],
//}
//.into_iter()

//impl Goal for ProteinFolding {
//    fn is_goal(&self, conformation: &Self::State) -> bool {
//        conformation.len() == self.sequence.len()
//    }
//}

//impl Exploration<Energy> for ProteinFolding {
//    fn expand(&self, conformation: &Self::State) -> impl Iterator<Item = (Self::Action, Energy)> {
//        match conformation.last() {
//            Some(&(x, y)) => [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//                .into_iter()
//                .filter(|(x, y)| conformation.iter().all(|(c_x, c_y)| c_x != x || c_y != y))
//                .map(|pos| match self.sequence[conformation.len()] {
//                    Alphabet::P => (pos, 0),
//                    Alphabet::H => {
//                        let mut count = 0;
//
//                        for (i, (c_x, c_y)) in
//                            conformation[..conformation.len() - 1].iter().enumerate()
//                        {
//                            if c_x.abs_diff(pos.0) + c_y.abs_diff(pos.1) == 1 {
//                                if let Alphabet::H = self.sequence[i] {
//                                    count += 1;
//                                }
//                            }
//                        }
//
//                        (pos, 100 - count)
//                    }
//                })
//                .collect(),
//            None => vec![((0, 0), 0)],
//        }
//        .into_iter()
//    }
//}

//impl TransitionModel for ProteinFolding {
//    type State = Conformation;
//    type Action = Pos;
//
//    fn new_state(&self, conformation: &Self::State, &pos: &Self::Action) -> Self::State {
//        let mut new_conformation = conformation.clone();
//        new_conformation.push(pos);
//        new_conformation
//    }
//}

//#[derive(Default, Clone, PartialEq, Eq, Ord, PartialOrd, Debug)]
//pub struct Energy(Reverse<usize>);
//impl Add for Energy {
//    type Output = Energy;
//
//    fn add(self, rhs: Self) -> Self::Output {
//        Energy(Reverse(self.0.0 + rhs.0.0))
//    }
//}

//Energy(Reverse(0))

//let res = match conformation.last() {
//println!("{:?}", res);
//res.into_iter()

//if conformation.len() > 1 {
//    if let Alphabet::H = self.sequence[conformation.len() - 1] {
//        count -= 1;
//    }
//}

//(pos, Energy(Reverse(count)))
// TODO: almost there
//Alphabet::P => (pos, Energy(Reverse(0))),
//None => vec![((0, 0), Energy(Reverse(0)))],

//let mut contacts = 0;
//
//for (i, (x_i, y_i)) in conformation.iter().enumerate() {
//    for &(x_j, y_j) in conformation.iter().skip(i + 1) {
//        if x_i.abs_diff(x_j) == 1 || y_i.abs_diff(y_j) == 1 {
//            contacts += 1;
//        }
//    }
//}
//
//Energy(Reverse(contacts))
// quanti vicini liberi hanno i punti di tipo H?
//
//let mut free = 0;
//
//for (i, &(x, y)) in conformation.iter().enumerate() {
//    if let Alphabet::H = self.sequence[i] {
//        for (n_x, n_y) in [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)] {
//            if conformation
//                .iter()
//                .all(|&(p_x, p_y)| p_x != n_x || p_y != n_y)
//            {
//                free += 1;
//            }
//        }
//    }
//}
//
//Energy(Reverse(contacts + free))

//let mut dist = 0;
//
//for (x, y) in conformation {
//    dist += x.unsigned_abs() as usize + y.unsigned_abs() as usize;
//}

// hydrophobic amino-acids
// hydrophilic amino-acids (polar)
// length n
//type Energy = Reverse<usize>;
//impl From<Vec> for  {
//    fn from(conformation: Conformation) -> Self {
//        Self { conformation }
//    }
//}

// neighbourhood of a node, so basically add a new node, if available
// when adding the new node, check the neighbourhood (still, would I need an adjency matrix?, how big would it be)
// precalculate bridges when creating new state, the just use the values to calculate the energy

//if conformation[prot_i].0.abs_diff(conformation[prot_j])
// basically, save the list of position for all items in the sequence

// grid [-(n-1), (n-1)]

//.as_ref()
//.map(|amino_acid| amino_acid.depth + 1)
//.unwrap_or(0),
//amino_acid
//    .as_ref()
//    .is_some_and(|amino_acid| )

//pub struct ProteinFolding {
//    sequence: Sequence,
//}

//impl ProteinFolding {
//    pub fn new(sequence: Sequence) -> Self {
//        Self { sequence }
//    }
//}

//println!("explored:\n- {:?}", explored);
//println!("frontier:\n- {:?}\n", frontier);
//println!("{:?}", state);
//println!(
//    "actions:\n- {:?}",
//    self.problem
//        .expand(&state)
//        .map(|(a, _)| a)
//        .collect::<Vec<A>>()
//);
//println!("explored:\n- {:?}", explored);
//println!("frontier:\n- {:?}\n", frontier);

//self.problem.expand(&state).map(|(action, cost)| self.problem.new_state(, a))

//let new_state = self.problem.new_state(&state, &action);
//let new_state = self.problem.new_state(&state, &action);

//fn next_state(&self, s: &S, a: &A) -> (S, Cost);

//let new_node = Rc::new(Node {
//    parent: Some((action, node.clone())),
//    depth: node.depth + 1,
//    cost: node.cost + action_cost,
//    heuristic: self.problem.h(&new_state),
//});

//let node = Rc::new(Node {
//    parent: None,
//    cost: 0,
//    heuristic: self.problem.h(&state),
//    depth: 0,
//});

// TODO: mut ref + lifetime, possibly lifetime on class or impl

//parent: Option<(A, Rc<Node<A>>)>,

//let time = Instant::now();
//impl<A> Debug for Node<A> {
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        f.write_fmt(format_args!(
//            "g: {}, h: {}, f: {}, d: {}",
//            self.cost,
//            self.heuristic,
//            self.cost + self.heuristic,
//            self.depth
//        ))
//    }
//}

//(P, Option<S>): TryInto<S>,
//self.state = (perception, self.state.clone()).try_into().ok();

// node + Rc :: clone for nodes, so just clone the states and don't reuse them!

//println!("{:#?}", time.elapsed())
//println!("{:#?}", time.elapsed())
//println!("frontier: {:?}", frontier);
//println!("explored: {:?}", explored);
//if let Some(depth) = depth {
//    if node.depth > depth {
//        continue;
//        //return None;
//    }
//}

//println!("\n{:?}", state);

//println!(
//    "actions: {:?}",
//    self.problem.actions(&state).into_iter().collect::<Vec<A>>()
//);

//println!("frontier: {:?}", frontier);
//println!("explored: {:?}", explored);

// should actions be owned
// who should own the actions?
// Should it be owned? Or should I give a reference?
// Who sould handle states? The freacking problem or the algorithm?
// It would be a better fit for the problem to handle them...

//pub trait Problem<S, A> {
//    fn expand(&self, s: &S) -> impl Iterator<Item = (A, Cost)>;
//    fn is_goal(&self, s: &S) -> bool;
//    fn new_state(&self, s: &S, a: &A) -> S;
//    fn h(&self, s: &S) -> Heuristic;
//}

// I can return action + cost, without heuristic

// minimal problem, techincally I don't need more... I could have Item be some structure of A... but?
//pub trait Problem<S, A, T>
// where: T: From<A>
//{
//    fn expand(&self, s: &S) -> impl Iterator<Item = T>;
//    fn is_goal(&self, s: &S) -> bool;
//    fn new_state(&self, s: &S, a: &A) -> S;
//}
//for the agent I can just put the cost!

//impl<A> Debug for Node<A>
//where
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        let p = self
//            .parent
//            .as_ref()
//            .and_then(|(_, p)| p.parent.as_ref().map(|(a, _)| a));
//
//        if let Some(a) = p {
//            f.write_fmt(format_args!(
//                "p: {:?}, g: {}, h: {}, f: {}, d: {}",
//                a,
//                self.g,
//                self.h,
//                self.g + self.h,
//                self.depth
//            ))
//        } else {
//            f.write_fmt(format_args!(
//                "p: S, g: {}, h: {}, f: {}, d: {}",
//                self.g,
//                self.h,
//                self.g + self.h,
//                self.depth
//            ))
//        }
//    }
//}

// TODO: move out expand
//pub trait Problem<S, A, V, T> {
//fn expand(&self, state: &S) -> impl Iterator<Item = T>;

//pub trait Problem<S, A, V> {
//    fn new_state(&self, state: &S, action: &A) -> S;
//    fn value(&self, state: &S) -> V;
//}
//
//pub trait StateSpaceExploration<S, A>: Problem<S, A, usize> {
//    fn expand(&self, state: &S) -> impl Iterator<Item = (S, A, usize)>;
//    fn is_goal(&self, state: &S) -> bool;
//}
//
//pub trait IterativeImprovement<S, A, V>: Problem<S, A, V> {
//    fn expand(&self, state: &S) -> impl Iterator<Item = A>;
//}
//
//pub trait ParallelImprovement<S, A, V>: Problem<S, A, V> {
//    fn par_expand(&self, state: &S) -> impl ParallelIterator<Item = A>;
//}

// -----------------------------------------------------------------------------------------------------

//pub trait Problem2<V>: BasicProblem2 {
//    fn value(&self, state: &Self::State) -> V;
//}
//
//pub trait BasicProblem2 {
//    type State;
//    type Action;
//
//    fn new_state(&self, state: &Self::State, action: &Self::Action) -> Self::State;
//}
//
////fn value(&self, state: &Self::State) -> V;
//
////type Value;
//
//pub trait StateSpaceExploration2<V>: Problem2<V> {
//    fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::State, Self::Action, V)>;
//    fn is_goal(&self, state: &Self::State) -> bool;
//}
//
//pub trait IterativeImprovement2<V>: Problem2<V> {
//    fn expand(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;
//}
//
//pub trait ParallelImprovement2<V>: Problem2<V> {
//    fn par_expand(&self, state: &Self::State) -> impl ParallelIterator<Item = Self::Action>;
//}
//
//type Position = Vec<usize>;
//
//type Move = (usize, usize);
//
//struct NQueens(usize);
//
//impl BasicProblem2 for NQueens {
//    type State = Position;
//    type Action = Move;
//
//    fn new_state(&self, position: &Position, &(col, row): &Move) -> Position {
//        let mut new_position = position.clone();
//        new_position[col] = row;
//        new_position
//    }
//}
//
//impl Problem2<Reverse<usize>> for NQueens {
//    fn value(&self, position: &Position) -> Reverse<usize> {
//        let mut attacks = 0;
//
//        for (col_i, row_i) in position.iter().enumerate() {
//            for (col_j, row_j) in position.iter().skip(col_i + 1).enumerate() {
//                if row_i == row_j || row_i.abs_diff(*row_j) == col_i.abs_diff(col_j) {
//                    attacks += 1;
//                }
//            }
//        }
//
//        Reverse(attacks)
//    }
//}
//
////type Value = Reverse<usize>;
//
//impl IterativeImprovement2<Reverse<usize>> for NQueens {
//    //type State = Position;
//    //type Action = Move;
//
//    fn expand(&self, position: &Position) -> impl Iterator<Item = Move> {
//        let mut moves = vec![];
//
//        for (col, &row) in position.iter().enumerate() {
//            if row > 0 {
//                moves.push((col, row - 1));
//            }
//            if row < position.len() - 1 {
//                moves.push((col, row + 1));
//            }
//        }
//
//        moves.into_iter()
//    }
//}
//
////impl ParallelImprovement2 for NQueens {
////    fn par_expand(&self, state: &Position) -> impl ParallelIterator<Item = Move> {
////        self.expand(state)
////            .collect::<Vec<(usize, usize)>>()
////            .into_par_iter()
////    }
////}

//problem.expand(&state)
//P: IterativeImprovement<S, A, V> + Distribution<S>,

//.filter_map(|(action, new_value)| (new_value > value).then_some((action, new_value)))
//.max_by_key(|&(_, value)| value)
//Some((action, value)) => (problem.new_state(&state, &action), value),
//println!("{:?}", value);

// TODO: it would be interesting to use a rayon ParallelIterator to parallelize the lookup of
// the next state

//let new_state = problem.new_state(&state, &action);
//let new_value = problem.value(&new_state);

//state = match problem
//    .expand(&state)
//    .map(|action| problem.new_state(&state, &action))
//    .filter(|s| problem.value(s) > problem.value(&state))
//    .max_by_key(|new_state| problem.value(new_state))
//{
//    Some(new) => new,
//    _ => return Some(state),
//}

//.filter(|s| problem.value(s) > problem.value(&state))

//.map(|s| (s, problem.value(&s)))
//.max_by_key(|(_, v)| v)

//let mut next = None;
//for new_state in problem
//    .expansion(&state)
//    .map(|action| problem.new_state(&state, &action))
//{
//    if problem.value(&new_state) > problem.value(&state) {
//        next = Some(new_state);
//    }
//}

//let new_state = problem.new_state(&state, &action);

//if let Some(s) = next {
//    state = s
//} else {
//    return Some(state);
//}

// descent
//let mut found_act = None;
//found_act = Some(action);
//pub fn steepest_ascent_with_goal<P, S, U>(problem: &P, rng: &mut impl Rng) -> Option<S>
//where
//    U: Ord + Copy,
//    P: IterativeImprovement<U, State = S> + Distribution<S> + Goal,
//{
//    let mut state = problem.sample(rng);
//    let mut utility = problem.utility(&state);
//
//    loop {
//        if problem.is_goal(&state) {
//            return Some(state);
//        }
//
//        (state, utility) = match problem
//            .expand(&state)
//            .filter_map(|action| {
//                let new_state = problem.new_state(&state, &action);
//                let new_utility = problem.utility(&new_state);
//
//                (new_utility > utility).then_some((new_state, new_utility))
//            })
//            .max_by_key(|&(_, value)| value)
//        {
//            Some(new) => new,
//            _ => return Some(state),
//        };
//    }
//}

// function steepest_ascent(problema): stato ottimo locale
//2 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//3 while true do
//4 vicino ← uno a caso dei ‘vicini’ migliori di nodo_corrente;
//5 if nodo_corrente è migliore o della stessa qualità di vicino then
//6 return nodo_corrente.stato; /* ottimo locale, poss. piatto */
//7 else nodo_corrente ← vicino ;

//Variante: Hill-climbing con prima scelta
//1 function hill_climbing(problema): stato ottimo locale
//2 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//3 while true do
//4 mossa_trovata ← false;
//5 while mossa_trovata = false and nodo_corrente ha ancora vicini
//da considerare do
//6 vicino ← prossimo ‘vicino’ di nodo_corrente;
//7 if vicino è migliore o della stessa qualità di nodo_corrente then
// /* nota: effettua mosse laterali */
//8 nodo_corrente ← vicino;
//9 mossa_trovata ← true;
//10 if mossa_trovata = false then
//11 return nodo_corrente.stato;

//function
//simulated_annealing(problema, velocità_raffredd): stato ottimo locale
//2 input velocità_raffredd, una corrisp.: tempo → “temperatura”
//3 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//4 for t from 0 to ∞ do
//5 T ← velocità_raffredd[t];
//6 if T = 0 then return nodo_corrente;
//7 vicino ← un ‘vicino’ random di nodo_corrente;
//8 if vicino è migliore di nodo_corrente then
// /* esegui sempre mosse migliorative */
//9 nodo_corrente ← vicino;
//10 else
// /* valuta se eseguire mosse peggiorative */
//11 ∆E ← abs(differenza di qualità tra nodo_corrente e vicino);
//12 nodo_corrente ← vicino con probabilità e−∆E /T;

//fmt::Debug,
//impl<S, A> Debug for Breadth<S, A>
//where
//    S: Debug,
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        self.0.fmt(f)
//    }
//}

//where
//    S: Debug,
//    A: Debug,
//impl<S, A> Debug for Depth<S, A>
//where
//    S: Debug,
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        self.0.fmt(f)
//    }
//}

//where
//S: Debug,
//A: Debug,
//impl<S, A, N> Debug for PriorityFrontier<S, A, N>
//where
//    S: Ord + Hash + Clone + Debug,
//    N: FromNode<A>,
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        for x in self.0.clone().into_sorted_iter() {
//            if let Some(v) = self.1.get(&x.0) {
//                f.write_fmt(format_args!("({:?}, {:?}), ", x.0, v))?
//            }
//        }
//        f.write_str("\n")
//    }
//}

//A: Debug,

// algoritmi a miglioramento iterativo

//trait MyProblem<'a, State, Action, Value>: Problem<State, Action, Value> {
//    fn new_state(&self, state: &mut State, action: &Action) -> &'a mut State;
//}

//fn is_goal(&self, state: &State) -> bool;
//fn is_goal(&self, s: &S) -> bool;
//fn new_state(&self, s: &S, a: &A) -> S;
//fn h(&self, s: &S) -> Heuristic;

//pub trait Problem<S, A> {
//    fn expand(&self, s: &S) -> impl Iterator<Item = (A, Cost)>;
//    fn is_goal(&self, s: &S) -> bool;
//    fn new_state(&self, s: &S, a: &A) -> S;
//    fn h(&self, s: &S) -> Heuristic;
//}

//pub trait ItProblem<State, Action, Fitness>
//where
//    Fitness: Ord,
//{
//    fn expand(&self, s: &State) -> impl Iterator<Item = Action>;
//    fn is_goal(&self, s: &State) -> bool;
//    fn fitness(&self, s: &State) -> Fitness;
//    fn new_state(&self, s: &State, a: &Action) -> State;
//}

//trait State<A> {
//    fn expand(&self) -> impl Iterator<Item = A>;
//    fn update(&mut self, action: A);
//    fn is_goal(&mut self);
//    fn goodness(&self) -> usize;
//}
//struct State {

//fn value(&self, position: &Position) -> Reverse<usize> {
//    let mut attacks = 0;
//
//    for (col_i, row_i) in position.iter().enumerate() {
//        for (col_j, row_j) in position.iter().skip(col_i + 1).enumerate() {
//            if row_i == row_j || row_i.abs_diff(*row_j) == col_i.abs_diff(col_j) {
//                attacks += 1;
//            }
//        }
//    }
//
//    Reverse(attacks)
//}

//if let Some(optimal) = optimal {
//    println!("{:?}", n_queens.value(&optimal));
//    for row in 0..optimal.len() {
//        for &queen_row in optimal.iter() {
//            if queen_row == row {
//                print!(" Q ")
//            } else {
//                print!(" . ")
//            }
//        }
//        println!()
//    }
//}

//let optimal = (0..=100000)
//    .into_par_iter()
//    .filter_map(|_| hill_climping(&n_queens, &mut rand::rng(), 100))
//    .max_by_key(|b| n_queens.value(b));
//
//if let Some(optimal) = optimal {
//    println!("{:?}", n_queens.value(&optimal));
//    for row in 0..optimal.len() {
//        for &queen_row in optimal.iter() {
//            if queen_row == row {
//                print!(" Q ")
//            } else {
//                print!(" . ")
//            }
//        }
//        println!()
//    }
//}

//fn expand(&self, position: &Position) -> impl Iterator<Item = Move> {
//    position
//        .iter()
//        .enumerate()
//        .map(|(row, &col)| ((row + 1).min(self.0 - 1), col))
//        .fuse()
//        .chain(
//            position
//                .iter()
//                .enumerate()
//                .map(|(row, &col)| (row.saturating_sub(1), col)),
//        )
//}

//use rayon::iter::{IntoParallelIterator, IntoParallelRefIterator};
//new_state[col] = row;
//state
//    .iter()
//    .enumerate()
//    .map(|(row, &col)| ((row + 1).min(self.0 - 1), col))
//    .fuse()
//    .chain(
//        state
//            .iter()
//            .enumerate()
//            .map(|(row, &col)| (row.saturating_sub(1), col)),
//    )

//impl Problem<Board, Move, Reverse<usize>, (Move, Reverse<usize>)> for NQueens {
//fn expand(&self, state: &Board) -> impl Iterator<Item = (Move, Reverse<usize>)> {

//println!("{attacks}");
//let mut rng = rand::rng();

//new_position.insert(col, row);
//for i in 0..position.len() {
//    for j in i + 1..position.len() {
//        if position[i] == position[j] || position[i].abs_diff(position[j]) == i.abs_diff(j)
//        {
//            attacks += 1;
//        }
//    }
//}

//let mut opt_count = 0;

//for _ in 0..100 {
//if let Some(optimal) = optimal {
//    if n_queens.value(&optimal) == Reverse(0) {
//        opt_count += 1;
//    }
//}
//}
//println!("{}", opt_count as f32 / 100.0)

//optimal = match optimal {
//    Some(optimal) if n_queens.value(&optimal) > n_queens.value(&new_optimal) => {
//        Some(new_optimal)
//    }
//    _ => optimal,
//};

//if n_queens.value(&new_optimal) > n_queens.value(&optimal) {}

//let v = ["A", "B", "C", "D", "E", "F", "G1", "G2", "J", "S"];
//let sketch = [
//    ("A", 9, vec![("B", 4)]),
//    ("B", 3, vec![("C", 3), ("G1", 9)]),
//    ("C", 2, vec![("F", 2), ("J", 5), ("S", 1)]),
//    ("D", 4, vec![("C", 3), ("E", 3), ("S", 8)]),
//    ("E", 5, vec![("G2", 7)]),
//    ("F", 3, vec![("D", 1), ("G2", 4)]),
//    ("G1", 0, vec![]),
//    ("G2", 0, vec![]),
//    ("J", 1, vec![("G1", 3)]),
//    ("S", 7, vec![("A", 2), ("B", 7), ("D", 5)]),
//];

//use models::state_space::V;
//
//let v = ["A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S"];
//let to_state: HashMap<&str, usize> =
//    HashMap::from_iter(v.iter().enumerate().map(|(i, &v)| (v, i)));
//
//let sketch = [
//    ("A", 16, vec![("E", 1), ("H", 8)]),
//    ("B", 16, vec![("C", 2), ("I", 3), ("J", 5)]),
//    ("C", 14, vec![("S", 1), ("G2", 18)]),
//    ("D", 17, vec![("C", 2)]),
//    ("E", 15, vec![("D", 2), ("H", 7)]),
//    ("G1", 0, vec![("E", 2)]),
//    ("G2", 0, vec![("C", 2), ("B", 15)]),
//    ("H", 8, vec![("G1", 9)]),
//    ("I", 12, vec![("A", 1), ("H", 4)]),
//    ("J", 10, vec![("G2", 12)]),
//    ("S", 20, vec![("A", 3), ("B", 3), ("D", 3)]),
//];
//
//let graph = sketch
//    .iter()
//    .map(|(_, _, vs)| vs.iter().map(|&(v, _)| V(to_state[v])).collect())
//    .collect();
//let goals = v.iter().map(|&v| v == "G1" || v == "G2").collect();
//let h = sketch.iter().map(|&(_, h, _)| h).collect();
//
//let mut costs = vec![vec![0; v.len()]; v.len()];
//for (u, _, vs) in sketch {
//    for (v, c) in vs {
//        costs[to_state[u]][to_state[v]] = c;
//    }
//}
//
//#[rustfmt::skip]
//let problem = models::state_space::Space { goals, costs, graph, h  };
//let perception = V(to_state["S"]);
//
//let mut agent = Agent::new(problem.clone());
//println!("iterative-deepening\n");
//while let Some(action) = agent.iterative_function::<V, Depth<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//let mut agent = Agent::new(problem.clone());
//println!("depth-first\n");
//while let Some(action) = agent.function::<V, Depth<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//let mut agent = Agent::new(problem.clone());
//println!("breadth-first\n");
//while let Some(action) = agent.function::<V, Breadth<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//let mut agent = Agent::new(problem.clone());
//println!("min-cost\n");
//while let Some(action) = agent.function::<V, MinCost<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");
//
//let mut agent = Agent::new(problem.clone());
//println!("best-first\n");
//while let Some(action) = agent.function::<V, BestFirst<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");
//
//let mut agent = Agent::new(problem.clone());
//println!("A*\n");
//while let Some(action) = agent.function::<V, AStar<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//struct Move(usize, usize);
//struct Board(Vec<usize>);

//impl Problem<Board, Vec<usize>, Reverse<usize>, Vec<usize>> for NQueens {
//    fn expansion(&self, state: &Board) -> impl Iterator<Item = Vec<usize>> {
//        // iterate all neightoubrs, so for each value in 0..8
//        [].into_iter()
//    }
//
//    fn new_state(&self, state: &Board, action: &Vec<usize>) -> Board {
//        todo!()
//    }
//
//    fn value(&self, state: &Board) -> Reverse<usize> {
//        todo!()
//    }
//}

//pub type Value = usize;
//pub type Heuristic = Value;
