pub mod state_space;
pub mod vacuum;
pub mod vacuum_simple;
pub mod visit;

//impl<T> Ord for (Reverse<usize>, T) {
//    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
//        self.0.cmp(&other.0)
//    }
//}

//impl From<(usize, Option<models::vacuum::State>)> for models::vacuum::State {
//    fn from(value: (usize, Option<models::vacuum::State>)) -> Self {
//        value.0.into()
//    }
//}

//let percep: usize = 0;

//while let Some(action) = agent.function::<usize, Bfs<models::esposito::HouseState>>(percep) {
//    println!("{:?}", action)
//}

//let pos = vec![
//            Pos::new(0, 1),
//            Pos::new(0, 2),
//            Pos::new(0, 3),
//            Pos::new(1, 1),
//            Pos::new(1, 3),
//            Pos::new(2, 3),
//            Pos::new(2, 4),
//            Pos::new(3, 0),
//            Pos::new(3, 1),
//            Pos::new(3, 2),
//            Pos::new(3, 3),
//            Pos::new(4, 0),
//            Pos::new(4, 2),
//        ];

//let mut result = vec![
//      Action::Right,
//      Action::Suck,
//      Action::Left,
//      Action::Suck,
//      Action::Up,
//      Action::Suck,
//      Action::Left,
//      Action::Left,
//      Action::Suck,
//      Action::Left,
//      Action::Suck,
//      Action::Up,
//      Action::Suck,
//      Action::Up,
//      Action::Suck,
//      Action::Right,
//      Action::Suck,
//      Action::Right,
//      Action::Up,
//      Action::Suck,
//      Action::Down,
//      Action::Suck,
//      Action::Right,
//      Action::Suck,
//      Action::Down,
//      Action::Suck,
//      Action::Right,
//      Action::Suck,
//  ];

//let init_state = HouseState::with_dirty(4, 3, 5, 5, pos);

// TODO: -----

//let mut agent = Agent::new(visit);
//let mut perception = 2;
//while let Some(action) =
//    agent.function::<usize, BinaryHeap<(Reverse<usize>, State)>>(perception)
//{
//    println!("{:?}", cities[action]);
//    perception = action;
//}
//impl Into<models::vacuum::State> for (usize, Option<models::vacuum::State>) {

//fn into(self) -> models::vacuum::State {
//    self.0.into()
//}
//type Error = ();
//
//fn try_into(self) -> Result<models::vacuum::State, Self::Error> {
//    self.0.try_into().map_err(|_| ())
//}

//while let Some(action) = agent.function::<usize, Bfs<models::vacuum::State>>(percep) {
//    println!("{:?}", action);
//}

//let mut percep = Vacuum::State {
//    position: Vacuum::Position::A,
//    tiles: [Vacuum::Tile::Dirty, Vacuum::Tile::Dirty],
//};
//percep = action;
//println!("{:?}", cities[action]);
//
//
//
//
//
//
//
//
//

