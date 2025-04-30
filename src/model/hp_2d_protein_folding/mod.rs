pub mod local_search;
pub mod search;

#[derive(Clone, Debug)]
pub enum Alphabet {
    H,
    P,
}

pub type Sequence = Vec<Alphabet>;

pub type Pos = (i16, i16);
