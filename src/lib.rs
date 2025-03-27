pub mod csp;
pub mod frontiers;
pub mod iterative_search;
pub mod problem;
pub mod problem_solving_agent;

//if count > 0 {
//    println!("{:?}", count);
//}

//pub type Conformation = Vec<Pos>;

//if p.pos == pos {
//return false;
//}

//for (i, (c_x, c_y)) in amino_acid[..amino_acid.len() - 1].iter().enumerate() {
//    if c_x.abs_diff(pos.0) + c_y.abs_diff(pos.1) == 1 {
//        if let Alphabet::H = self.sequence[i] {
//            count += 1;
//        }
//    }
//}
//
//(pos, 100 - count)

//match conformation.last() {
//Some(&(x, y)) => [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//    .into_iter()
//    .filter(|(x, y)| amino_acid.iter().all(|(c_x, c_y)| c_x != x || c_y != y))
//    .map(|pos| match self.sequence[amino_acid.len()] {
//        Alphabet::P => (pos, 0),
//        Alphabet::H => {
//            let mut count = 0;
//
//            for (i, (c_x, c_y)) in
//                amino_acid[..amino_acid.len() - 1].iter().enumerate()
//            {
//                if c_x.abs_diff(pos.0) + c_y.abs_diff(pos.1) == 1 {
//                    if let Alphabet::H = self.sequence[i] {
//                        count += 1;
//                    }
//                }
//            }
//
//            (pos, 100 - count)
//        }
//    })
//.collect(),
//None => vec![((0, 0), 0)],
//}
//.into_iter()

//impl Goal for ProteinFolding {
//    fn is_goal(&self, conformation: &Self::State) -> bool {
//        conformation.len() == self.sequence.len()
//    }
//}

//impl Exploration<Energy> for ProteinFolding {
//    fn expand(&self, conformation: &Self::State) -> impl Iterator<Item = (Self::Action, Energy)> {
//        match conformation.last() {
//            Some(&(x, y)) => [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
//                .into_iter()
//                .filter(|(x, y)| conformation.iter().all(|(c_x, c_y)| c_x != x || c_y != y))
//                .map(|pos| match self.sequence[conformation.len()] {
//                    Alphabet::P => (pos, 0),
//                    Alphabet::H => {
//                        let mut count = 0;
//
//                        for (i, (c_x, c_y)) in
//                            conformation[..conformation.len() - 1].iter().enumerate()
//                        {
//                            if c_x.abs_diff(pos.0) + c_y.abs_diff(pos.1) == 1 {
//                                if let Alphabet::H = self.sequence[i] {
//                                    count += 1;
//                                }
//                            }
//                        }
//
//                        (pos, 100 - count)
//                    }
//                })
//                .collect(),
//            None => vec![((0, 0), 0)],
//        }
//        .into_iter()
//    }
//}

//impl TransitionModel for ProteinFolding {
//    type State = Conformation;
//    type Action = Pos;
//
//    fn new_state(&self, conformation: &Self::State, &pos: &Self::Action) -> Self::State {
//        let mut new_conformation = conformation.clone();
//        new_conformation.push(pos);
//        new_conformation
//    }
//}

//#[derive(Default, Clone, PartialEq, Eq, Ord, PartialOrd, Debug)]
//pub struct Energy(Reverse<usize>);
//impl Add for Energy {
//    type Output = Energy;
//
//    fn add(self, rhs: Self) -> Self::Output {
//        Energy(Reverse(self.0.0 + rhs.0.0))
//    }
//}

//Energy(Reverse(0))

//let res = match conformation.last() {
//println!("{:?}", res);
//res.into_iter()

//if conformation.len() > 1 {
//    if let Alphabet::H = self.sequence[conformation.len() - 1] {
//        count -= 1;
//    }
//}

//(pos, Energy(Reverse(count)))
// TODO: almost there
//Alphabet::P => (pos, Energy(Reverse(0))),
//None => vec![((0, 0), Energy(Reverse(0)))],

