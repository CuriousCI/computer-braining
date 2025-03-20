use ai::frontiers::*;
use ai::problem_solving_agent::*;
use std::collections::HashMap;

pub mod models;

fn main() {
    use models::state_space::V;

    let v = ["A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S"];
    let to_state: HashMap<&str, usize> =
        HashMap::from_iter(v.iter().enumerate().map(|(i, &v)| (v, i)));

    let sketch = [
        ("A", 16, vec![("E", 1), ("H", 8)]),
        ("B", 16, vec![("C", 2), ("I", 3), ("J", 5)]),
        ("C", 14, vec![("S", 1), ("G2", 18)]),
        ("D", 17, vec![("C", 2)]),
        ("E", 15, vec![("D", 2), ("H", 7)]),
        ("G1", 0, vec![("E", 2)]),
        ("G2", 0, vec![("C", 2), ("B", 15)]),
        ("H", 8, vec![("G1", 9)]),
        ("I", 12, vec![("A", 1), ("H", 4)]),
        ("J", 10, vec![("G2", 12)]),
        ("S", 20, vec![("A", 3), ("B", 3), ("D", 3)]),
    ];

    let graph = sketch
        .iter()
        .map(|(_, _, vs)| vs.iter().map(|&(v, _)| V(to_state[v])).collect())
        .collect();
    let goals = v.iter().map(|&v| v == "G1" || v == "G2").collect();
    let h = sketch.iter().map(|&(_, h, _)| h).collect();

    let mut costs = vec![vec![0; v.len()]; v.len()];
    for (u, _, vs) in sketch {
        for (v, c) in vs {
            costs[to_state[u]][to_state[v]] = c;
        }
    }

    #[rustfmt::skip]
    let problem = models::state_space::Space { goals, costs, graph, h  };
    let perception = V(to_state["S"]);

    let mut agent = Agent::new(problem.clone());
    println!("iterative-deepening\n");
    while let Some(action) = agent.iterative_function::<V, Depth<V, V>>(perception) {
        println!("- {:?}", action)
    }
    println!("\n");

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
}

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
