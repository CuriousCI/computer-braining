use ai::problem::TransitionModel;

enum Alphabet {
    /// hydrophobic amino-acids
    H,
    /// hydrophilic amino-acids (polar)
    P,
}

type Sequence = Vec<Alphabet>; // length n
type Pos = (i64, i64);

pub struct ProteinFolding {
    sequence: Sequence,
}

impl TransitionModel for ProteinFolding {
    type State = Vec<Pos>;
    type Action = (usize, Pos);

    fn new_state(&self, state: &Self::State, action: &Self::Action) -> Self::State {
        todo!()
    }
}

// basically, save the list of position for all items in the sequence

// grid [-(n-1), (n-1)]
