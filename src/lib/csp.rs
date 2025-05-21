use std::{
    collections::{BTreeSet, VecDeque},
    path::Iter,
};

pub type Assignment = Vec<Option<usize>>;

pub type Domain = BTreeSet<usize>;

pub struct Constraint(pub Vec<usize>, pub Box<dyn Fn(&Assignment) -> bool>);

pub enum Simple {
    Eq(usize),
    Neq(usize),
    Lt(usize),
    Leq(usize),
    Gt(usize),
    Geq(usize),
}

pub enum ConstraintType {
    Simple(Box<dyn Fn(&Assignment) -> usize>, Simple),
    Predicate(Constraint),
}

// a constraint at this point is some kind of function of the values, and use it to compare, or
// just return the value
// at this point, how do I get the variables without using Some() etc...?
// ordine lessicografico minore... hm...

#[derive(Default)]
pub struct Description {
    domains: Vec<Domain>,
    general: Vec<Constraint>,
    unary: Vec<Constraint>,
}

impl Extend<Domain> for Description {
    fn extend<T: IntoIterator<Item = Domain>>(&mut self, iter: T) {
        self.domains.extend(iter)
    }
}

impl Extend<Constraint> for Description {
    fn extend<T: IntoIterator<Item = Constraint>>(&mut self, iter: T) {
        let (unary, general): (Vec<_>, Vec<_>) =
            iter.into_iter().partition(|Constraint(v, _)| v.len() == 1);

        self.unary.extend(unary);
        self.general.extend(general);
    }
}

pub struct CSP {
    domains: Vec<Domain>,
    general: Vec<Constraint>,
    unary: Vec<Constraint>,
    hypergraph: Vec<Vec<usize>>,
}

impl From<Description> for CSP {
    fn from(value: Description) -> Self {
        Self {
            domains: value.domains,
            general: value.general,
            unary: value.unary,
            hypergraph: vec![],
        }
    }
}

impl CSP {
    // devo cancellare i constraint unari, non posso avere un vec di constraint... o per lo
    // meno non vederli direttamente

    pub fn make_node_consistent(&mut self) -> bool {
        let mut assignment = vec![None; self.domains.len()];

        for Constraint(vars, c) in self.unary.iter() {
            let var = vars[0];
            let mut removed = vec![];

            for &val in self.domains[var].iter() {
                assignment[var] = Some(val);
                if !c(&assignment) {
                    removed.push(val);
                }
            }

            if self.domains[var].len() == removed.len() {
                return false;
            }

            for val in removed {
                self.domains[var].remove(&val);
            }

            assignment[var] = None;
        }

        println!("{:?}", self.domains);
        true
    }

    // println!("{:?}", self.domains);
    // if vars.len() == 1 {
    // }

    pub fn gac_3(&mut self) -> bool {
        let mut queue = VecDeque::new();

        for c in self.general.iter() {
            for &var in c.0.iter() {
                queue.push_back((var, c));
            }
        }

        while let Some((var, c)) = queue.pop_front() {
            let mut removed = vec![];

            let other_vars: Vec<_> = c.0.iter().filter(|&&var_2| var_2 != var).collect();
            let mut assignment = vec![None; self.domains.len()];
            for &val in self.domains[var].iter() {
                assignment[var] = Some(val);
                for &&other_var in other_vars.iter() {
                    assignment[other_var] = self.domains[other_var].first().copied();
                }

                let mut satisfied = false;

                for combination in
                    self.combinations(other_vars.clone().into_iter().copied().collect())
                {
                    // println!("{:?}", combination);
                    for (var, val_2) in combination {
                        assignment[var] = Some(val_2);
                    }

                    if c.1(&assignment) {
                        satisfied = true;
                        break;
                    }
                }

                if !satisfied {
                    removed.push(val);
                }
            }

            for val in removed.iter() {
                self.domains[var].remove(val);
            }

            if !removed.is_empty() {
                if self.domains[var].is_empty() {
                    return false;
                }

                for &other_var in other_vars {
                    queue.push_back((other_var, c));
                }
            }
        }

        true
    }

    fn combinations(&self, vars: Vec<usize>) -> Vec<Vec<(usize, usize)>> {
        if vars.is_empty() {
            vec![vec![]]
        } else {
            let mut combinations = vec![];

            let mut rest = vars.clone();
            let last = rest.pop().unwrap();

            for combination in self.combinations(rest) {
                for &val in self.domains[last].iter() {
                    let mut c = combination.clone();
                    c.push((last, val));
                    combinations.push(c);
                }
            }

            combinations
        }
    }

    // pub fn remove_inconsistencies(&mut self, var, c) -> bool {
    //     let mut removed_value = false;
    //
    //
    //     for val in self.domains[var] {}
    //
    //     removed_value
    // }

    pub fn backtracking(&self) -> Option<Assignment> {
        let mut stack: Vec<(usize, usize)> = Vec::new();

        if self.domains.is_empty() {
            return Some(vec![]);
        }

        for &val in self.domains[0].iter() {
            stack.push((0, val));
        }

        let mut assignment: Assignment = vec![None; self.domains.len()];

        while let Some((var, val)) = stack.pop() {
            assignment[var] = Some(val);

            for Constraint(_, constraint) in self.general.iter() {
                if !constraint(&assignment) {
                    assignment[var] = None;
                    break;
                }
            }

            if assignment[var].is_some() {
                if var == self.domains.len() - 1 {
                    return Some(assignment);
                } else {
                    for &val in self.domains[var + 1].iter() {
                        stack.push((var + 1, val));
                    }
                }
            }
        }

        None
    }

    fn steepest_descent(&self) {
        let assignment = [Some(3), Some(1), Some(4), Some(5), Some(2)];

        type Action = (usize, usize);

        let mut neighbourhood: Vec<Action> = vec![];

        for var in 0..assignment.len() {
            for &val in self.domains[var].iter() {}
        }

        let mut cost = 0;
        // il costo è la somma dei costi di tutte le variabili
        // il costo di una variabile è dato da
        // - f(X1, ..., X5) <= k   ->   costoA(Ci) = max(0, f(A) - k)... sostanzialmente quanto è distante da k
        // - f(X1, ..., X5) < k    ->   costoA(Ci) = max(0, f(A) - (k - 1))... come prima
        // - f(X1, ..., X5) >= k   ->   costoA(Ci) = max(0, k - f(A))... come prima
        // ...

        // uno deve proprio poter entrare nel vincolo e studiare come è fatto, ma a quel punto...
        // effettivamnte ha senso, posso distinguere i vincoli per tipo
    }
}

// pub fn add_variable(&mut self, domain: Domain) {
//     self.domains.push(domain)
// }
//
// pub fn add_constraint(&mut self, constraint: Constraint) {
//     self.constraints.push(constraint)
// }

// list of variables
// - variable: domain
// - arrays of variables
// - iperarchi
// - axum magic parttern to define constraints?
//
//
// a constraint is like a function, that given a value for x, a value for y returns either false or true
// NO, a constraint is a function that given a partial assignment returns either true or false

// hm... domini tutti diversi? Ristretti da un tipo... o un set di valori

// hypergraph: Vec<Vec<usize>>,

// let mut is_feasable = false;
// if !removed_vals.is_empty() {
//     is_feasable = true;
// }
// is_feasable

// for var in 0..self.domains.len() {
// }
// let mut domains = self.domains.clone();

// self.domains[var].remove(&val);
// assignment[var]
// if constraint value satisfies constraint keep it , I need some fake assignment

// for constraint in self.constraints {
//
// }
