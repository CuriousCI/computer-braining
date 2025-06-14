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
    map: HashMap<T, NonZeroUsize>,
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
            map: Default::default(),
            clauses: Default::default(),
        }
    }
}

impl<T: Eq + std::hash::Hash> Encoder<T> {
    pub fn add(&mut self, clause: Vec<Literal<T>>) {
        self.clauses.push(
            clause
                .into_iter()
                .map(|literal| {
                    let next_id = unsafe { NonZeroUsize::new_unchecked(self.map.len() + 1) };
                    literal.map(|t| *self.map.entry(t).or_insert(next_id))
                })
                .collect(),
        );
    }
}

// maybe I should use a wrapper type, or give it more structure, like "variables num" etc...
pub type DIMACS = String;

impl<T: std::fmt::Debug + Clone> Encoder<T> {
    pub fn to_dimacs(&self) -> (DIMACS, Vec<T>) {
        let propositional_letters_count = self.map.len();

        let mut propositional_letters = vec![None; propositional_letters_count];
        for (propositional_letter, id) in self.map.iter() {
            // propositional_letters[id.into() - 1usize] = Some(propositional_letter.clone());
        }

        let propos_letters = propositional_letters.into_iter().flatten().collect();
        let mut dimacs_encoding = String::new();

        dimacs_encoding.push_str(&format!(
            "p cnf {propositional_letters_count} {}\n",
            self.clauses.len()
        ));

        for clause in self.clauses.iter() {
            let clause: String = clause
                .iter()
                .map(|literal| match literal {
                    Literal::Positive(l) => format!("{l} "),
                    Literal::Negative(l) => format!("-{l} "),
                })
                .collect();

            dimacs_encoding.push_str(&format!("{clause}0\n"));
        }

        (dimacs_encoding, propos_letters)
    }
}

// fn map<U, F: FnOnce(T) -> U>(self, f: F) -> Literal<U> {
//     match self {
//         Literal::Positive(t) => Literal::Positive(f(t)),
//         Literal::Negative(t) => Literal::Negative(f(t)),
//     }
// }
