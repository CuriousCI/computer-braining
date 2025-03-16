use ai::frontiers::*;
use ai::problem_solving_agent::*;
use std::collections::HashMap;

pub mod models;

fn main() {
    use models::state_space::V;

    let v = ["A", "B", "C", "D", "E", "F", "G1", "G2", "J", "S"];
    let to_state: HashMap<&str, usize> =
        HashMap::from_iter(v.iter().enumerate().map(|(i, &v)| (v, i)));

    let sketch = [
        ("A", 9, vec![("B", 4)]),
        ("B", 3, vec![("C", 3), ("G1", 9)]),
        ("C", 2, vec![("F", 2), ("J", 5), ("S", 1)]),
        ("D", 4, vec![("C", 3), ("E", 3), ("S", 8)]),
        ("E", 5, vec![("G2", 7)]),
        ("F", 3, vec![("D", 1), ("G2", 4)]),
        ("G1", 0, vec![]),
        ("G2", 0, vec![]),
        ("J", 1, vec![("G1", 3)]),
        ("S", 7, vec![("A", 2), ("B", 7), ("D", 5)]),
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
            //println!("{u} -> {v} ({c})");
        }
    }

    #[rustfmt::skip]
    let problem = models::state_space::Space { goals, costs, graph, h };
    let perception = V(to_state["S"]);

    let mut agent = Agent::new(problem.clone());
    println!("depth-first\n");
    while let Some(action) = agent.iterative_function::<V, DepthFirst<V, V>>(perception) {
        println!("- {:?}", action)
    }
    println!("\n\n\n");

    //let mut agent = Agent::new(problem.clone());
    //println!("depth-first\n");
    //while let Some(action) = agent.function::<V, DepthFirst<V, V>>(perception) {
    //    println!("- {:?}", action)
    //}
    //println!("\n\n\n");
    //
    //let mut agent = Agent::new(problem.clone());
    //println!("breadth-first\n");
    //while let Some(action) = agent.function::<V, BreadthFirst<V, V>>(perception) {
    //    println!("- {:?}", action)
    //}
    //println!("\n\n\n");
    //
    //let mut agent = Agent::new(problem.clone());
    //println!("min-cost\n");
    //while let Some(action) = agent.function::<V, MinCost<V, V>>(perception) {
    //    println!("- {:?}", action)
    //}
    //println!("\n\n\n");
    //
    //let mut agent = Agent::new(problem.clone());
    //println!("best-first\n");
    //while let Some(action) = agent.function::<V, BestFirst<V, V>>(perception) {
    //    println!("- {:?}", action)
    //}
    //println!("\n\n\n");
    //
    //let mut agent = Agent::new(problem.clone());
    //println!("A*\n");
    //while let Some(action) = agent.function::<V, AStar<V, V>>(perception) {
    //    println!("- {:?}", action)
    //}
    //println!("\n\n\n");
}
