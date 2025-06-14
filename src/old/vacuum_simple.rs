//use ai::problem_solving_agent::Problem;
//
//#[derive(Copy, Clone, Eq, PartialEq, Hash, Debug)]
//enum Pos {
//    A,
//    B,
//}
//
//#[derive(Copy, Clone, Eq, PartialEq, Hash, Debug)]
//enum Tile {
//    Clean,
//    Dirty,
//}
//
//#[derive(Copy, Clone, Eq, PartialEq, Hash, Debug)]
//pub struct State {
//    pos: Pos,
//    tiles: [Tile; 2],
//}
//
//impl From<usize> for State {
//    fn from(value: usize) -> Self {
//        State {
//            pos: Pos::A,
//            tiles: match value {
//                0 => [Tile::Dirty, Tile::Dirty],
//                1 => [Tile::Dirty, Tile::Clean],
//                2 => [Tile::Clean, Tile::Dirty],
//                _ => [Tile::Clean, Tile::Clean],
//            },
//        }
//    }
//}
//
//#[derive(Copy, Clone, Debug)]
//pub enum Action {
//    Left,
//    Right,
//    Suck,
//}
//
//pub struct Vacuum;
//
//impl Problem<State, Action> for Vacuum {
//    fn expand(&self, _: &State) -> impl IntoIterator<Item = Action> {
//        [Action::Left, Action::Right, Action::Suck]
//    }
//
//    fn is_goal(&self, s: &State) -> bool {
//        matches!(s.tiles, [Tile::Clean, Tile::Clean])
//    }
//
//    fn new_state(&self, &State { pos, tiles }: &State, a: &Action) -> (State, usize) {
//        let next_state = match a {
//            Action::Left => State { pos: Pos::A, tiles },
//            Action::Right => State { pos: Pos::B, tiles },
//            Action::Suck => State {
//                pos,
//                tiles: match pos {
//                    Pos::A => [Tile::Clean, tiles[1]],
//                    Pos::B => [tiles[0], Tile::Clean],
//                },
//            },
//        };
//
//        (next_state, 1)
//    }
//
//    fn h(&self, s: &State) -> usize {
//        0
//    }
//}
