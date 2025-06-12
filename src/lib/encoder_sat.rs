use std::collections::HashMap;

type Clause = Vec<Literal<usize>>;

pub type DIMACS = String;

pub enum Literal<T> {
    Pos(T),
    Neg(T),
}

impl<T> Literal<T> {
    fn map<U, F>(self, f: F) -> Literal<U>
    where
        F: FnOnce(T) -> U,
    {
        match self {
            Literal::Pos(t) => Literal::Pos(f(t)),
            Literal::Neg(t) => Literal::Neg(f(t)),
        }
    }
}

impl<T> From<T> for Literal<T> {
    fn from(value: T) -> Self {
        Literal::Pos(value)
    }
}

pub struct EncoderSAT<T> {
    map: HashMap<T, usize>,
    clauses: Vec<Clause>,
}

impl<T> EncoderSAT<T> {
    pub fn new() -> Self {
        Self {
            ..Default::default()
        }
    }
}

impl<T: Eq + std::hash::Hash> EncoderSAT<T> {
    pub fn add(&mut self, clause: Vec<Literal<T>>) {
        self.clauses.push(
            clause
                .into_iter()
                .map(|literal| {
                    let next_id = self.map.len() + 1;
                    literal.map(|t| *self.map.entry(t).or_insert(next_id))
                })
                .collect(),
        );
    }
}

impl<T> Default for EncoderSAT<T> {
    fn default() -> Self {
        Self {
            map: Default::default(),
            clauses: Default::default(),
        }
    }
}

impl<T: std::fmt::Debug + Clone> EncoderSAT<T> {
    pub fn to_dimacs(&self) -> (DIMACS, Vec<T>) {
        let propositional_letters_count = self.map.len();

        let mut propositional_letters = vec![None; propositional_letters_count];
        for (propositional_letter, id) in self.map.iter() {
            propositional_letters[id - 1] = Some(propositional_letter.clone());
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
                    Literal::Pos(l) => format!("{l} "),
                    Literal::Neg(l) => format!("-{l} "),
                })
                .collect();

            dimacs_encoding.push_str(&format!("{clause}0\n"));
        }

        (dimacs_encoding, propos_letters)
    }
}
