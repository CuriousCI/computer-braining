//use std::{collections::BTreeSet, hash::Hash, rc::Rc};
//
//use ai::problem_solving_agent::Problem;
//
//#[derive(Eq, PartialEq, Clone, Hash, Debug)]
//pub struct State {
//    pos: (usize, usize),
//    pos_dirty: Rc<BTreeSet<(usize, usize)>>,
//}
//
//impl PartialOrd for State {
//    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
//        Some(self.pos.cmp(&other.pos))
//    }
//}
//
//impl Ord for State {
//    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
//        self.pos.cmp(&other.pos)
//    }
//}
//
//impl From<()> for State {
//    fn from(_: ()) -> Self {
//        State {
//            pos: (3, 4),
//            #[rustfmt::skip]
//             pos_dirty: Rc::new(BTreeSet::from([(0, 1), (0, 2), (0, 3), (1, 1), (1, 3), (2, 0), (2, 1), (3, 1), (3, 2), (3, 3), (3, 4), (4, 2), (4, 4)])),
//            //pos_dirty: Rc::new(BTreeSet::from([(0, 1), (0, 2), (0, 3), (1, 1), (1, 3), (2, 3), (2, 4), (3, 0), (3, 1), (3, 2), (3, 3), (4, 0), (4, 2)])),
//            //pos_dirty: Rc::new(BTreeSet::from([(0, 1), (0, 2), (0, 3), (1, 1), (1, 3), (2, 3), (2, 4), (3, 0), (3, 1), (3, 2)])),
//            //pos_dirty: Rc::new(BTreeSet::from([(0, 1), (0, 2), (0, 3), (1, 1), (1, 3), (2, 3), (2, 4), (3, 0), (3, 1), (3, 2), (3, 3), (4, 0), (4, 2)])),
//        }
//    }
//}
//
////impl Hash for State {
////    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
////        self.pos.hash(state);
////        self.pos_dirty.as_ref().hash(state)
////    }
////}
//
//#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug)]
//pub enum Action {
//    Left,
//    Right,
//    Up,
//    Down,
//    Suck,
//}
//
//pub struct Vacuum {
//    pub rows: usize,
//    pub cols: usize,
//}
//
//impl Problem<State, Action> for Vacuum {
//    fn expand(&self, s: &State) -> impl IntoIterator<Item = Action> {
//        if s.pos_dirty.as_ref().contains(&s.pos) {
//            return vec![Action::Suck];
//        }
//
//        let mut actions = vec![];
//
//        if s.pos.0 > 0 {
//            actions.push(Action::Left);
//        }
//
//        if s.pos.0 < self.cols - 1 {
//            actions.push(Action::Right);
//        }
//
//        if s.pos.1 > 0 {
//            actions.push(Action::Up);
//        }
//
//        if s.pos.1 < self.rows - 1 {
//            actions.push(Action::Down);
//        }
//
//        actions
//    }
//
//    fn is_goal(&self, s: &State) -> bool {
//        s.pos_dirty.is_empty()
//    }
//
//    fn new_state(&self, s: &State, a: &Action) -> (State, ai::problem_solving_agent::Cost) {
//        let (x, y) = s.pos;
//        let pos = match a {
//            Action::Suck => (x, y),
//            Action::Left => (x - 1, y),
//            Action::Right => (x + 1, y),
//            Action::Up => (x, y - 1),
//            Action::Down => (x, y + 1),
//        };
//
//        let next_state = match a {
//            Action::Suck => {
//                let mut next_pos_dirty = s.pos_dirty.as_ref().clone();
//                next_pos_dirty.remove(&s.pos);
//
//                State {
//                    pos,
//                    pos_dirty: Rc::new(next_pos_dirty),
//                }
//            }
//            _ => State {
//                pos,
//                pos_dirty: s.pos_dirty.clone(),
//            },
//        };
//
//        (next_state, 1)
//    }
//
//    //pos_dirty: Rc::clone(&s.pos_dirty),
//    //pos_dirty: s.pos_dirty.clone(),
//
//    //let next_pos_dirty = s.pos_dirty.as_ref().clone().into_iter().filter(|&p| p != s.pos).collect();
//
//    fn h(&self, s: &State) -> ai::problem_solving_agent::Heuristic {
//        s.pos_dirty.len() * self.rows * self.cols
//
//        //let mut dist = 0;
//        //for (x, y) in s.pos_dirty.as_ref() {
//        //    dist += x.abs_diff(s.pos.0);
//        //    dist += y.abs_diff(s.pos.1);
//        //}
//        //
//        //dist
//    }
//}
