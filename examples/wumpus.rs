use std::num::NonZeroUsize;

use computer_braining::{
    encoder_sat,
    models::wumpus::{self, Col, KnowledgeBase, Row},
};

enum WumpusPropositionalLetter {
    Dead(Time),
    Agent(Col, Row),
    Safe(Col, Row),
    Breeze(Time),
    Glitter(Time),
    Wumpus(Col, Row),
    Stench(Col, Row),
    Pit(Col, Row),
    Scream(Time),
    Bump(Time),
    MoveForward(Time),
    TurnLeft(Time),
    TurnRight(Time),
    GrabGold(Time),
    ShootArrow(Time),
    // ClimbOutsideTheCave(Time),
}

pub struct WumpusAgentSAT {
    encoder: encoder_sat::EncoderSAT<WumpusPropositionalLetter>,
}

impl WumpusAgentSAT {
    fn new() -> Self {
        Self {
            encoder: Default::default(),
        }
    }
}

type Time = usize;

impl KnowledgeBase<Time, wumpus::Sentece, wumpus::Action> for WumpusAgentSAT {
    fn tell(&mut self, sentence: (Time, wumpus::Sentece)) {
        //
    }

    fn ask(&self, time: Time) -> wumpus::Action {
        wumpus::Action::MoveForward
    }
}

fn main() {
    let mut wumpus_world = unsafe {
        wumpus::World::new(
            NonZeroUsize::new_unchecked(7),
            NonZeroUsize::new_unchecked(5),
            2,
        )
        .unwrap()
    };

    println!("{wumpus_world}");

    let mut knowledge_base = WumpusAgentSAT::new();
    std::thread::sleep(std::time::Duration::from_secs(1));

    for time in 1.. {
        wumpus_world
            .perceptions()
            .into_iter()
            .map(wumpus::Sentece::Percept)
            .for_each(|percept| knowledge_base.tell((time, percept)));

        let action = knowledge_base.ask(time);
        wumpus_world.try_action(&action);
        knowledge_base.tell((time, wumpus::Sentece::Action(action)));

        println!("\x1b[2J\x1b[H{wumpus_world}");
        std::thread::sleep(std::time::Duration::from_millis(500));
    }
}

// knowledge_base.tell(
//     time,
//     wumpus_world
//         .perceptions()
//         .into_iter()
//         .map(wumpus::Knowledge::Perception)
//         .collect(),
// );

// fn tell(&mut self, knowledge) {
//     // todo!()
// }
//
// fn ask(&self) -> wumpus::Action {
//     wumpus::Action::MoveForward
//     // todo!()
// }

// impl wumpus::KnowledgeBase<wumpus::Perception, wumpus::Action> for WumpusSAT {
//     fn acquire_perception(&mut self, perception: wumpus::Perception) {
//         todo!()
//     }
//
//     fn next_action(&self) -> wumpus::Action {
//         todo!()
//     }
// }
// // return;
// // let mut knowledge_base: KnowledgeBase<wumpus::Perception> = vec![];
//
// loop {
//     // let perceptions = wumpus_world.perceptions();
//     // knowledge_base.acquire_perceptions(perceptions);
//     wumpus_world.try_action(wumpus::Action::TurnLeft);
//     // wumpus_world
// }
