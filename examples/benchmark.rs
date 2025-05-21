use std::io::Write;

use computer_braining::models::*;
use computer_braining::sat::*;
use rand::Rng;

const SOLVERS: [Solver; 6] = [
    Solver::ZChaff,
    Solver::Minisat1,
    Solver::Minisat2,
    Solver::Glucose,
    Solver::GlucoseSyrup,
    Solver::CaDiCaL,
];

fn benchmark<F>(max_size: usize, problem: &str, f: F) -> String
where
    F: FnOnce(usize) -> String + Copy,
{
    let home = std::env::var("HOME").expect("$HOME variable not found");

    (1..=max_size)
        .step_by(max_size / 10)
        .map(|size| {
            let mut file = std::fs::OpenOptions::new()
                .write(true)
                .truncate(true) // This actually clears the file
                .create(true)
                .open(format!(
                    "{home}/projects/docker-ai-tools/data/SAT/encoding.cnf"
                ))
                .unwrap();

            file.write_all(f(size).as_bytes()).unwrap();

            SOLVERS
                .iter()
                .filter_map(|solver| {
                    solver
                        .time(
                            &String::from_utf8(
                                std::process::Command::new("sudo")
                                    .args([
                                        "./run.sh",
                                        &format!("{solver}"),
                                        "data/SAT/encoding.cnf",
                                    ])
                                    .current_dir(format!("{home}/projects/docker-ai-tools/"))
                                    .output()
                                    .unwrap()
                                    .stdout,
                            )
                            .unwrap(),
                        )
                        .map(|time| {
                            format!("{problem}, {solver}, {size}, {:?}\n", time.as_millis())
                        })
                })
                .collect::<String>()
        })
        .collect()
}

fn main() {
    let mut file = std::fs::OpenOptions::new()
        .append(true)
        .create(true)
        .open("SAT.csv")
        .unwrap();

    for _ in 1..100 {
        let results = benchmark(10000, "graph_colouring_red_self_loops", |size| {
            let mut rng = rand::rng();

            let vertices: Vec<_> = (0..size).collect();
            let edges: Vec<_> = (0..size)
                .flat_map(|u| {
                    (u..size)
                        .filter_map(|v| rng.random_bool(0.125).then_some((u, v)))
                        .collect::<Vec<_>>()
                })
                .collect();

            println!("size - {size}\n");
            graph_colouring_red_self_loops::encode_instance(&vertices, &edges)
        });

        writeln!(&mut file, "{results}").unwrap();
    }
}

// let results = println!("{results}");

// println!("size - {size}\nedges - {:?}\n", edges);
// let edges: std::collections::BTreeSet<_> = (1..size * 2)
//     .map(|_| {
//         let u = rng.random_range(0..size);
//         let v = rng.random_range(u..size);
//
//         (u, v)
//     })
//     .collect();

// let mut file = File::create(format!(
//     "{home}/projects/docker-ai-tools/data/SAT/encoding.cnf"
// ))
// .unwrap();
// file.write_fmt(format_args!("{}", f(size)));
// file.file.write(format_args!("{}", f(size))).unwrap();

// (1..rng.random_range(1..size)).map(|_| edges).collect();

// #[rustfmt::skip]
// let vertices = [
//     "A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S"
// ];

// #[rustfmt::skip]
// let edges = [
//     ("A", "E"), ("A", "H"), ("A", "I"), ("A", "S"),
//     ("B", "C"), ("B", "G2"), ("B", "I"), ("B", "J"),
//     ("B", "S"), ("C", "D"), ("C", "G2"), ("C", "S"),
//     ("D", "E"), ("D", "S"), ("E", "G1"), ("E", "H"),
//     ("G1", "H"), ("G2", "J"), ("H", "I"), ("J", "J")
// ];

// println!("{:?}", unsafe {
//     String::from_utf8_unchecked(
//         std::process::Command::new("ls")
//             .arg("-la")
//             .current_dir(format!("{}/projects", std::env::var("HOME").unwrap()))
//             .output()
//             .unwrap()
//             .stdout,
//     )
// });

// let solvers = [
//     (Solver::ZChaff, "zchaff"),
//     (Solver::Minisat1, "minisat"),
//     (Solver::Minisat2, "minisat"),
//     (Solver::Glucose, "glucose"),
//     (Solver::GlucoseSyrup, "glucose-syrup"),
//     (Solver::CaDiCaL, "cadical"),
// ];

// fn new_instance(size: usize) {
//     #[rustfmt::skip]
//     let vertices = [
//         "A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S"
//     ];
//
//     #[rustfmt::skip]
//     let edges = [
//         ("A", "E"), ("A", "H"), ("A", "I"), ("A", "S"),
//         ("B", "C"), ("B", "G2"), ("B", "I"), ("B", "J"),
//         ("B", "S"), ("C", "D"), ("C", "G2"), ("C", "S"),
//         ("D", "E"), ("D", "S"), ("E", "G1"), ("E", "H"),
//         ("G1", "H"), ("G2", "J"), ("H", "I"), ("J", "J")
//     ];
//
//     encode_instance(&vertices, &edges);
// }

// fn solve() {
//     std::process::Command::new("/home/cicio/projects/docker-ai-tools/test.sh")
//         .output()
//         .unwrap();
// }

// let lines: String =

// let results: String = (1..=1000)
//     .map(|_| {
//         new_instance(1);
//         solve();
//
//         solvers
//             .iter()
//             .filter_map(|(solver, file)| {
//                 solver
//                     .time(
//                         &std::fs::read_to_string(format!(
//                             "/home/cicio/projects/satcodec/results/{file}"
//                         ))
//                         .unwrap(),
//                     )
//                     .map(|time| format!("{:?}, {:?}\n", solver, time))
//             })
//             .collect::<String>()
//     })
//     .collect();

// sudo ./run.sh $solver data/SAT/edge-colouring.cnf
// .filter_map(|(solver, file)| {
//     solver
//         .time(
//             &std::fs::read_to_string(format!(
//                 "/home/cicio/projects/satcodec/results/{file}"
//             ))
//             .unwrap(),
//         )
//         .map(|time| format!("{:?}, {:?}\n", solver, time))
// })
