use bumpalo::Bump;
use std::{
    collections::{HashSet, VecDeque},
    hash::Hash,
    ops::Add,
    rc::Rc,
};

use crate::problem::Exploration;

//pub type Value = usize;
//pub type Heuristic = Value;

#[derive(Eq, PartialEq)]
pub struct Node<A, U> {
    parent: Option<(A, Rc<Node<A, U>>)>,
    depth: usize,
    pub g: U,
    pub h: U,
}

pub trait FromNode<A, U> {
    fn value(node: &Node<A, U>) -> U;
}

pub trait Frontier<S, A, U>: Default {
    fn next(&mut self) -> Option<(S, Rc<Node<A, U>>)>;
    fn insert(&mut self, state: S, node: Rc<Node<A, U>>);
    fn change(&mut self, _state: &S, _node: Rc<Node<A, U>>) {}
}

pub struct Agent<S, A, P, U>
where
    P: Exploration<U, State = S, Action = A>,
{
    plan: Option<VecDeque<A>>,
    state: Option<S>,
    problem: P,
    phantom: std::marker::PhantomData<U>,
}

impl<S, A, P, U> Agent<S, A, P, U>
where
    U: Default + Clone + Add<Output = U>,
    S: Eq + Hash + Clone,
    A: Clone,
    P: Exploration<U, State = S, Action = A>,
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
        F: Frontier<S, A, U>,
    {
        if self.plan.is_none() {
            self.state = perception.try_into().ok();
            self.plan = self.search::<F>(None);
        };

        self.plan.as_mut()?.pop_front()
    }

    pub fn iterative_function<Q, F>(&mut self, perception: Q) -> Option<A>
    where
        Q: TryInto<S>,
        F: Frontier<S, A, U>,
    {
        if self.plan.is_none() {
            self.state = perception.try_into().ok();
            let mut depth = 1;
            while self.plan.is_none() {
                self.plan = self.search::<F>(Some(depth));
                depth += 1;
            }
        };

        self.plan.as_mut()?.pop_front()
    }

    fn search<F>(&self, depth: Option<usize>) -> Option<VecDeque<A>>
    where
        F: Frontier<S, A, U>,
    {
        let mut frontier = F::default();
        let mut explored = HashSet::new();
        let mut in_frontier = HashSet::new();

        let arena = Bump::new();

        let state = arena.alloc(self.state.clone()?);
        let node = Rc::new(Node {
            h: self.problem.utility(state),
            parent: None,
            depth: 0,
            g: Default::default(),
        });
        frontier.insert(state.clone(), node);

        while let Some((state, node)) = frontier.next() {
            let state = arena.alloc(state);

            explored.insert(&*state);
            in_frontier.remove(state);

            if self.problem.is_goal(state) {
                let mut plan = VecDeque::new();
                let mut n = node;
                while let Some((action, parent)) = n.parent.clone() {
                    plan.push_front(action);
                    n = parent;
                }

                return Some(plan);
            }

            if let Some(depth) = depth {
                if node.depth >= depth {
                    continue;
                }
            }

            for (action, cost) in self.problem.expand(state) {
                let new_state = arena.alloc(self.problem.new_state(state, &action));

                if !explored.contains(&*new_state) {
                    let new_node = Rc::new(Node {
                        parent: Some((action, node.clone())),
                        depth: node.depth + 1,
                        g: node.g.clone() + cost,
                        h: self.problem.utility(new_state),
                    });

                    if !in_frontier.contains(&new_state) {
                        frontier.insert(new_state.clone(), new_node);
                        in_frontier.insert(new_state);
                    } else {
                        frontier.change(new_state, new_node);
                    }
                }
            }
        }

        None
    }
}

//let state = self.state.clone()?;
//let new_state = self.problem.new_state(&state, &action);
//states.push(new_state);
//let new_state = states.last().unwrap();
//states.push(state);
//let state = states.last().unwrap();
