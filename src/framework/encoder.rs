use serde::{Deserialize, Serialize};
use std::collections::HashMap;

type Clause = Vec<Literal<usize>>;

pub struct EncoderSAT<T> {
    map: HashMap<T, usize>,
    clauses: Vec<Clause>,
}

pub struct DecoderSAT<T> {
    vars: Vec<T>,
}

// pub struct Clause(Clause2);
// impl <T> DecoderSAT<T> {
// }

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

// TODO: return a printable string
impl<T: std::fmt::Debug + Clone + Serialize> EncoderSAT<T> {
    pub fn end(self) {
        let variables_number = self.map.len();

        let mut variables = vec![None; variables_number];
        for (k, v) in self.map {
            variables[v - 1] = Some(k);
        }

        println!("c {:?}", serde_json::to_string(&variables).unwrap());
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

// let serializable_map: HashMap<String, _> = self
//     .map
//     .into_iter()
//     .map(|(k, v)| (format!("{:?}", k), v))
//     .collect();

// println!("c {:?}", serde_json::to_string(&serializable_map).unwrap());

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

// pub fn clause(self) -> ClauseBuilder<T> {
//     ClauseBuilder {
//         encoder: self,
//         clause: Default::default(),
//     }
// }

// impl<T, const N: usize> From<[T; N]> for Vec<T>

// pub struct ClauseBuilder<T> {
//     encoder: EncoderSAT<T>,
//     clause: Clause,
// }
//
// impl<T> ClauseBuilder<T>
// where
//     T: std::cmp::Eq + std::hash::Hash + Serialize,
// {
//     pub fn add<U: Into<Literal<T>>>(&mut self, literal: U) {
//         let next_id = self.encoder.map.len() + 1;
//         let literal = literal
//             .into()
//             .map(|t| *self.encoder.map.entry(t).or_insert(next_id));
//
//         self.clause.push(literal);
//     }
//
//     pub fn end(mut self) -> EncoderSAT<T> {
//         self.encoder.clauses.push(self.clause);
//         self.encoder
//     }
// }
