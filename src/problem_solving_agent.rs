use std::{
    collections::{HashSet, VecDeque},
    fmt::Debug,
    hash::Hash,
    rc::Rc,
};

pub type Cost = usize;
pub type Heuristic = Cost;

pub trait Problem<S, A> {
    fn expand(&self, s: &S) -> impl Iterator<Item = (A, Cost)>;
    fn is_goal(&self, s: &S) -> bool;
    fn new_state(&self, s: &S, a: &A) -> S;
    fn h(&self, s: &S) -> Heuristic;
}

pub trait Frontier<S, A>: Default + Debug {
    fn next(&mut self) -> Option<(S, Rc<Node<A>>)>;
    fn insert(&mut self, state: S, node: Rc<Node<A>>);
    fn change(&mut self, _state: &S, _node: Rc<Node<A>>) {}
}

#[derive(Hash, Eq, PartialEq)]
pub struct Node<A> {
    parent: Option<(A, Rc<Node<A>>)>,
    depth: usize,
    pub g: Cost,
    pub h: Heuristic,
}

impl<A> Debug for Node<A>
where
    A: Debug,
{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let p = self
            .parent
            .as_ref()
            .and_then(|(_, p)| p.parent.as_ref().map(|(a, _)| a));

        if let Some(a) = p {
            f.write_fmt(format_args!(
                "p: {:?}, g: {}, h: {}, f: {}, d: {}",
                a,
                self.g,
                self.h,
                self.g + self.h,
                self.depth
            ))
        } else {
            f.write_fmt(format_args!(
                "p: S, g: {}, h: {}, f: {}, d: {}",
                self.g,
                self.h,
                self.g + self.h,
                self.depth
            ))
        }
    }
}

pub trait FromNode<A> {
    fn cost(node: &Node<A>) -> Cost;
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
    S: Eq + Hash + Clone + Debug,
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

    pub fn function<P, F>(&mut self, perception: P) -> Option<A>
    where
        P: TryInto<S>,
        F: Frontier<S, A>,
    {
        if self.plan.is_none() {
            self.state = perception.try_into().ok();
            self.plan = self.search::<F>(None);
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
            let mut depth = 1;
            while self.plan.is_none() {
                self.plan = self.search::<F>(Some(depth));
                depth += 1;
            }
        };

        self.plan.as_mut()?.pop_front()
    }

    fn search<F>(&mut self, depth: Option<usize>) -> Option<VecDeque<A>>
    where
        F: Frontier<S, A>,
    {
        let mut frontier = F::default();
        let mut explored = HashSet::new();
        let mut in_frontier = HashSet::new();

        let state = self.state.clone()?;
        let node = Rc::new(Node {
            h: self.problem.h(&state),
            parent: None,
            depth: 0,
            g: 0,
        });
        frontier.insert(state.clone(), node);

        println!("explored:\n- {:?}", explored);
        println!("frontier:\n- {:?}\n", frontier);

        while let Some((state, node)) = frontier.next() {
            explored.insert(state.clone());
            in_frontier.remove(&state);

            println!("{:?}", state);

            if self.problem.is_goal(&state) {
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

            println!(
                "actions:\n- {:?}",
                self.problem
                    .expand(&state)
                    .map(|(a, _)| a)
                    .collect::<Vec<A>>()
            );

            for (action, cost) in self.problem.expand(&state) {
                let new_state = self.problem.new_state(&state, &action);
                if !explored.contains(&new_state) {
                    let new_node = Rc::new(Node {
                        parent: Some((action, node.clone())),
                        depth: node.depth + 1,
                        g: node.g + cost,
                        h: self.problem.h(&new_state),
                    });

                    if !in_frontier.contains(&new_state) {
                        in_frontier.insert(new_state.clone());
                        frontier.insert(new_state, new_node);
                    } else {
                        frontier.change(&new_state, new_node);
                    }
                }
            }

            println!("explored:\n- {:?}", explored);
            println!("frontier:\n- {:?}\n", frontier);
        }

        None
    }
}

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
