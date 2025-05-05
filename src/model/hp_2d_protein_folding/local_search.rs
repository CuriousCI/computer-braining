use ai::framework::problem::{CrossOver, Heuristic, Mutable, Problem, TransitionModel};

use super::{Alphabet, Pos, Sequence};

#[derive(Clone, Copy, Debug)]
pub enum Rotation {
    Left,
    Right,
}

#[derive(Clone, Copy, Debug)]
pub enum RelativeDirection {
    Forward,
    Left,
    Right,
}

#[derive(Debug)]
pub enum CardinalDirection {
    North,
    East,
    South,
    West,
}

#[derive(Clone)]
pub struct Fold {
    pub rotation: Rotation,
    pub amino_acid: usize,
}

pub struct Local2dProteinFolding {
    sequence: Sequence,
    folds: Vec<Fold>,
}

impl Local2dProteinFolding {
    pub fn new(sequence: Sequence) -> Self {
        Self {
            folds: (0..sequence.len() - 1)
                .flat_map(|amino_acid| {
                    [
                        Fold {
                            amino_acid,
                            rotation: Rotation::Left,
                        },
                        Fold {
                            amino_acid,
                            rotation: Rotation::Right,
                        },
                    ]
                })
                .collect(),
            sequence,
        }
    }
}

impl std::ops::Deref for Local2dProteinFolding {
    type Target = Sequence;

    fn deref(&self) -> &Self::Target {
        &self.sequence
    }
}

impl rand::distr::Distribution<ProteinConformation> for Local2dProteinFolding {
    fn sample<R: rand::Rng + ?Sized>(&self, rng: &mut R) -> ProteinConformation {
        ProteinConformation {
            directions: (0..self.len())
                .map(|_| match rng.random_range(0..3) {
                    0 => RelativeDirection::Forward,
                    2 => RelativeDirection::Left,
                    _ => RelativeDirection::Right,
                })
                .collect(),
        }
    }
}

#[derive(Clone, Debug)]
pub struct ProteinConformation {
    pub directions: Vec<RelativeDirection>,
}

impl ProteinConformation {
    pub fn positions(&self) -> Vec<Pos> {
        let (mut x, mut y) = (0, 0);
        let mut result = Vec::from([(x, y)]);

        let mut direction = CardinalDirection::North;

        use CardinalDirection as C;
        use RelativeDirection as R;

        for amino_acid in 0..=self.directions.len() - 2 {
            (x, y) = match direction {
                C::North => (x, y - 1),
                C::East => (x + 1, y),
                C::South => (x, y + 1),
                C::West => (x - 1, y),
            };

            direction = match (direction, self.directions[amino_acid]) {
                (direction, R::Forward) => direction,
                (C::East, R::Left) | (C::West, R::Right) => C::North,
                (C::North, R::Right) | (C::South, R::Left) => C::East,
                (C::East, R::Right) | (C::West, R::Left) => C::South,
                (C::North, R::Left) | (C::South, R::Right) => C::West,
            };

            result.push((x, y));
        }

        result
    }
}

impl Problem for Local2dProteinFolding {
    type State = ProteinConformation;
}

impl TransitionModel for Local2dProteinFolding {
    type Action = Fold;

    fn actions(&self, _: &Self::State) -> impl Iterator<Item = Self::Action> {
        self.folds.clone().into_iter()
    }

    fn result(&self, state: &Self::State, action: &Self::Action) -> Self::State {
        let mut new_conformation = state.clone();

        use RelativeDirection as D;
        use Rotation as R;

        for amino_acid in action.amino_acid + 1..self.len() {
            new_conformation.directions[amino_acid] =
                match (state.directions[amino_acid], action.rotation) {
                    (D::Forward, R::Right) => D::Right,
                    (D::Forward, R::Left) => D::Left,
                    (D::Left, R::Right) => D::Forward,
                    (D::Left, R::Left) => D::Left,
                    (D::Right, R::Right) => D::Right,
                    (D::Right, R::Left) => D::Forward,
                }
        }

        new_conformation
    }
}

#[derive(Clone, Debug, Eq)]
pub struct Utility {
    overlaps: i32,
    contacts: i32,
}

impl Utility {
    pub fn is_better(&self, other: Utility) -> bool {
        self.overlaps < other.overlaps
            || (self.overlaps == other.overlaps && self.contacts > other.contacts)
    }

    pub fn cost(&self) -> i32 {
        self.contacts - self.overlaps
    }
}

impl Ord for Utility {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        (self.cost()).cmp(&(other.cost()))
    }
}

impl PartialOrd for Utility {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Utility {
    fn eq(&self, other: &Self) -> bool {
        (self.cost()) == (other.cost())
    }
}

impl From<Utility> for f32 {
    fn from(value: Utility) -> Self {
        value.cost() as f32
    }
}

impl Heuristic for Local2dProteinFolding {
    type Value = Utility;

