//use ai::problem_solving_agent::Problem;
//
//type State = usize;
//type Action = usize;
//
//pub struct Visit {
//    pub graph: Vec<Vec<State>>,
//    pub goals: Vec<bool>,
//    pub dists: Vec<Vec<usize>>,
//}
//
//impl Problem<State, Action> for Visit {
//    fn expand(&self, &s: &State) -> impl IntoIterator<Item = Action> {
//        self.graph[s].clone()
//    }
//
//    fn is_goal(&self, &s: &State) -> bool {
//        self.goals[s]
//    }
//
//    fn new_state(&self, &s: &State, &a: &Action) -> (State, usize) {
//        (a, self.dists[s][a])
//    }
//
//    fn h(&self, s: &State) -> usize {
//        0
//    }
//}
//
////#[rustfmt::skip]
////let cities = ["Oradea", "Zerind", "Arad", "Sibiu", "Făgăraş", "Timişoara", "Lugoj", "Mehadia", "Dobreta", "Râmnicu Vâlcea", "Piteşti", "Craiova", "Bucureşti", "Giurgiu", "Urziceni", "Hârşova", "Eforie", "Vaslui", "Iaşi", "Neamţ"];
////
////let city_to_indx: HashMap<&str, usize> =
////    HashMap::from_iter(cities.clone().iter().enumerate().map(|(i, &c)| (c, i)));
////
////let city_map = vec![
////    ("Oradea", vec![("Zerind", 71), ("Sibiu", 151)]),
////    ("Zerind", vec![("Oradea", 71), ("Arad", 75)]),
////    (
////        "Arad",
////        vec![("Zerind", 75), ("Sibiu", 140), ("Timişoara", 118)],
////    ),
////    (
////        "Sibiu",
////        vec![
////            ("Oradea", 151),
////            ("Arad", 140),
////            ("Făgăraş", 99),
////            ("Râmnicu Vâlcea", 80),
////        ],
////    ),
////    ("Făgăraş", vec![("Sibiu", 99), ("Bucureşti", 211)]),
////    ("Timişoara", vec![("Arad", 118), ("Lugoj", 111)]),
////    ("Lugoj", vec![("Timişoara", 111), ("Mehadia", 70)]),
////    ("Mehadia", vec![("Lugoj", 70), ("Dobreta", 75)]),
////    ("Dobreta", vec![("Mehadia", 75), ("Craiova", 120)]),
////    (
////        "Râmnicu Vâlcea",
////        vec![("Sibiu", 80), ("Piteşti", 97), ("Craiova", 146)],
////    ),
////    (
////        "Piteşti",
////        vec![("Râmnicu Vâlcea", 97), ("Craiova", 138), ("Bucureşti", 101)],
////    ),
////    (
////        "Craiova",
////        vec![("Dobreta", 120), ("Râmnicu Vâlcea", 146), ("Piteşti", 138)],
////    ),
////    (
////        "Bucureşti",
////        vec![
////            ("Făgăraş", 211),
////            ("Piteşti", 101),
////            ("Giurgiu", 90),
////            ("Urziceni", 85),
////        ],
////    ),
////    ("Giurgiu", vec![("Bucureşti", 90)]),
////    (
////        "Urziceni",
////        vec![("Bucureşti", 85), ("Hârşova", 98), ("Vaslui", 142)],
////    ),
////    ("Hârşova", vec![("Urziceni", 98), ("Eforie", 86)]),
////    ("Eforie", vec![("Hârşova", 86)]),
////    ("Vaslui", vec![("Urziceni", 142), ("Iaşi", 92)]),
////    ("Iaşi", vec![("Vaslui", 92), ("Neamţ", 87)]),
////    ("Neamţ", vec![("Iaşi", 87)]),
////];
////
////let mut visit = visit::Visit {
////    goals: vec![false; cities.len()],
////    dists: vec![vec![0; cities.len()]; cities.len()],
////    graph: city_map
////        .iter()
////        .map(|(_, dest)| dest.iter().map(|(d, _)| city_to_indx[d]).collect())
////        .collect(),
////};
////
////visit.goals[12] = true;
////for (city, dest) in city_map {
////    for (dest, dist) in dest {
////        visit.dists[city_to_indx[&city]][city_to_indx[&dest]] = dist;
////    }
////}
