use std::{collections::HashMap, num::NonZeroUsize};

pub enum Literal<T> {
    Positive(T),
    Negative(T),
}

impl<T> From<T> for Literal<T> {
    fn from(value: T) -> Self {
        Literal::Positive(value)
    }
}

impl<T> Literal<T> {
    fn map<U>(self, f: impl FnOnce(T) -> U) -> Literal<U> {
        match self {
            Literal::Positive(letter) => Literal::Positive(f(letter)),
            Literal::Negative(letter) => Literal::Negative(f(letter)),
        }
    }
}

type Clause = Vec<Literal<NonZeroUsize>>;

pub struct Encoder<T> {
    letter_to_encoding: HashMap<T, NonZeroUsize>,
    clauses: Vec<Clause>,
}

impl<T> Encoder<T> {
    pub fn new() -> Self {
        Self {
            ..Default::default()
        }
    }
}

impl<T> Default for Encoder<T> {
    fn default() -> Self {
        Self {
            letter_to_encoding: Default::default(),
            clauses: Default::default(),
        }
    }
}

impl<T: Eq + std::hash::Hash> Encoder<T> {
    pub fn insert_clause(&mut self, clause: Vec<Literal<T>>) {
        self.clauses.push(
            clause
                .into_iter()
                .map(|literal| {
                    let next_letter_encoding =
                        unsafe { NonZeroUsize::new_unchecked(self.letter_to_encoding.len() + 1) };

                    literal.map(|t| {
                        *self
                            .letter_to_encoding
                            .entry(t)
                            .or_insert(next_letter_encoding)
                    })
                })
                .collect(),
        );
    }
}

// -X, Y, Z
// X and Y -> Z or W
// ALO
// AMO
// alldiff
#[macro_export]
macro_rules! clause {
    () => {};
}

pub type DIMACS = String;
pub type EncodingToLetter<T> = Vec<T>;

impl<T: std::fmt::Debug + Clone> Encoder<T> {
    pub fn to_dimacs(&self) -> (DIMACS, EncodingToLetter<T>) {
        let letters_count = self.letter_to_encoding.len();

        let mut encoding_to_letter = vec![None; letters_count];
        for (letter, &encoding) in self.letter_to_encoding.iter() {
            encoding_to_letter[usize::from(encoding) - 1usize] = Some(letter.to_owned())
        }

        let encoding_to_letter = encoding_to_letter.into_iter().flatten().collect();

        let mut dimacs_encoding = String::new();
        dimacs_encoding.push_str(&format!("p cnf {letters_count} {}\n", self.clauses.len()));
        dimacs_encoding.push_str(
            &self
                .clauses
                .iter()
                .map(|clause| {
                    format!(
                        "{}0\n",
                        clause
                            .iter()
                            .map(|literal| match literal {
                                Literal::Positive(letter) => format!("{letter} "),
                                Literal::Negative(letter) => format!("-{letter} "),
                            })
                            .collect::<String>()
                    )
                })
                .collect::<String>(),
        );

        (dimacs_encoding, encoding_to_letter)
    }
}

// propositional_letters[id.into() - 1usize] = Some(propositional_letter.clone());
// let clause: String = clause
//     .iter()
//     .map(|literal| match literal {
//         Literal::Positive(letter) => format!("{letter} "),
//         Literal::Negative(letter) => format!("-{letter} "),
//     })
//     .collect();
//
// format!("{clause}0\n")
// for clause in self.clauses.iter() {
//     let clause: String = clause
//         .iter()
//         .map(|literal| match literal {
//             Literal::Positive(letter) => format!("{letter} "),
//             Literal::Negative(letter) => format!("-{letter} "),
//         })
//         .collect();
//
//     dimacs_encoding.push_str(&format!("{clause}0\n"));
// }

// fn map<U, F: FnOnce(T) -> U>(self, f: F) -> Literal<U> {
//     match self {
//         Literal::Positive(t) => Literal::Positive(f(t)),
//         Literal::Negative(t) => Literal::Negative(f(t)),
//     }
// }
