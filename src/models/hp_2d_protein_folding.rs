use std::{ops::Deref, rc::Rc};

use ai::problem::{Exploration, Goal, Heuristic, Problem, Transition};

#[derive(Clone, Debug)]
pub enum Alphabet {
    H,
    P,
}

pub type Sequence = Vec<Alphabet>;

pub type Energy = i64;

pub struct Protein(Sequence);

pub type Pos = (i64, i64);

#[derive(Clone, Hash, Eq, PartialEq, Ord, PartialOrd)]
pub struct AminoAcid {
    pub pos: Pos,
    pub prev: Option<Rc<AminoAcid>>,
    pub depth: usize,
}

impl Protein {
    pub fn new(sequence: Sequence) -> Self {
        Self(sequence)
    }
}

impl Deref for Protein {
    type Target = Sequence;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl Problem for Protein {
    type State = Rc<AminoAcid>;
}

impl Transition for Protein {
    type Action = Pos;

    fn new_state(&self, amino_acid: &Self::State, &pos: &Self::Action) -> Self::State {
        Rc::new(AminoAcid {
            pos,
            prev: Some(amino_acid.clone()),
            depth: amino_acid.depth + 1,
        })
    }
}

impl Goal for Protein {
    fn is_goal(&self, amino_acid: &Self::State) -> bool {
        amino_acid.depth == self.len() - 1
    }
}

impl Heuristic<Energy> for Protein {
    fn heuristic(&self, amino_acid: &Self::State) -> Energy {
        // Questa info si può portare dietro nello stato
        // - costa poco memorizzarla
        // - evito O(n) calcoli

        let mut min_x = amino_acid.pos.0;
        let mut max_x = amino_acid.pos.0;
        let mut min_y = amino_acid.pos.1;
        let mut max_y = amino_acid.pos.1;

        let mut prev = amino_acid.prev.as_ref();
        while let Some(p) = prev {
            if let Alphabet::H = self[p.depth] {
                min_x = min_x.min(p.pos.0);
                max_x = max_x.max(p.pos.0);
                min_y = min_y.min(p.pos.1);
                max_y = max_y.max(p.pos.1);
            }

            prev = p.prev.as_ref();
        }

        ((max_x - min_x) + (max_y - min_y)) / 3
    }
}

// next position, nah
// direction (maybe? Still hard to check for translations)
// impl Eq for AminoAcid, s.t. two amino acids are equal if they have the same directions, but rotated
// rotation... what does rotation mean in this context?
// can I prevent a duplicating move before doing it?

impl Exploration<Energy> for Protein {
    fn expand(&self, amino_acid: &Self::State) -> impl Iterator<Item = (Self::Action, Energy)> {
        let (x, y) = amino_acid.pos;

        let actions = if amino_acid.depth == 0 {
            vec![(x, y + 1)]
        } else if amino_acid.depth == 1 {
            vec![(x + 1, y), (x, y + 1)]
        } else {
            let mut result = vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)];
            if let Some(parent) = amino_acid.prev.as_ref() {
                if let Some(grandpa) = parent.prev.as_ref() {
                    let (p_x, p_y) = parent.pos;
                    let (g_x, g_y) = grandpa.pos;

                    result = match (x - p_x, p_x - g_x, y - p_y, p_y - g_y) {
                        (1, 1, _, _) => vec![(x + 1, y), (x, y + 1)],
                        (-1, -1, _, _) => vec![(x - 1, y), (x, y - 1)],
                        (_, _, 1, 1) => vec![(x, y + 1), (x + 1, y)],
                        (_, _, -1, -1) => vec![(x, y - 1), (x - 1, y)],
                        _ => vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)],
                    }
                }
            }

            result
        };

        actions
            .into_iter()
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