//let problem = models::esposito::Esposito { rows: 5, cols: 5 };
//let mut agent = Agent::new(problem);
//let mut counter = 0;
//while let Some(_action) = agent.function::<(), BestFirst<models::esposito::State>>(()) {
//    counter += 1;
//    //println!("{:?}", action)
//}
//println!("BestFirst - actions: {counter}\n");
//
//let problem = models::esposito::Esposito { rows: 5, cols: 5 };
//let mut agent = Agent::new(problem);
//let mut counter = 0;
//while let Some(_action) = agent.function::<(), DepthFirst<models::esposito::State>>(()) {
//    counter += 1;
//    //println!("{:?}", action)
//}
//println!("DFS - actions: {counter}\n");
//
//let problem = models::esposito::Esposito { rows: 5, cols: 5 };
//let mut agent = Agent::new(problem);
//let mut counter = 0;
//while let Some(_action) = agent.function::<(), BreadthFirst<models::esposito::State>>(()) {
//    counter += 1;
//    //println!("{:?}", action)
//}
//println!("Bfs - actions: {counter}\n");
//
//let problem = models::esposito::Esposito { rows: 5, cols: 5 };
//let mut agent = Agent::new(problem);
//let mut counter = 0;
//while let Some(_action) = agent.function::<(), AStar<models::esposito::State>>(()) {
//    counter += 1;
//    //println!("{:?}", action)
//}
//println!("A* - actions: {counter}\n");
//struct BestFirst<S>(BinaryHeap<(Reverse<usize>, S)>);
//
//#[derive(Debug)]
//struct BestFirst<S>(PriorityQueue<S, Reverse<usize>>);
//
//impl<S, A> Frontier<S, A> for BestFirst<S>
//where
//    S: Eq + Hash + Debug, //(Reverse<usize>, S): Ord,
//{
//    fn new() -> Self {
//        //BestFirst(BinaryHeap::new())
//        BestFirst(PriorityQueue::new())
//    }
//
//    fn next(&mut self) -> Option<S> {
//        //self.0.pop().map(|(_, s)| s)
//        self.0.pop().map(|(s, _)| s)
//    }
//
//    fn insert(&mut self, s: S, _: Cost, h: Heuristic) {
//        //self.0.push((Reverse(h), s));
//        self.0.push(s, Reverse(h));
//    }
//
//    fn contains(&self, s: &S) -> bool {
//        false
//    }
//
//    fn change(&mut self, s: &S, c: Cost, h: Heuristic) {
//        self.0.change_priority(s, Reverse(h));
//    }
//}

//, HashSet<S>

//BreadthFirst(VecDeque::new(), HashSet::new())
//todo!()
//fn change(&mut self, s: &S, n: std::rc::Rc<Node<A>>) {
//    todo!()
//}

//fn next(&mut self) -> Option<S> {
//    self.0.pop_front()
//}
//
//fn insert(&mut self, s: S, _: Cost, _: Heuristic) {
//    self.0.push_back(s.clone());
//    self.1.insert(s);
//}
//
//fn contains(&self, s: &S) -> bool {
//    self.1.contains(s)
//}
//
//fn change(&mut self, s: &S, c: Cost, h: Heuristic) {}

//if !self.1.contains(&s) {
//    self.1.insert(s);
//}

//fn next(&mut self) -> Option<S> {
//    self.0.pop()
//}
//
//fn insert(&mut self, s: S, _: Cost, _: Heuristic) {
//    self.0.push(s);
//}
//
//fn contains(&self, s: &S) -> bool {
//    self.0.contains(s)
//}
//
//fn change(&mut self, s: &S, c: Cost, h: Heuristic) {}

//self.0.push((s, n), n.cost)

//fn next(&mut self) -> Option<S> {
//    self.0.pop().map(|(s, _)| s)
//}
//
//fn insert(&mut self, s: S, c: Cost, _: Heuristic) {
//    //self.0.push((Reverse(c), s));
//    self.0.push(s, Reverse(c));
//}
//
//fn contains(&self, s: &S) -> bool {
//    false
//    //self.0.get_mut
//    //false
//    // TODO: self.0.conta
//}
//
//fn change(&mut self, s: &S, c: Cost, h: Heuristic) {
//    self.0.change_priority(s, Reverse(c));
//    //todo!()
//}
//
//struct AStar<S>(BinaryHeap<(Reverse<usize>, S)>);
//#[derive(Debug)]
//struct AStar<S>(PriorityQueue<S, Reverse<usize>>);
//
//impl<S, A> Frontier<S, A> for AStar<S>
//where
//    S: Eq + Hash + Debug,
//{
//    fn new() -> Self {
//        //AStar(BinaryHeap::new())
//        AStar(PriorityQueue::new())
//    }
//
//    fn next(&mut self) -> Option<S> {
//        //self.0.pop().map(|(_, s)| s)
//        self.0.pop().map(|(s, _)| s)
//    }
//
//    fn insert(&mut self, s: S, c: Cost, h: Heuristic) {
//        //self.0.push((Reverse(c + h), s));
//        self.0.push(s, Reverse(c + h));
//    }
//
//    fn contains(&self, s: &S) -> bool {
//        false
//        // TODO: self.0.conta
//    }
//
//    fn change(&mut self, s: &S, c: Cost, h: Heuristic) {
//        self.0.change_priority(s, Reverse(c + h));
//    }
//}