//let mut contacts = 0;
//
//for (i, (x_i, y_i)) in conformation.iter().enumerate() {
//    for &(x_j, y_j) in conformation.iter().skip(i + 1) {
//        if x_i.abs_diff(x_j) == 1 || y_i.abs_diff(y_j) == 1 {
//            contacts += 1;
//        }
//    }
//}
//
//Energy(Reverse(contacts))
// quanti vicini liberi hanno i punti di tipo H?
//
//let mut free = 0;
//
//for (i, &(x, y)) in conformation.iter().enumerate() {
//    if let Alphabet::H = self.sequence[i] {
//        for (n_x, n_y) in [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)] {
//            if conformation
//                .iter()
//                .all(|&(p_x, p_y)| p_x != n_x || p_y != n_y)
//            {
//                free += 1;
//            }
//        }
//    }
//}
//
//Energy(Reverse(contacts + free))

//let mut dist = 0;
//
//for (x, y) in conformation {
//    dist += x.unsigned_abs() as usize + y.unsigned_abs() as usize;
//}

// hydrophobic amino-acids
// hydrophilic amino-acids (polar)
// length n
//type Energy = Reverse<usize>;
//impl From<Vec> for  {
//    fn from(conformation: Conformation) -> Self {
//        Self { conformation }
//    }
//}

// neighbourhood of a node, so basically add a new node, if available
// when adding the new node, check the neighbourhood (still, would I need an adjency matrix?, how big would it be)
// precalculate bridges when creating new state, the just use the values to calculate the energy

//if conformation[prot_i].0.abs_diff(conformation[prot_j])
// basically, save the list of position for all items in the sequence

// grid [-(n-1), (n-1)]

//.as_ref()
//.map(|amino_acid| amino_acid.depth + 1)
//.unwrap_or(0),
//amino_acid
//    .as_ref()
//    .is_some_and(|amino_acid| )

//pub struct ProteinFolding {
//    sequence: Sequence,
//}

//impl ProteinFolding {
//    pub fn new(sequence: Sequence) -> Self {
//        Self { sequence }
//    }
//}

//println!("explored:\n- {:?}", explored);
//println!("frontier:\n- {:?}\n", frontier);
//println!("{:?}", state);
//println!(
//    "actions:\n- {:?}",
//    self.problem
//        .expand(&state)
//        .map(|(a, _)| a)
//        .collect::<Vec<A>>()
//);
//println!("explored:\n- {:?}", explored);
//println!("frontier:\n- {:?}\n", frontier);

//self.problem.expand(&state).map(|(action, cost)| self.problem.new_state(, a))

//let new_state = self.problem.new_state(&state, &action);
//let new_state = self.problem.new_state(&state, &action);

//fn next_state(&self, s: &S, a: &A) -> (S, Cost);

//let new_node = Rc::new(Node {
//    parent: Some((action, node.clone())),
//    depth: node.depth + 1,
//    cost: node.cost + action_cost,
//    heuristic: self.problem.h(&new_state),
//});

//let node = Rc::new(Node {
//    parent: None,
//    cost: 0,
//    heuristic: self.problem.h(&state),
//    depth: 0,
//});

// TODO: mut ref + lifetime, possibly lifetime on class or impl

//parent: Option<(A, Rc<Node<A>>)>,

