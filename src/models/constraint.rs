use ai::problem::{Heuristic, Local, Problem, Transition};

pub struct Constraints;

impl Problem for Constraints {
    type State = [i64; 5];
}

impl Transition for Constraints {
    type Action = (usize, i64);

    fn new_state(&self, state: &Self::State, &(var, val): &Self::Action) -> Self::State {
        let mut new_state = *state;
        new_state[var] = val;
        new_state
    }
}

impl Heuristic<usize> for Constraints {
    fn heuristic(&self, x: &Self::State) -> usize {
        let cost = (0.max(-x[0] + x[2] + 1)
            + 0.max(x[1] - x[2])
            + 0.max(x[2].pow(2) + x[3].pow(3) - 15)
            + 0.max(-x[4] + 3)
            + 0.max(-x[0] - x[4] + 3)) as usize;

        println!("{:?} - {:?}", x, cost);
        cost
    }
}

impl Local for Constraints {
    fn expand(&self, state: &Self::State) -> impl Iterator<Item = Self::Action> {
        let mut actions = vec![];
        for (var, curr_val) in state.iter().enumerate() {
            for val in 0..5 {
                if &val != curr_val {
                    actions.push((var, val));
                }
            }
        }

        println!("{:?}", actions);

        actions.into_iter()
    }
}

// X1 > X3
// X2 <= X3
// X3^2 + X4^2 <= 15
// X5 >= 3
// X1 + X5 >= 3

// - X1 + X3 <= -1
// X2 - X3 <= 0
// X3^2 + X4^2 <= 15
// - X5 <= -3
// - X1 - X5 <= -3
