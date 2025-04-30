use std::collections::BTreeSet;

use ai::framework::problem::{CrossOver, Heuristic, Mutable, Problem, TransitionModel};

use super::{Alphabet, Pos, Sequence};

#[derive(Clone)]
pub enum Rotation {
    Left,
    Right,
}

#[derive(Clone, Copy, Debug)]
pub enum Direction {
    Forward,
    Right,
    Left,
}

// needed for current direction
pub enum CardinalPoints {
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
                    0 => Direction::Forward,
                    2 => Direction::Left,
                    _ => Direction::Right,
                })
                .collect(),
        }
    }
}

// 2 => Direction::Backwards,

#[derive(Clone, Debug)]
pub struct ProteinConformation {
    pub directions: Vec<Direction>,
}

impl ProteinConformation {
    pub fn positions(&self) -> Vec<Pos> {
        let (mut x, mut y) = (0, 0);
        let mut result = Vec::from([(x, y)]);

        let mut card = CardinalPoints::North;

        use Direction as D;

        // I punti cardinali fanno pensare a qualcosa di fisso
        // sarebbe meglio dire forward, backward, left, right
        // forward
        // backward
        // left
        // right

        // direction = match (direction, self.directions[0]) {
        //     (D::Forward, d) => d,
        //     (D::Backwards, D::Backwards) => D::Forward,
        //     // (D::North, D::East) => D::East,
        //     // (D::North, D::South) => D::South,
        //     // (D::North, D::West) => D::West,
        //     _ => D::Forward,
        // };

        for amino_acid in 0..=self.directions.len() - 2 {
            (x, y) = match self.directions[amino_acid] {
                Direction::Forward => (x, y - 1),
                Direction::Right => (x + 1, y),
                // Direction::Backwards => (x, y + 1),
                Direction::Left => (x - 1, y),
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

        for amino_acid in action.amino_acid + 1..self.len() {
            new_conformation.directions[amino_acid] =
                match (&state.directions[amino_acid], &action.rotation) {
                    (Direction::Forward, Rotation::Left) => Direction::Left,
                    (Direction::Forward, Rotation::Right) => Direction::Right,
                    (Direction::Backwards, Rotation::Left) => Direction::Right,
                    (Direction::Backwards, Rotation::Right) => Direction::Left,
                    (Direction::Right, Rotation::Left) => Direction::Forward,
                    (Direction::Right, Rotation::Right) => Direction::Backwards,
                    (Direction::Left, Rotation::Left) => Direction::Backwards,
                    (Direction::Left, Rotation::Right) => Direction::Forward,
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
        self.contacts - self.overlaps * 2
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

// self.overlaps == other.overlaps && self.contacts == other.contacts

// impl PartialEq for Utility {
//     fn eq(&self, other: &Self) -> bool {
//         self.overlaps == other.overlaps && self.contacts == other.contacts
//     }
// }

impl Heuristic for Local2dProteinFolding {
    type Value = Utility;

    fn heuristic(&self, state: &Self::State) -> Self::Value {
        // let (x, y) = (0, 0);

        // let mut overlaps = 0;
        let mut contacts = 0;

        let conf = state.positions();

        // let mut positions = BTreeSet::from([(x, y)]);
        // let mut energy = 0;

        // println!("{:?}", conf);
        for (i, &(u_x, u_y)) in conf.iter().enumerate() {
            for (j, &(v_x, v_y)) in conf[..0.max(i.abs_diff(1))].iter().enumerate() {
                if let (Alphabet::H, Alphabet::H) = (&self[i], &self[j]) {
                    if u_x.abs_diff(v_x) + u_y.abs_diff(v_y) == 1 {
                        contacts += 1;
                    }
                }
            }
        }

        let mut set = BTreeSet::new();
        for pos in conf {
            set.insert(pos);
        }
        // println!("{:?}", set);
        let overlaps = (self.len() - set.len()) as i32;

        Utility { contacts, overlaps }
        // contacts - overlaps * 2
    }
}

impl Mutable for Local2dProteinFolding {
    fn mutate(&self, state: Self::State, rng: &mut impl rand::Rng) -> Self::State {
        let mut state = state;
        state.directions[rng.random_range(0..self.len())] = match rng.random_range(0..4) {
            0 => Direction::Forward,
            1 => Direction::Right,
            2 => Direction::Backwards,
            _ => Direction::Left,
        };

        state
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
            child.directions[amino_acid] = r.directions[amino_acid].clone();
        }

        child
    }
}

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

// let directions = (0..self.len())
//     .map(|_| match rng.random_range(0..4) {
//         0 => Direction::North,
//         1 => Direction::East,
//         2 => Direction::South,
//         _ => Direction::West,
//     })
//     .collect();
