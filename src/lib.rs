pub mod frontiers;
pub mod iterative_search;
pub mod problem_solving_agent;
pub mod problems;

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