//let time = Instant::now();
//impl<A> Debug for Node<A> {
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        f.write_fmt(format_args!(
//            "g: {}, h: {}, f: {}, d: {}",
//            self.cost,
//            self.heuristic,
//            self.cost + self.heuristic,
//            self.depth
//        ))
//    }
//}

//(P, Option<S>): TryInto<S>,
//self.state = (perception, self.state.clone()).try_into().ok();

// node + Rc :: clone for nodes, so just clone the states and don't reuse them!

//println!("{:#?}", time.elapsed())
//println!("{:#?}", time.elapsed())
//println!("frontier: {:?}", frontier);
//println!("explored: {:?}", explored);
//if let Some(depth) = depth {
//    if node.depth > depth {
//        continue;
//        //return None;
//    }
//}

//println!("\n{:?}", state);

//println!(
//    "actions: {:?}",
//    self.problem.actions(&state).into_iter().collect::<Vec<A>>()
//);

//println!("frontier: {:?}", frontier);
//println!("explored: {:?}", explored);

// should actions be owned
// who should own the actions?
// Should it be owned? Or should I give a reference?
// Who sould handle states? The freacking problem or the algorithm?
// It would be a better fit for the problem to handle them...

//pub trait Problem<S, A> {
//    fn expand(&self, s: &S) -> impl Iterator<Item = (A, Cost)>;
//    fn is_goal(&self, s: &S) -> bool;
//    fn new_state(&self, s: &S, a: &A) -> S;
//    fn h(&self, s: &S) -> Heuristic;
//}

// I can return action + cost, without heuristic

// minimal problem, techincally I don't need more... I could have Item be some structure of A... but?
//pub trait Problem<S, A, T>
// where: T: From<A>
//{
//    fn expand(&self, s: &S) -> impl Iterator<Item = T>;
//    fn is_goal(&self, s: &S) -> bool;
//    fn new_state(&self, s: &S, a: &A) -> S;
//}
//for the agent I can just put the cost!

//impl<A> Debug for Node<A>
//where
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        let p = self
//            .parent
//            .as_ref()
//            .and_then(|(_, p)| p.parent.as_ref().map(|(a, _)| a));
//
//        if let Some(a) = p {
//            f.write_fmt(format_args!(
//                "p: {:?}, g: {}, h: {}, f: {}, d: {}",
//                a,
//                self.g,
//                self.h,
//                self.g + self.h,
//                self.depth
//            ))
//        } else {
//            f.write_fmt(format_args!(
//                "p: S, g: {}, h: {}, f: {}, d: {}",
//                self.g,
//                self.h,
//                self.g + self.h,
//                self.depth
//            ))
//        }
//    }
//}

// TODO: move out expand
//pub trait Problem<S, A, V, T> {
//fn expand(&self, state: &S) -> impl Iterator<Item = T>;

//pub trait Problem<S, A, V> {
//    fn new_state(&self, state: &S, action: &A) -> S;
//    fn value(&self, state: &S) -> V;
//}
//
//pub trait StateSpaceExploration<S, A>: Problem<S, A, usize> {
//    fn expand(&self, state: &S) -> impl Iterator<Item = (S, A, usize)>;
//    fn is_goal(&self, state: &S) -> bool;
//}
//
//pub trait IterativeImprovement<S, A, V>: Problem<S, A, V> {
//    fn expand(&self, state: &S) -> impl Iterator<Item = A>;
//}
//
//pub trait ParallelImprovement<S, A, V>: Problem<S, A, V> {
//    fn par_expand(&self, state: &S) -> impl ParallelIterator<Item = A>;
//}

// -----------------------------------------------------------------------------------------------------

//pub trait Problem2<V>: BasicProblem2 {
//    fn value(&self, state: &Self::State) -> V;
//}
//
//pub trait BasicProblem2 {
//    type State;
//    type Action;
//
//    fn new_state(&self, state: &Self::State, action: &Self::Action) -> Self::State;
//}
//
////fn value(&self, state: &Self::State) -> V;
//
////type Value;
//
//pub trait StateSpaceExploration2<V>: Problem2<V> {
//    fn expand(&self, state: &Self::State) -> impl Iterator<Item = (Self::State, Self::Action, V)>;
//    fn is_goal(&self, state: &Self::State) -> bool;
//}
//
//pub trait IterativeImprovement2<V>: Problem2<V> {
//    fn expand(&self, state: &Self::State) -> impl Iterator<Item = Self::Action>;
//}
//
//pub trait ParallelImprovement2<V>: Problem2<V> {
//    fn par_expand(&self, state: &Self::State) -> impl ParallelIterator<Item = Self::Action>;
//}
//
//type Position = Vec<usize>;
//
//type Move = (usize, usize);
//
//struct NQueens(usize);
//
//impl BasicProblem2 for NQueens {
//    type State = Position;
//    type Action = Move;
//
//    fn new_state(&self, position: &Position, &(col, row): &Move) -> Position {
//        let mut new_position = position.clone();
//        new_position[col] = row;
//        new_position
//    }
//}
//
//impl Problem2<Reverse<usize>> for NQueens {
//    fn value(&self, position: &Position) -> Reverse<usize> {
//        let mut attacks = 0;
//
//        for (col_i, row_i) in position.iter().enumerate() {
//            for (col_j, row_j) in position.iter().skip(col_i + 1).enumerate() {
//                if row_i == row_j || row_i.abs_diff(*row_j) == col_i.abs_diff(col_j) {
//                    attacks += 1;
//                }
//            }
//        }
//
//        Reverse(attacks)
//    }
//}
//
////type Value = Reverse<usize>;
//
//impl IterativeImprovement2<Reverse<usize>> for NQueens {
//    //type State = Position;
//    //type Action = Move;
//
//    fn expand(&self, position: &Position) -> impl Iterator<Item = Move> {
//        let mut moves = vec![];
//
//        for (col, &row) in position.iter().enumerate() {
//            if row > 0 {
//                moves.push((col, row - 1));
//            }
//            if row < position.len() - 1 {
//                moves.push((col, row + 1));
//            }
//        }
//
//        moves.into_iter()
//    }
//}
//
////impl ParallelImprovement2 for NQueens {
////    fn par_expand(&self, state: &Position) -> impl ParallelIterator<Item = Move> {
////        self.expand(state)
////            .collect::<Vec<(usize, usize)>>()
////            .into_par_iter()
////    }
////}

//problem.expand(&state)
//P: IterativeImprovement<S, A, V> + Distribution<S>,

//.filter_map(|(action, new_value)| (new_value > value).then_some((action, new_value)))
//.max_by_key(|&(_, value)| value)
//Some((action, value)) => (problem.new_state(&state, &action), value),
//println!("{:?}", value);

// TODO: it would be interesting to use a rayon ParallelIterator to parallelize the lookup of
// the next state

//let new_state = problem.new_state(&state, &action);
//let new_value = problem.value(&new_state);

//state = match problem
//    .expand(&state)
//    .map(|action| problem.new_state(&state, &action))
//    .filter(|s| problem.value(s) > problem.value(&state))
//    .max_by_key(|new_state| problem.value(new_state))
//{
//    Some(new) => new,
//    _ => return Some(state),
//}

//.filter(|s| problem.value(s) > problem.value(&state))

//.map(|s| (s, problem.value(&s)))
//.max_by_key(|(_, v)| v)

//let mut next = None;
//for new_state in problem
//    .expansion(&state)
//    .map(|action| problem.new_state(&state, &action))
//{
//    if problem.value(&new_state) > problem.value(&state) {
//        next = Some(new_state);
//    }
//}

//let new_state = problem.new_state(&state, &action);

//if let Some(s) = next {
//    state = s
//} else {
//    return Some(state);
//}

// descent
//let mut found_act = None;
//found_act = Some(action);
//pub fn steepest_ascent_with_goal<P, S, U>(problem: &P, rng: &mut impl Rng) -> Option<S>
//where
//    U: Ord + Copy,
//    P: IterativeImprovement<U, State = S> + Distribution<S> + Goal,
//{
//    let mut state = problem.sample(rng);
//    let mut utility = problem.utility(&state);
//
//    loop {
//        if problem.is_goal(&state) {
//            return Some(state);
//        }
//
//        (state, utility) = match problem
//            .expand(&state)
//            .filter_map(|action| {
//                let new_state = problem.new_state(&state, &action);
//                let new_utility = problem.utility(&new_state);
//
//                (new_utility > utility).then_some((new_state, new_utility))
//            })
//            .max_by_key(|&(_, value)| value)
//        {
//            Some(new) => new,
//            _ => return Some(state),
//        };
//    }
//}

// function steepest_ascent(problema): stato ottimo locale
//2 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//3 while true do
//4 vicino ← uno a caso dei ‘vicini’ migliori di nodo_corrente;
//5 if nodo_corrente è migliore o della stessa qualità di vicino then
//6 return nodo_corrente.stato; /* ottimo locale, poss. piatto */
//7 else nodo_corrente ← vicino ;

//Variante: Hill-climbing con prima scelta
//1 function hill_climbing(problema): stato ottimo locale
//2 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//3 while true do
//4 mossa_trovata ← false;
//5 while mossa_trovata = false and nodo_corrente ha ancora vicini
//da considerare do
//6 vicino ← prossimo ‘vicino’ di nodo_corrente;
//7 if vicino è migliore o della stessa qualità di nodo_corrente then
// /* nota: effettua mosse laterali */
//8 nodo_corrente ← vicino;
//9 mossa_trovata ← true;
//10 if mossa_trovata = false then
//11 return nodo_corrente.stato;

//function
//simulated_annealing(problema, velocità_raffredd): stato ottimo locale
//2 input velocità_raffredd, una corrisp.: tempo → “temperatura”
//3 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//4 for t from 0 to ∞ do
//5 T ← velocità_raffredd[t];
//6 if T = 0 then return nodo_corrente;
//7 vicino ← un ‘vicino’ random di nodo_corrente;
//8 if vicino è migliore di nodo_corrente then
// /* esegui sempre mosse migliorative */
//9 nodo_corrente ← vicino;
//10 else
// /* valuta se eseguire mosse peggiorative */
//11 ∆E ← abs(differenza di qualità tra nodo_corrente e vicino);
//12 nodo_corrente ← vicino con probabilità e−∆E /T;

//fmt::Debug,
//impl<S, A> Debug for Breadth<S, A>
//where
//    S: Debug,
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        self.0.fmt(f)
//    }
//}

//where
//    S: Debug,
//    A: Debug,
//impl<S, A> Debug for Depth<S, A>
//where
//    S: Debug,
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        self.0.fmt(f)
//    }
//}

//where
//S: Debug,
//A: Debug,
//impl<S, A, N> Debug for PriorityFrontier<S, A, N>
//where
//    S: Ord + Hash + Clone + Debug,
//    N: FromNode<A>,
//    A: Debug,
//{
//    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//        for x in self.0.clone().into_sorted_iter() {
//            if let Some(v) = self.1.get(&x.0) {
//                f.write_fmt(format_args!("({:?}, {:?}), ", x.0, v))?
//            }
//        }
//        f.write_str("\n")
//    }
//}

//A: Debug,

// algoritmi a miglioramento iterativo

//trait MyProblem<'a, State, Action, Value>: Problem<State, Action, Value> {
//    fn new_state(&self, state: &mut State, action: &Action) -> &'a mut State;
//}

//fn is_goal(&self, state: &State) -> bool;
//fn is_goal(&self, s: &S) -> bool;
//fn new_state(&self, s: &S, a: &A) -> S;
//fn h(&self, s: &S) -> Heuristic;

//pub trait Problem<S, A> {
//    fn expand(&self, s: &S) -> impl Iterator<Item = (A, Cost)>;
//    fn is_goal(&self, s: &S) -> bool;
//    fn new_state(&self, s: &S, a: &A) -> S;
//    fn h(&self, s: &S) -> Heuristic;
//}

//pub trait ItProblem<State, Action, Fitness>
//where
//    Fitness: Ord,
//{
//    fn expand(&self, s: &State) -> impl Iterator<Item = Action>;
//    fn is_goal(&self, s: &State) -> bool;
//    fn fitness(&self, s: &State) -> Fitness;
//    fn new_state(&self, s: &State, a: &Action) -> State;
//}

//trait State<A> {
//    fn expand(&self) -> impl Iterator<Item = A>;
//    fn update(&mut self, action: A);
//    fn is_goal(&mut self);
//    fn goodness(&self) -> usize;
//}
//struct State {

//fn value(&self, position: &Position) -> Reverse<usize> {
//    let mut attacks = 0;
//
//    for (col_i, row_i) in position.iter().enumerate() {
//        for (col_j, row_j) in position.iter().skip(col_i + 1).enumerate() {
//            if row_i == row_j || row_i.abs_diff(*row_j) == col_i.abs_diff(col_j) {
//                attacks += 1;
//            }
//        }
//    }
//
//    Reverse(attacks)
//}

//if let Some(optimal) = optimal {
//    println!("{:?}", n_queens.value(&optimal));
//    for row in 0..optimal.len() {
//        for &queen_row in optimal.iter() {
//            if queen_row == row {
//                print!(" Q ")
//            } else {
//                print!(" . ")
//            }
//        }
//        println!()
//    }
//}

//let optimal = (0..=100000)
//    .into_par_iter()
//    .filter_map(|_| hill_climping(&n_queens, &mut rand::rng(), 100))
//    .max_by_key(|b| n_queens.value(b));
//
//if let Some(optimal) = optimal {
//    println!("{:?}", n_queens.value(&optimal));
//    for row in 0..optimal.len() {
//        for &queen_row in optimal.iter() {
//            if queen_row == row {
//                print!(" Q ")
//            } else {
//                print!(" . ")
//            }
//        }
//        println!()
//    }
//}

//fn expand(&self, position: &Position) -> impl Iterator<Item = Move> {
//    position
//        .iter()
//        .enumerate()
//        .map(|(row, &col)| ((row + 1).min(self.0 - 1), col))
//        .fuse()
//        .chain(
//            position
//                .iter()
//                .enumerate()
//                .map(|(row, &col)| (row.saturating_sub(1), col)),
//        )
//}

//use rayon::iter::{IntoParallelIterator, IntoParallelRefIterator};
//new_state[col] = row;
//state
//    .iter()
//    .enumerate()
//    .map(|(row, &col)| ((row + 1).min(self.0 - 1), col))
//    .fuse()
//    .chain(
//        state
//            .iter()
//            .enumerate()
//            .map(|(row, &col)| (row.saturating_sub(1), col)),
//    )

//impl Problem<Board, Move, Reverse<usize>, (Move, Reverse<usize>)> for NQueens {
//fn expand(&self, state: &Board) -> impl Iterator<Item = (Move, Reverse<usize>)> {

//println!("{attacks}");
//let mut rng = rand::rng();

//new_position.insert(col, row);
//for i in 0..position.len() {
//    for j in i + 1..position.len() {
//        if position[i] == position[j] || position[i].abs_diff(position[j]) == i.abs_diff(j)
//        {
//            attacks += 1;
//        }
//    }
//}

//let mut opt_count = 0;

//for _ in 0..100 {
//if let Some(optimal) = optimal {
//    if n_queens.value(&optimal) == Reverse(0) {
//        opt_count += 1;
//    }
//}
//}
//println!("{}", opt_count as f32 / 100.0)

//optimal = match optimal {
//    Some(optimal) if n_queens.value(&optimal) > n_queens.value(&new_optimal) => {
//        Some(new_optimal)
//    }
//    _ => optimal,
//};

//if n_queens.value(&new_optimal) > n_queens.value(&optimal) {}

//let v = ["A", "B", "C", "D", "E", "F", "G1", "G2", "J", "S"];
//let sketch = [
//    ("A", 9, vec![("B", 4)]),
//    ("B", 3, vec![("C", 3), ("G1", 9)]),
//    ("C", 2, vec![("F", 2), ("J", 5), ("S", 1)]),
//    ("D", 4, vec![("C", 3), ("E", 3), ("S", 8)]),
//    ("E", 5, vec![("G2", 7)]),
//    ("F", 3, vec![("D", 1), ("G2", 4)]),
//    ("G1", 0, vec![]),
//    ("G2", 0, vec![]),
//    ("J", 1, vec![("G1", 3)]),
//    ("S", 7, vec![("A", 2), ("B", 7), ("D", 5)]),
//];

//use models::state_space::V;
//
//let v = ["A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S"];
//let to_state: HashMap<&str, usize> =
//    HashMap::from_iter(v.iter().enumerate().map(|(i, &v)| (v, i)));
//
//let sketch = [
//    ("A", 16, vec![("E", 1), ("H", 8)]),
//    ("B", 16, vec![("C", 2), ("I", 3), ("J", 5)]),
//    ("C", 14, vec![("S", 1), ("G2", 18)]),
//    ("D", 17, vec![("C", 2)]),
//    ("E", 15, vec![("D", 2), ("H", 7)]),
//    ("G1", 0, vec![("E", 2)]),
//    ("G2", 0, vec![("C", 2), ("B", 15)]),
//    ("H", 8, vec![("G1", 9)]),
//    ("I", 12, vec![("A", 1), ("H", 4)]),
//    ("J", 10, vec![("G2", 12)]),
//    ("S", 20, vec![("A", 3), ("B", 3), ("D", 3)]),
//];
//
//let graph = sketch
//    .iter()
//    .map(|(_, _, vs)| vs.iter().map(|&(v, _)| V(to_state[v])).collect())
//    .collect();
//let goals = v.iter().map(|&v| v == "G1" || v == "G2").collect();
//let h = sketch.iter().map(|&(_, h, _)| h).collect();
//
//let mut costs = vec![vec![0; v.len()]; v.len()];
//for (u, _, vs) in sketch {
//    for (v, c) in vs {
//        costs[to_state[u]][to_state[v]] = c;
//    }
//}
//
//#[rustfmt::skip]
//let problem = models::state_space::Space { goals, costs, graph, h  };
//let perception = V(to_state["S"]);
//
//let mut agent = Agent::new(problem.clone());
//println!("iterative-deepening\n");
//while let Some(action) = agent.iterative_function::<V, Depth<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//let mut agent = Agent::new(problem.clone());
//println!("depth-first\n");
//while let Some(action) = agent.function::<V, Depth<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//let mut agent = Agent::new(problem.clone());
//println!("breadth-first\n");
//while let Some(action) = agent.function::<V, Breadth<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//let mut agent = Agent::new(problem.clone());
//println!("min-cost\n");
//while let Some(action) = agent.function::<V, MinCost<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");
//
//let mut agent = Agent::new(problem.clone());
//println!("best-first\n");
//while let Some(action) = agent.function::<V, BestFirst<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");
//
//let mut agent = Agent::new(problem.clone());
//println!("A*\n");
//while let Some(action) = agent.function::<V, AStar<V, V>>(perception) {
//    println!("- {:?}", action)
//}
//println!("\n");

//struct Move(usize, usize);
//struct Board(Vec<usize>);

//impl Problem<Board, Vec<usize>, Reverse<usize>, Vec<usize>> for NQueens {
//    fn expansion(&self, state: &Board) -> impl Iterator<Item = Vec<usize>> {
//        // iterate all neightoubrs, so for each value in 0..8
//        [].into_iter()
//    }
//
//    fn new_state(&self, state: &Board, action: &Vec<usize>) -> Board {
//        todo!()
//    }
//
//    fn value(&self, state: &Board) -> Reverse<usize> {
//        todo!()
//    }
//}
