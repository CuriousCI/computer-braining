use std::{ops::Deref, rc::Rc};

use ai::problem::{Exploration, Goal, Heuristic, Problem, Transition};

#[derive(Clone, Debug)]
pub enum Alphabet {
    H,
    P,
}

pub type Sequence = Vec<Alphabet>;

pub type Energy = i16;

pub type Pos = (i16, i16);

pub struct Protein(Sequence);

#[derive(Hash, Eq, PartialEq, Default)]
pub struct AminoAcid {
    pos: Pos,
    prev: Option<Rc<AminoAcid>>,
    depth: usize,
    first_turn: bool,
    // heuristic: usize,
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
            first_turn: amino_acid.first_turn || pos.0 != 0,
        })
    }
}

impl Goal for Protein {
    fn is_goal(&self, amino_acid: &Self::State) -> bool {
        amino_acid.depth + 1 == self.len()
    }
}

impl Heuristic<Energy> for Protein {
    fn heuristic(&self, amino_acid: &Self::State) -> Energy {
        // 3 non made contacts only for the first and final
        // amminoacid, otherwise an amminoacid in the middle can make
        // only two contacts
        //
        // heuristic... think of it as
        // "minimize the number of 'not made contacts'"
        //
        // given a conformation, the heuristic is the
        // "number of contacts I don't expect to make"
        // (and it should be smaller than the actual
        // contacts I don't make, so I have to be certain
        // that a certain contact can be made... I also
        // need to check I don't count twice the same contact,
        // or at least consider the fact that they are mutually exclusive,
        // maybe a contact can't be made if ANY of the previous already assigned
        // proteins can't be reached)
        // at this point the problem is the same, but inverted, how can I simplify it?
        // and in some way keep it in the state (with a low overhead) without needing
        // to recalculate again? (does it depend on the whole protein or just the
        // new amminoacid added?)
        //
        // Given an H not yet assigned, a contact can be made iff
        // - I have an H with an even distance
        // - I have enough spots for it
        // Not enough... there's a limited number of H
        // I can consider for "non made contacts" at most the 2 previous candidates
        // So I can basically look at the last 3 H at even distance
        // from the current H (not assigned), and check if a contact can be made for
        // those amminoacids, and it can't be made if
        // - the distance needed to touch is greater than 1/2 the distance
        // - the amminoacid has no empty neighbours covered
        //
        // ...thechnically one should store the empty
        // precalc the "next H"

        0

        // Questa info si può portare dietro nello stato
        // - costa poco memorizzarla
        // - evito O(n) calcoli

        // si può calcolare in modo incrementale?
        // la calcolo una volta all'inizio, e poi la espando,
        // tecnicamente mi devo mantenere gli estremi, sia in verticale sia in orizzontale
        // praticamente non serve più di tanto

        // let mut h = 0;
        //
        // let mut grandpa = amino_acid.prev.as_ref().and_then(|a| a.prev.as_ref());
        // let mut curr = Some(amino_acid);
        //
        // while let (Some(p), Some(c)) = (grandpa, curr) {
        //     if let (Alphabet::H, Alphabet::H) = (&self[p.depth], &self[c.depth]) {
        //         if p.pos.0.abs_diff(c.pos.0) + p.pos.1.abs_diff(c.pos.1) > 1 {
        //             h += 1;
        //         }
        //     }
        //
        //     grandpa = p.prev.as_ref();
        //     curr = c.prev.as_ref();
        // }
        //
        // -h
    }
}

impl Exploration<Energy> for Protein {
    fn expand(&self, amino_acid: &Self::State) -> impl Iterator<Item = (Self::Action, Energy)> {
        let (x, y) = amino_acid.pos;

        let actions = if amino_acid.depth == 0 {
            vec![(x, y + 1)]
        } else if !amino_acid.first_turn {
            vec![(x + 1, y), (x, y + 1)]
        } else {
            vec![(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
        };

        actions
            .into_iter()
            .filter(|pos| {
                let mut prev = amino_acid.prev.as_ref();
                while let Some(prev_amino_acid) = prev {
                    if &prev_amino_acid.pos == pos {
                        return false;
                    }

                    prev = prev_amino_acid.prev.as_ref();
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
                    (pos, if amino_acid.depth == 0 { 3 } else { 2 } - count)
                    // (pos, 3 - count)
                }
            })
            .collect::<Vec<_>>()
            .into_iter()
    }
}

// for i in 0..self.len() - 2 {
//     match (self.get(i), self.get(i + 2)) {
//         (Some(&Alphabet::H), Some(&Alphabet::H)) => {
//             if
//         }
//         _ => (),
//     }
// }
// let mut min_x = amino_acid.pos.0;
// let mut max_x = amino_acid.pos.0;
// let mut min_y = amino_acid.pos.1;
// let mut max_y = amino_acid.pos.1;
//
// let mut prev = amino_acid.prev.as_ref();
// while let Some(p) = prev {
//     if let Alphabet::H = self[p.depth] {
//         min_x = min_x.min(p.pos.0);
//         max_x = max_x.max(p.pos.0);
//         min_y = min_y.min(p.pos.1);
//         max_y = max_y.max(p.pos.1);
//     }
//
//     prev = p.prev.as_ref();
// }
//
// ((max_x - min_x) + (max_y - min_y)) / 3
