use std::{cmp::Reverse, ops::Add};

use ai::problem::{Exploration, Goal, TransitionModel, Utility};

#[derive(Clone, Debug)]
pub enum Alphabet {
    H,
    P,
}

pub type Sequence = Vec<Alphabet>;
pub type Pos = (i64, i64);
pub type Conformation = Vec<Pos>;

#[derive(Default, Clone, PartialEq, Eq, Ord, PartialOrd, Debug)]
pub struct Energy(Reverse<usize>);

impl Add for Energy {
    type Output = Energy;

    fn add(self, rhs: Self) -> Self::Output {
        Energy(Reverse(self.0.0 + rhs.0.0))
    }
}

pub struct ProteinFolding {
    sequence: Sequence,
}

impl ProteinFolding {
    pub fn new(sequence: Sequence) -> Self {
        Self { sequence }
    }
}

impl TransitionModel for ProteinFolding {
    type State = Conformation;
    type Action = Pos;

    fn new_state(&self, conformation: &Self::State, &pos: &Self::Action) -> Self::State {
        let mut new_conformation = conformation.clone();
        new_conformation.push(pos);
        new_conformation
    }
}

impl Utility<Energy> for ProteinFolding {
    fn utility(&self, _conformation: &Self::State) -> Energy {
        Energy(Reverse(0))
    }
}

//let mut contacts = 0;
//
//for (i, (x_i, y_i)) in conformation.iter().enumerate() {
//    for &(x_j, y_j) in conformation.iter().skip(i + 1) {
//        if x_i.abs_diff(x_j) == 1 || y_i.abs_diff(y_j) == 1 {
//            contacts += 1;
//        }
//    }
//}
//
//Energy(Reverse(contacts))
// quanti vicini liberi hanno i punti di tipo H?
//
//let mut free = 0;
//
//for (i, &(x, y)) in conformation.iter().enumerate() {
//    if let Alphabet::H = self.sequence[i] {
//        for (n_x, n_y) in [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)] {
//            if conformation
//                .iter()
//                .all(|&(p_x, p_y)| p_x != n_x || p_y != n_y)
//            {
//                free += 1;
//            }
//        }
//    }
//}
//
//Energy(Reverse(contacts + free))

//let mut dist = 0;
//
//for (x, y) in conformation {
//    dist += x.unsigned_abs() as usize + y.unsigned_abs() as usize;
//}

impl Goal for ProteinFolding {
    fn is_goal(&self, conformation: &Self::State) -> bool {
        conformation.len() == self.sequence.len()
    }
}

impl Exploration<Energy> for ProteinFolding {
    fn expand(&self, conformation: &Self::State) -> impl Iterator<Item = (Self::Action, Energy)> {
        let res = match conformation.last() {
            Some(&(x, y)) => [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
                .into_iter()
                .filter(|(x, y)| conformation.iter().all(|(p_x, p_y)| p_x != x || p_y != y))
                .map(|pos| match self.sequence[conformation.len()] {
                    Alphabet::P => (pos, Energy(Reverse(0))),
                    Alphabet::H => {
                        let mut count = 0;

                        for (i, (p_x, p_y)) in conformation.iter().enumerate() {
                            if p_x.abs_diff(pos.0) + p_y.abs_diff(pos.0) == 1 {
                                if let Alphabet::H = self.sequence[i] {
                                    count += 1;
                                }
                            }
                        }

                        if conformation.len() > 1 {
                            if let Alphabet::H = self.sequence[conformation.len() - 1] {
                                count -= 1;
                            }
                        }

                        (pos, Energy(Reverse(count)))
                    }
                })
                .collect(),
            None => vec![((0, 0), Energy(Reverse(0)))],
        };
        println!("{:?}", res);

        res.into_iter()
    }
}

// hydrophobic amino-acids
// hydrophilic amino-acids (polar)
// length n
//type Energy = Reverse<usize>;
//impl From<Vec> for  {
//    fn from(conformation: Conformation) -> Self {
//        Self { conformation }
//    }
//}

// neighbourhood of a node, so basically add a new node, if available
// when adding the new node, check the neighbourhood (still, would I need an adjency matrix?, how big would it be)
// precalculate bridges when creating new state, the just use the values to calculate the energy

//if conformation[prot_i].0.abs_diff(conformation[prot_j])
// basically, save the list of position for all items in the sequence

// grid [-(n-1), (n-1)]