    fn heuristic(&self, state: &Self::State) -> Self::Value {
        let mut contacts = 0;
        let mut overlaps = 0;

        let conf = state.positions();
        for (i, &(u_x, u_y)) in conf.iter().enumerate() {
            for (j, &(v_x, v_y)) in conf[..0.max(i.abs_diff(1))].iter().enumerate() {
                if let (Alphabet::H, Alphabet::H) = (&self[i], &self[j]) {
                    if u_x.abs_diff(v_x) + u_y.abs_diff(v_y) == 1 {
                        contacts += 1;
                    }
                }

                if i != j && u_x == v_x && u_y == v_y {
                    overlaps += 1;
                }
            }
        }

        Utility { contacts, overlaps }
    }
}

impl Mutable for Local2dProteinFolding {
    fn mutate(&self, state: &mut Self::State, rng: &mut impl rand::Rng) {
        state.directions[rng.random_range(0..self.len())] = match rng.random_range(0..3) {
            0 => RelativeDirection::Forward,
            1 => RelativeDirection::Right,
            _ => RelativeDirection::Left,
        };
    }
}

impl CrossOver for Local2dProteinFolding {
    fn cross_over(
        &self,
        l: &Self::State,
        r: &Self::State,
        rng: &mut impl rand::Rng,
    ) -> Self::State {
        let cross_over_point = rng.random_range(0..self.len());
        let mut child = l.clone();

        for amino_acid in cross_over_point..self.len() {
            child.directions[amino_acid] = r.directions[amino_acid];
        }

        child
    }
}

// match (&state.directions[amino_acid], &action.rotation) {
//     (RelativeDirection::Forward, Rotation::Left) => RelativeDirection::Left,
//     (RelativeDirection::Forward, Rotation::Right) => RelativeDirection::Right,
//     (RelativeDirection::Backwards, Rotation::Left) => RelativeDirection::Right,
//     (RelativeDirection::Backwards, Rotation::Right) => RelativeDirection::Left,
//     (RelativeDirection::Right, Rotation::Left) => RelativeDirection::Forward,
//     (RelativeDirection::Right, Rotation::Right) => RelativeDirection::Backwards,
//     (RelativeDirection::Left, Rotation::Left) => RelativeDirection::Backwards,
//     (RelativeDirection::Left, Rotation::Right) => RelativeDirection::Forward,
// }

// self.overlaps == other.overlaps && self.contacts == other.contacts

// impl PartialEq for Utility {
//     fn eq(&self, other: &Self) -> bool {
//         self.overlaps == other.overlaps && self.contacts == other.contacts
//     }
// }

// let mut state = state;

// state

// let (x, y) = (0, 0);

// let mut overlaps = 0;

// let mut positions = BTreeSet::from([(x, y)]);
// let mut energy = 0;

// println!("{:?}", conf);

// let mut set = BTreeSet::new();
// for pos in conf {
//     set.insert(pos);
// }
// println!("{:?}", set);
// let overlaps = (self.len() - set.len()) as i32;
// contacts - overlaps * 2

// 2 => RelativeDirection::Backwards,

// Reverse(energy)

// for amino_acid in 0..self.len() - 1 {

// let (x, y) = match state.directions[amino_acid] {
//     Direction::North => (x, y - 1),
//     Direction::South => (x, y + 1),
//     Direction::East => (x - 1, y),
//     Direction::West => (x + 1, y),
// };

// if !positions.insert((x, y)) {
//     overlaps += 1;
// }

//     let possible_contacts = match state.directions[amino_acid] {
//         Direction::North | Direction::South => [(x - 1, y), (x + 1, y)],
//         _ => [(x, y - 1), (x, y + 1)],
//     };
//
//     for (x_p, y_p) in possible_contacts {
//         if positions.contains(&(x_p, y_p)) {
//             contacts += 1;
//         }
//     }
// }

// println!("{contacts}, {overlaps}");

// pub enum Move {
//     Left,
//     Right,
//     Up,
// }
//
// pub enum Direction {
//     North,
//     South,
//     East,
//     West,
// }

// let actions = (1..sequence.len() - 1)
//     .flat_map(|amino_acid| {
//         [
//             Fold {
//                 amino_acid,
//                 turn: Turn::Left,
//             },
//             Fold {
//                 amino_acid,
//                 turn: Turn::Right,
//             },
//         ]
//     })
//     .collect();
//
// Self { sequence, actions }

// Rotation(Rotation),
// Right,
// Left,

// needed for current direction
// let directions = (0..self.len())
//     .map(|_| match rng.random_range(0..4) {
//         0 => Direction::North,
//         1 => Direction::East,
//         2 => Direction::South,
//         _ => Direction::West,
//     })

// I punti cardinali fanno pensare a qualcosa di fisso
// sarebbe meglio dire forward, backward, left, right
// forward
// backward
// left
// right
// (C::East, R::Forward) => C::North,

// direction = match (direction, self.directions[0]) {
//     (D::Forward, d) => d,
//     (D::Backwards, D::Backwards) => D::Forward,
//     // (D::North, D::East) => D::East,
//     // (D::North, D::South) => D::South,
//     // (D::North, D::West) => D::West,
//     _ => D::Forward,
// };

// for amino_acid in 0..=self.directions.len() - 2 {
//     (x, y) = match self.directions[amino_acid] {
//         RelativeDirection::Forward => (x, y - 1),
//         RelativeDirection::Right => (x + 1, y),
//         // Direction::Backwards => (x, y + 1),
//         RelativeDirection::Left => (x - 1, y),
//     };
//     result.push((x, y));
// }

//     .collect();

// => C::East,
// (C::West, R::Right) => C::North,
//
// (C::North, R::Right) => C::East,
// (C::North, R::Left) => C::West,
// (C::East, R::Right) => C::South,
// (C::East, R::Left) => C::North,
// (C::South, R::Right) => C::West,
// (C::South, R::Left) => C::East,
// (C::West, R::Right) => C::North,
// (C::West, R::Left) => C::South,
