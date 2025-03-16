use std::fmt::Debug;

use ai::problem_solving_agent::{Cost, Problem};

#[derive(Copy, Clone, Ord, PartialEq, Eq, Hash, PartialOrd)]
pub struct V(pub usize);

static VERTICES: [&str; 10] = ["A", "B", "C", "D", "E", "F", "G1", "G2", "J", "S"];

impl Debug for V {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(VERTICES[self.0])
    }
}

#[derive(Clone)]
pub struct Space {
    pub goals: Vec<bool>,
    pub costs: Vec<Vec<Cost>>,
    pub graph: Vec<Vec<V>>,
    pub h: Vec<usize>,
}

impl Problem<V, V> for Space {
    fn actions(&self, &s: &V) -> impl IntoIterator<Item = V> {
        self.graph[s.0].clone()
    }

    fn is_goal(&self, &s: &V) -> bool {
        self.goals[s.0]
    }

    fn next_state(&self, s: &V, &a: &V) -> (V, ai::problem_solving_agent::Cost) {
        (a, self.costs[s.0][a.0])
    }

    fn h(&self, s: &V) -> ai::problem_solving_agent::Heuristic {
        self.h[s.0]
    }
}

//impl From<((), Option<State>)> for State {
//    fn from(value: ((), Option<State>)) -> Self {
//        todo!()
//    }
//}

//type A = V;
//impl From<usize> for V {
//    fn from(value: usize) -> Self {
//        V(value)
//    }
//}
//
//impl Deref for V {
//    type Target = usize;
//
//    fn deref(&self) -> &Self::Target {
//        &self.0
//    }
//}

//type S = usize;
//f.debug_tuple("S").field(&self.0).finish()
//f.debug_struct
//print!("{v}");
//println!("v: {v}");
//f.write_str(v)
//impl From<V> for usize {
//    fn from(value: V) -> Self {
//        value.0
//    }
//}
