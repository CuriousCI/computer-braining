pub mod dimacs_encoder;

#[derive(Debug)]
pub enum Solver {
    ZChaff,
    Minisat1,
    Minisat2,
    Glucose,
    GlucoseSyrup,
    CaDiCaL,
}

impl std::fmt::Display for Solver {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self {
            Solver::ZChaff => "zchaff",
            Solver::Minisat1 => "minisat_v1.14",
            Solver::Minisat2 => "minisat_v2.2.0",
            Solver::Glucose => "glucose",
            Solver::GlucoseSyrup => "glucose-syrup",
            Solver::CaDiCaL => "cadical",
        })
    }
}

impl Solver {
    pub fn time(&self, result: &str) -> Option<std::time::Duration> {
        result.lines().find_map(|line| {
            line.starts_with(match self {
                Solver::ZChaff => "Total Run Time",
                Solver::Minisat1 => "CPU time",
                Solver::Minisat2 => "CPU time",
                Solver::Glucose => "c CPU time",
                Solver::GlucoseSyrup => "c real time",
                Solver::CaDiCaL => "c time:",
            })
            .then_some(
                line.split_whitespace()
                    .find_map(|word| word.parse().ok().map(f64::abs))
                    .map(std::time::Duration::from_secs_f64),
            )
        })?
    }
}
