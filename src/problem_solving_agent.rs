use std::{
    collections::{HashSet, VecDeque},
    fmt::{Debug, write},
    hash::Hash,
    rc::Rc,
    time::Instant,
};

use crate::frontiers::DepthFirst;

pub type Cost = usize;
pub type Heuristic = usize;

pub trait Problem<S, A> {
    fn actions(&self, s: &S) -> impl IntoIterator<Item = A>;
    fn is_goal(&self, s: &S) -> bool;
    fn next_state(&self, s: &S, a: &A) -> (S, Cost);
    fn h(&self, s: &S) -> Heuristic;
}

pub trait Frontier<S, A>: Debug {
    fn new() -> Self;
    fn next(&mut self) -> Option<(S, Rc<Node<A>>)>;
    fn insert(&mut self, s: S, n: Rc<Node<A>>);
    fn change(&mut self, _: &S, _: Rc<Node<A>>) {}
}

#[derive(Hash, Eq, PartialEq)]
pub struct Node<A> {
    parent: Option<(A, Rc<Node<A>>)>,
    pub cost: Cost,
    pub heuristic: Heuristic,
    depth: usize,
}

impl<A> Debug for Node<A> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_fmt(format_args!(
            "g: {}, h: {}, f: {}, d: {}",
            self.cost,
            self.heuristic,
            self.cost + self.heuristic,
            self.depth
        ))

        //f.debug_struct("")
        //    //.field("parent", &self.parent)
        //    .field("g", &self.cost)
        //    .field("h", &self.heuristic)
        //    .field("f", &self.cost + &self.heuristic)
        //    .field("d", &self.depth)
        //    .finish()
    }
}

pub struct Agent<S, A, M>
where
    M: Problem<S, A>,
{
    plan: Option<VecDeque<A>>,
    state: Option<S>,
    problem: M,
}

impl<S, A, M> Agent<S, A, M>
where
    S: Eq + Clone + Hash + Ord + Debug,
    A: Clone + Debug,
    M: Problem<S, A>,
{
    pub fn new(problem: M) -> Self {
        Self {
            plan: None,
            state: None,
            problem,
        }
    }

    // TODO: mut ref + lifetime, possibly lifetime on class or impl
    pub fn function<P, F>(&mut self, perception: P) -> Option<A>
    where
        P: TryInto<S>,
        F: Frontier<S, A>,
    {
        if self.plan.is_none() {
            self.state = perception.try_into().ok();
            let time = Instant::now();
            self.plan = self.search::<F>(None);
            println!("{:#?}", time.elapsed())
        };

        self.plan.as_mut()?.pop_front()
    }

    pub fn iterative_function<P, F>(&mut self, perception: P) -> Option<A>
    where
        P: TryInto<S>,
        F: Frontier<S, A>,
    {
        if self.plan.is_none() {
            self.state = perception.try_into().ok();
            let time = Instant::now();
            let mut depth = 1;
            while self.plan.is_none() {
                self.plan = self.search::<F>(Some(depth));
                depth += 1;
            }
            println!("{:#?}", time.elapsed())
        };

        self.plan.as_mut()?.pop_front()
    }

    //(P, Option<S>): TryInto<S>,
    //self.state = (perception, self.state.clone()).try_into().ok();

    // node + Rc :: clone for nodes, so just clone the states and don't reuse them!
    fn search<F>(&self, depth: Option<usize>) -> Option<VecDeque<A>>
    where
        F: Frontier<S, A>,
    {
        let mut frontier = F::new();
        let state = self.state.clone()?;
        let node = Rc::new(Node {
            parent: None,
            cost: 0,
            heuristic: self.problem.h(&state),
            depth: 0,
        });

        frontier.insert(state, node);
        let mut explored = HashSet::new();
        let mut in_frontier = HashSet::new();

        println!("frontier: {:?}", frontier);
        println!("explored: {:?}", explored);

        while let Some((state, node)) = frontier.next() {
            explored.insert(state.clone());
            in_frontier.remove(&state);

            //if let Some(depth) = depth {
            //    if node.depth > depth {
            //        continue;
            //        //return None;
            //    }
            //}

            println!("\n{:?}", state);

            if self.problem.is_goal(&state) {
                let mut plan = VecDeque::new();
                let mut n = node;
                while let Some((action, parent)) = n.parent.clone() {
                    plan.push_front(action);
                    n = parent;
                }

                return Some(plan);
            }

            println!(
                "actions: {:?}",
                self.problem.actions(&state).into_iter().collect::<Vec<A>>()
            );

            if let Some(depth) = depth {
                if node.depth >= depth {
                    continue;
                }
            }

            for action in self.problem.actions(&state) {
                let (curr_state, action_cost) = self.problem.next_state(&state, &action);

                let curr_node = Rc::new(Node {
                    parent: Some((action, node.clone())),
                    depth: node.depth + 1,
                    cost: node.cost + action_cost,
                    heuristic: self.problem.h(&curr_state),
                });

                if !explored.contains(&curr_state) {
                    if !in_frontier.contains(&curr_state) {
                        in_frontier.insert(curr_state.clone());
                        frontier.insert(curr_state.clone(), curr_node);
                    } else {
                        frontier.change(&curr_state, curr_node);
                    }
                }
            }

            println!("frontier: {:?}", frontier);
            println!("explored: {:?}", explored);
        }

        None
    }
}
