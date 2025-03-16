use std::{
    cmp::Reverse,
    collections::{HashMap, VecDeque},
    fmt::Debug,
    hash::Hash,
};

use crate::problem_solving_agent::*;

#[derive(Debug)]
pub struct BreadthFirst<S, A>(VecDeque<(S, std::rc::Rc<Node<A>>)>);

impl<S, A> Frontier<S, A> for BreadthFirst<S, A>
where
    S: Hash + Eq + Debug + Clone,
    A: Debug,
{
    fn new() -> Self {
        BreadthFirst(VecDeque::new())
    }

    fn next(&mut self) -> Option<(S, std::rc::Rc<Node<A>>)> {
        self.0.pop_front()
    }

    fn insert(&mut self, s: S, n: std::rc::Rc<Node<A>>) {
        self.0.push_back((s, n));
    }
}

#[derive(Debug)]
pub struct DepthFirst<S, A>(Vec<(S, std::rc::Rc<Node<A>>)>);

impl<S, A> Frontier<S, A> for DepthFirst<S, A>
where
    S: Eq + Debug,
    A: Debug,
{
    fn new() -> Self {
        DepthFirst(Vec::new())
    }

    fn next(&mut self) -> Option<(S, std::rc::Rc<Node<A>>)> {
        self.0.pop()
    }

    fn insert(&mut self, s: S, n: std::rc::Rc<Node<A>>) {
        self.0.push((s, n));
    }
}

use priority_queue::PriorityQueue;
#[derive(Debug)]
pub struct MinCost<S, A>(
    PriorityQueue<S, (Reverse<usize>, Reverse<S>)>,
    HashMap<S, std::rc::Rc<Node<A>>>,
);

impl<S, A> Frontier<S, A> for MinCost<S, A>
where
    S: Eq + Hash + Debug + Clone + Ord, //(Reverse<usize>, Rc<S>): Ord,
    A: Eq + Hash + Debug,
{
    fn new() -> Self {
        MinCost(PriorityQueue::new(), HashMap::new())
    }

    fn next(&mut self) -> Option<(S, std::rc::Rc<Node<A>>)> {
        let (s, _) = self.0.pop()?;
        let n = self.1.get(&s)?.clone();
        Some((s, n))
    }

    fn insert(&mut self, s: S, n: std::rc::Rc<Node<A>>) {
        self.0
            .push(s.clone(), (Reverse(n.cost), Reverse(s.clone())));
        self.1.insert(s, n);
    }

    fn change(&mut self, s: &S, n: std::rc::Rc<Node<A>>) {
        if self.1.get(s).is_none_or(|prev_n| prev_n.cost > n.cost) {
            self.0
                .change_priority(&s.clone(), (Reverse(n.cost), Reverse(s.clone())));
            self.1.insert(s.clone(), n);
        }
    }
}

#[derive(Debug)]
pub struct BestFirst<S, A>(
    PriorityQueue<S, Reverse<usize>>,
    HashMap<S, std::rc::Rc<Node<A>>>,
);

impl<S, A> Frontier<S, A> for BestFirst<S, A>
where
    S: Eq + Hash + Debug + Clone, //(Reverse<usize>, Rc<S>): Ord,
    A: Eq + Hash + Debug,
{
    fn new() -> Self {
        BestFirst(PriorityQueue::new(), HashMap::new())
    }

    fn next(&mut self) -> Option<(S, std::rc::Rc<Node<A>>)> {
        let (s, _) = self.0.pop()?;
        let n = self.1.get(&s)?.clone();
        Some((s, n))
    }

    fn insert(&mut self, s: S, n: std::rc::Rc<Node<A>>) {
        self.0.push(s.clone(), Reverse(n.heuristic));
        self.1.insert(s, n);
    }

    fn change(&mut self, s: &S, n: std::rc::Rc<Node<A>>) {
        if self
            .1
            .get(s)
            .is_none_or(|prev_n| prev_n.heuristic > n.heuristic)
        {
            self.0.change_priority(&s.clone(), Reverse(n.heuristic));
            self.1.insert(s.clone(), n);
        }
    }
}

#[derive(Debug)]
pub struct AStar<S, A>(
    PriorityQueue<S, (Reverse<usize>, Reverse<S>)>,
    HashMap<S, std::rc::Rc<Node<A>>>,
);

impl<S, A> Frontier<S, A> for AStar<S, A>
where
    S: Eq + Hash + Debug + Clone + Ord, //(Reverse<usize>, Rc<S>): Ord,
    A: Eq + Hash + Debug,
{
    fn new() -> Self {
        AStar(PriorityQueue::new(), HashMap::new())
    }

    fn next(&mut self) -> Option<(S, std::rc::Rc<Node<A>>)> {
        let (s, _) = self.0.pop()?;
        let n = self.1.get(&s)?.clone();
        Some((s, n))
    }

    fn insert(&mut self, s: S, n: std::rc::Rc<Node<A>>) {
        self.0.push(
            s.clone(),
            (Reverse(n.cost + n.heuristic), Reverse(s.clone())),
        );
        self.1.insert(s, n);
    }

    fn change(&mut self, s: &S, n: std::rc::Rc<Node<A>>) {
        if self
            .1
            .get(s)
            .is_none_or(|prev_n| prev_n.cost + prev_n.heuristic > n.cost + n.heuristic)
        {
            self.0.change_priority(
                &s.clone(),
                (Reverse(n.cost + n.heuristic), Reverse(s.clone())),
            );
            self.1.insert(s.clone(), n);
        }
    }
}
