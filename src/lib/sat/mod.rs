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

// Satz,
// Eqsatz20,

// MinisatAllModels
// Picosat

// Solver::Satz => "",
// Solver::Eqsatz20 => "",

// cadical
// c time:                                    0.00    seconds

// glucose
// c CPU time              : 0.000986 s

// glucose-syrup
// c real time : 0.00200915 s
// c cpu time  : 0.003043 s

// minisat
// CPU time              : 0.000965 s

// satz

// zchaff
// Total Run Time					0.000102

// pub fn time_from_cadical

// * Satz (1997). `satz`
// * eqzatz20 (1997). `eqsatz20`
// * zChaff (2004) - `zchaff`
// * Minisat v1.14 (2005) - `minisat_v1.14`
// * Minisat v2.2.0 (2007) - `minisat_v2.2.0`
// * minisatAllModels (~2008) - `minisatAllModels`
// * Picosat (2007) - Second place at the 2007 SAT Competition. [Web page](http://fmv.jku.at/picosat/).
// * glucose (2009) - `glucose`
// * glucose-syrup 4.1 (2017) - `glucose-syrup`
// * CaDiCaL (2017) - `cadical`
