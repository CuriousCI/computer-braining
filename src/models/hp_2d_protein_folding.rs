use std::{ops::Deref, rc::Rc};

use ai::problem::{Exploration, Goal, Heuristic, Problem, Transition};

#[derive(Clone, Debug)]
pub enum Alphabet {
    H,
    P,
}

pub type Sequence = Vec<Alphabet>;
pub type Energy = i64;
pub type Pos = (i64, i64);

pub struct ProteinFolding(pub Sequence);

impl Deref for ProteinFolding {
    type Target = Sequence;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

#[derive(Clone, Hash, Eq, PartialEq, PartialOrd, Ord)]
pub struct AminoAcid {
    pub pos: Pos,
    pub prev: Option<Rc<AminoAcid>>,
    pub depth: usize,
}

impl Problem for ProteinFolding {
    type State = Rc<AminoAcid>;
}

impl Transition for ProteinFolding {
    type Action = Pos;

    fn new_state(&self, amino_acid: &Self::State, &pos: &Self::Action) -> Self::State {
        Rc::new(AminoAcid {
            pos,
            prev: Some(amino_acid.clone()),
            depth: amino_acid.depth + 1,
        })
    }
}

impl Heuristic<Energy> for ProteinFolding {
    fn heuristic(&self, _amino_acid: &Self::State) -> Energy {
        0
    }
}

impl Goal for ProteinFolding {
    fn is_goal(&self, amino_acid: &Self::State) -> bool {
        amino_acid.depth == self.len() - 1
    }
}

impl Exploration<Energy> for ProteinFolding {
    fn expand(&self, amino_acid: &Self::State) -> impl Iterator<Item = (Self::Action, Energy)> {
        let (x, y) = amino_acid.pos;

        [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
            .into_iter()
            .filter(|(x, y)| x >= &0 && y >= &0)
            .filter(|pos| {
                let mut prev = amino_acid.prev.as_ref();
                while let Some(p) = prev {
                    if &p.pos == pos {
                        return false;
                    }
                    prev = p.prev.as_ref();
                }
                true
            })
            .map(|pos| match self[amino_acid.depth + 1] {
                Alphabet::P => (pos, 0),
                Alphabet::H => {
                    let mut count = 0;

                    let mut prev = amino_acid
                        .prev
                        .as_ref()
                        .and_then(|amino_acid| amino_acid.prev.as_ref());

                    while let Some(p) = prev {
                        if let Alphabet::H = self[p.depth] {
                            if p.pos.0.abs_diff(pos.0) + p.pos.1.abs_diff(pos.1) == 1 {
                                count += 1;
                            }
                        }
                        prev = p.prev.as_ref();
                    }
                    (pos, 3 - count)
                }
            })
            .collect::<Vec<_>>()
            .into_iter()
    }
}
