use std::collections::BTreeSet;

use ai::framework::problem::{Heuristic, Problem};

use super::{Alphabet, Pos, Sequence};

pub struct LocalProteinFolding {
    sequence: Sequence,
    actions: Vec<Fold>,
}

impl LocalProteinFolding {
    pub fn new(sequence: Sequence) -> Self {
        let actions = (0..sequence.len() - 1)
            .flat_map(|amino_acid| {
                [
                    Fold {
                        amino_acid,
                        turn: Turn::Left,
                    },
                    Fold {
                        amino_acid,
                        turn: Turn::Right,
                    },
                ]
            })
            .collect();

        Self { sequence, actions }
    }
}

impl std::ops::Deref for LocalProteinFolding {
    type Target = Sequence;

    fn deref(&self) -> &Self::Target {
        &self.sequence
    }
}

impl rand::distr::Distribution<Conformation> for LocalProteinFolding {
    fn sample<R: rand::Rng + ?Sized>(&self, rng: &mut R) -> Conformation {
        let directions = (0..self.len())
            .map(|_| match rng.random_range(0..4) {
                0 => Direction::North,
                1 => Direction::East,
                2 => Direction::South,
                _ => Direction::West,
            })
            .collect();

        Conformation { directions }
    }
}

#[derive(Clone, Debug)]
pub struct Conformation {
    pub directions: Vec<Direction>,
}

impl Conformation {
    pub fn positions(&self) -> Vec<Pos> {
        let (mut x, mut y) = (0, 0);
        let mut result = Vec::from([(x, y)]);

        for amino_acid in 0..=self.directions.len() - 2 {
            (x, y) = match self.directions[amino_acid] {
                Direction::North => (x, y - 1),
                Direction::East => (x + 1, y),
                Direction::South => (x, y + 1),
                Direction::West => (x - 1, y),
            };
            result.push((x, y));
        }

        result
    }
}

// println!("({x}, {y})");
// println!("{:?}", result);

#[derive(Clone)]
pub enum Turn {
    Left,
    Right,
}

#[derive(Clone, Debug)]
pub enum Direction {
    North,
    East,
    South,
    West,
}

#[derive(Clone)]
pub struct Fold {
    pub turn: Turn,
    pub amino_acid: usize,
}

impl Problem for LocalProteinFolding {
    type State = Conformation;
    type Action = Fold;

    fn actions(&self, _: &Self::State) -> impl Iterator<Item = Self::Action> {
        self.actions.clone().into_iter()
    }

    fn result(&self, state: &Self::State, action: &Self::Action) -> Self::State {
        let mut new_conformation = state.clone();

        for amino_acid in action.amino_acid + 1..self.len() {
            new_conformation.directions[amino_acid] =
                match (&state.directions[amino_acid], &action.turn) {
                    (Direction::North, Turn::Left) => Direction::West,
                    (Direction::North, Turn::Right) => Direction::East,
                    (Direction::South, Turn::Left) => Direction::East,
                    (Direction::South, Turn::Right) => Direction::West,
                    (Direction::East, Turn::Left) => Direction::North,
                    (Direction::East, Turn::Right) => Direction::South,
                    (Direction::West, Turn::Left) => Direction::South,
                    (Direction::West, Turn::Right) => Direction::North,
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

impl Heuristic for LocalProteinFolding {
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
