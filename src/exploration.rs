use std::{
    collections::{HashSet, VecDeque},
    hash::Hash,
    ops::Add,
};

use crate::problem::{Exploration, Goal};

#[derive(Eq, PartialEq)]
pub struct Node<A, H> {
    prev: Option<(A, usize)>,
    pub g: H,
    pub h: H,
}

pub trait FromNode<A, H> {
    fn value(node: &Node<A, H>) -> H;
}

pub trait Frontier<A, H>: Default {
    fn next(&mut self) -> Option<(usize, usize)>;
    fn insert(&mut self, state: usize, node: usize, nodes: &[Node<A, H>]);
    fn change(&mut self, _: &usize, _: usize, _: &[Node<A, H>]) {}
}

pub struct Agent<S, A, P, H>
where
    P: Exploration<H, State = S, Action = A>,
{
    plan: Option<VecDeque<A>>,
    state: Option<S>,
    problem: P,
    phantom: std::marker::PhantomData<H>,
}

impl<S, A, P, H> Agent<S, A, P, H>
where
    S: Eq + Hash + Clone,
    A: Clone,
    P: Exploration<H, State = S, Action = A> + Goal,
    H: Default + Clone + Add<Output = H>,
{
    pub fn new(problem: P) -> Self {
        Self {
            plan: None,
            state: None,
            problem,
            phantom: Default::default(),
        }
    }

    pub fn function<Q, F>(&mut self, perception: Q) -> Option<A>
    where
        Q: TryInto<S>,
        F: Frontier<A, H>,
    {
        if self.plan.is_none() {
            self.state = perception.try_into().ok();
            self.plan = self.search::<F>();
        };

        self.plan.as_mut()?.pop_front()
    }

    fn search<F>(&self) -> Option<VecDeque<A>>
    where
        F: Frontier<A, H>,
    {
        let mut frontier = F::default();
        let mut explored = HashSet::new();
        let mut in_frontier = HashSet::new();

        let mut states: Vec<S> = vec![];
        let mut nodes: Vec<Node<A, H>> = vec![];

        states.push(self.state.clone()?);
        nodes.push(Node {
            prev: None,
            h: self.problem.heuristic(states.last()?),
            g: Default::default(),
        });

        frontier.insert(states.len() - 1, nodes.len() - 1, &nodes);
        let mut iterations = 0;

        while let Some((state, node)) = frontier.next() {
            iterations += 1;

            explored.insert(state);
            in_frontier.remove(&state);

            if self.problem.is_goal(&states[state]) {
                let mut plan = VecDeque::new();
                let mut node = node;
                while let Some((action, prev)) = nodes[node].prev.clone() {
                    plan.push_front(action);
                    node = prev;
                }
                println!("iterations: {iterations}");
                return Some(plan);
            }

            for (action, cost) in self.problem.expand(&states[state].clone()) {
                states.push(self.problem.new_state(&states[state], &action));
                let new_state = states.len() - 1;

                if !explored.contains(&new_state) {
                    nodes.push(Node {
                        prev: Some((action, node)),
                        g: nodes[node].g.clone() + cost,
                        h: self.problem.heuristic(states.last()?),
                    });

                    if !in_frontier.contains(&new_state) {
                        frontier.insert(new_state, nodes.len() - 1, &nodes);
                        in_frontier.insert(new_state);
                    } else {
                        frontier.change(&new_state, nodes.len() - 1, &nodes);
                    }
                }
            }
        }

        None
    }
}

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
