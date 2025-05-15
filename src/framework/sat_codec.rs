use serde::{Deserialize, Serialize};
use std::collections::HashMap;

pub struct Encoder<T> {
    map: HashMap<T, usize>,
    clauses: Vec<Clause>,
}

impl<T> Encoder<T> {
    pub fn new() -> Self {
        Self {
            map: Default::default(),
            clauses: Default::default(),
        }
    }

    pub fn clause_builder(self) -> ClauseBuilder<T> {
        ClauseBuilder {
            encoder: self,
            clause: Default::default(),
        }
    }
}

// TODO: return a printable string
impl<T: std::fmt::Debug> Encoder<T> {
    pub fn end(self) {
        let variables_number = self.map.len();
        let serializable_map: HashMap<String, _> = self
            .map
            .into_iter()
            .map(|(k, v)| (format!("{:?}", k), v))
            .collect();

        println!("c {:?}", serde_json::to_string(&serializable_map).unwrap());
        println!("p cnf {variables_number} {}", self.clauses.len());
        for clause in self.clauses {
            let mut clause: String = clause
                .into_iter()
                .map(|literal| match literal {
                    Literal::Pos(l) => format!("{l} "),
                    Literal::Neg(l) => format!("-{l} "),
                })
                .collect();
            clause.push('0');
            println!("{clause}")
        }
    }
}

impl<T> Default for Encoder<T> {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(Serialize, Deserialize)]
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

type Clause = Vec<Literal<usize>>;

pub struct ClauseBuilder<T> {
    encoder: Encoder<T>,
    clause: Clause,
}

impl<T> ClauseBuilder<T>
where
    T: std::cmp::Eq + std::hash::Hash + Serialize,
{
    pub fn add<U: Into<Literal<T>>>(&mut self, literal: U) {
        let next_id = self.encoder.map.len() + 1;
        let literal = literal
            .into()
            .map(|t| *self.encoder.map.entry(t).or_insert(next_id));

        self.clause.push(literal);
    }

    pub fn end(mut self) -> Encoder<T> {
        self.encoder.clauses.push(self.clause);
        self.encoder
    }
}
