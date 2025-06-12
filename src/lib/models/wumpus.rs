// 2. Il programma deve offrire un modulo KnowledgeBase che definisce la struttura di una base di conoscenza proposizionale KB che possa rappresentare, istante per istante, la conoscenza dell’agente sul mondo (inizialmente tale conoscenza è semplicemente: “la cella (1,1) è sicura”).

// 3. Il programma deve offrire una funzione Perceptions che, data l’istanza del mondo generata da Req. 1. (l’istanza non deve essere accessibile ad ogni altro modulo del programma) e la posizione corrente dell’agente, restituisca le percezioni che l’agente avrebbe in quella posizione (secondo le regole del mondo).

// 4. Il modulo KnowledgeBase deve permettere di acquisire in ogni istante la conoscenza dovuta alle percezioni.

// 5. Il modulo KnowledgeBase deve permettere di essere interrogato per decidere, in ogni istante, le azioni eseguibili in sicurezza. A tal fine, il programma può utilizzare SATCodec per generare un’istanza SAT del problema e può utilizzare un qualunque solver SAT per risolverla (è possibile evitare di lanciare un SAT solver esterno ed integrare facilmente in SATCodec un solver SAT disponibile come libreria Java.

// 6. L’architettura del programma deve essere tale da permettere una facile sostituzione del modulo KnowledgeBase con un altro basato su altre tecnologie (ad es., logica del primo ordine).

// 7. Il programma deve offrire un modulo che definisca una opportuna euristica per scegliere, in ogni istante, l’azione più promettente da eseguire tra quelle eseguibili in sicurezza, avendo come obiettivo quello di prendere l’oro e successivamente di uscire dalla caverna.

// 8. Il programma deve permettere di essere lanciato con i parametri di cui al Req. 1. e deve eseguire i seguenti passi:
// - 8.1. Generare un’istanza random del mondo come in Req. 1. (istanza che sarà nota solo al modulo Perceptions);
// - 8.2. Simulare l’esplorazione dell’agente nell’istanza del mondo così generata alla ricerca dell’oro. In ogni istante, l’agente dovrà acquisire in KnowledgeBase la conoscenza dovuta alle percezioni correnti, decidere l’azione sicura più promettente (secondo l’euristica) ed eseguirla.

// Il programma deve visualizzare, in ogni istante, la conoscenza attuale dell’agente e l’azione eseguita.
// ClimbOutsideTheCave, // TODO: only when legal

use rand::seq::SliceRandom;
use std::num::NonZeroUsize;

pub trait KnowledgeBase<T, U, V> {
    fn tell(&mut self, sentence: (T, U));
    fn ask(&self, time: T) -> V;
}

pub enum Percept {
    Breeze,
    Bump,
    Glitter,
    Scream,
    Stench,
}

pub enum Action {
    MoveForward,
    TurnLeft,
    TurnRight,
    GrabGold,
    ShootArrow,
}

pub enum Sentece {
    Percept(Percept),
    Action(Action),
}

#[derive(Clone)]
enum RoomKind {
    Pit,
    Wumpus,
    Gold,
}

pub enum WorldGenerationError {
    TooManyRooms,
    NotEnoughRooms,
}

impl std::fmt::Debug for WorldGenerationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::TooManyRooms => write!(f, "too many rooms requested"),
            Self::NotEnoughRooms => write!(f, "expected at least 3 rooms"),
        }
    }
}

enum CardinalDirection {
    North,
    East,
    South,
    West,
}

type LinearMatrix<T> = Vec<T>;

pub type Col = usize;
pub type Row = usize;

struct Position {
    col: Col,
    row: Row,
}

pub struct World {
    rows: usize,
    cols: usize,
    cave: LinearMatrix<Option<RoomKind>>,
    agent_pos: Position,
    agent_dir: CardinalDirection,
    wumpus_pos: Position,
    has_arrow: bool,
    scream: bool,
    bump: bool,
}

impl World {
    pub fn new(
        rows: NonZeroUsize,
        cols: NonZeroUsize,
        pits_number: usize,
    ) -> Result<Self, WorldGenerationError> {
        use WorldGenerationError as E;

        let rooms_count = rows.checked_mul(cols).ok_or(E::TooManyRooms)?.into();

        // Initial room is skipped by starting from 1
        let mut random_rooms_permutation: Vec<_> = (1..rooms_count).collect();
        random_rooms_permutation.shuffle(&mut rand::rng());
        let mut random_rooms_permutation = random_rooms_permutation.into_iter();

        let wumpus_room = random_rooms_permutation.next().ok_or(E::NotEnoughRooms)?;
        let gold_room = random_rooms_permutation.next().ok_or(E::NotEnoughRooms)?;

        let mut cave = vec![None; rooms_count];
        cave[wumpus_room] = Some(RoomKind::Wumpus);
        cave[gold_room] = Some(RoomKind::Gold);

        random_rooms_permutation
            .take(pits_number)
            .for_each(|pit_room| cave[pit_room] = Some(RoomKind::Pit));

        Ok(Self {
            rows: rows.into(),
            cols: cols.into(),
            cave,
            agent_pos: Position { col: 0, row: 0 },
            agent_dir: CardinalDirection::East,
            wumpus_pos: Position {
                col: wumpus_room % cols,
                row: wumpus_room / cols,
            },
            has_arrow: true,
            scream: false,
            bump: false,
        })
    }

    pub fn try_action(&mut self, action: &Action) {
        use CardinalDirection::*;

        self.scream = false;
        self.bump = false;

        match action {
            Action::MoveForward => {
                let movement_offset = match self.agent_dir {
                    North => (self.agent_pos.row < self.rows - 1).then_some((0, 1)),
                    East => (self.agent_pos.col < self.cols - 1).then_some((1, 0)),
                    South => (self.agent_pos.row > 0).then_some((0, -1)),
                    West => (self.agent_pos.col > 0).then_some((-1, 0)),
                };

                if let Some((off_x, off_y)) = movement_offset {
                    self.agent_pos.col = self.agent_pos.col.wrapping_add_signed(off_x);
                    self.agent_pos.row = self.agent_pos.row.wrapping_add_signed(off_y);
                } else {
                    self.bump = true;
                }
            }
            Action::TurnLeft => {
                self.agent_dir = match self.agent_dir {
                    North => West,
                    East => North,
                    South => East,
                    West => South,
                }
            }
            Action::TurnRight => {
                self.agent_dir = match self.agent_dir {
                    North => East,
                    East => South,
                    South => West,
                    West => North,
                }
            }
            Action::GrabGold => {
                let agent_room = self.agent_pos.row * self.cols + self.agent_pos.col;

                if let Some(RoomKind::Gold) = self.cave[agent_room] {
                    self.cave[agent_room] = None;
                }
            }
            Action::ShootArrow => {
                if self.has_arrow {
                    let successful_hit = match self.agent_dir {
                        North => self.wumpus_pos.row > self.agent_pos.row,
                        East => self.wumpus_pos.col > self.agent_pos.col,
                        South => self.wumpus_pos.row < self.agent_pos.row,
                        West => self.wumpus_pos.col < self.agent_pos.col,
                    };

                    if successful_hit {
                        self.scream = true;
                        self.cave[self.wumpus_pos.row * self.cols + self.wumpus_pos.col] = None;
                    }

                    self.has_arrow = false;
                }
            }
        }
    }

    pub fn perceptions(&self) -> Vec<Percept> {
        let mut perceptions = Vec::with_capacity(5);

        if let Some(RoomKind::Gold) = self.cave[self.agent_pos.row * self.cols + self.agent_pos.row]
        {
            perceptions.push(Percept::Glitter)
        }

        if self.bump {
            perceptions.push(Percept::Bump);
        }

        if self.scream {
            perceptions.push(Percept::Scream);
        }

        let offsets = [(0, 1), (1, 0), (0, -1), (-1, 0)];
        let mut has_stench = false;
        let mut has_breeze = false;

        offsets
            .into_iter()
            .filter_map(|(off_x, off_y)| {
                self.agent_pos
                    .col
                    .checked_add_signed(off_x)
                    .and_then(|x| self.agent_pos.row.checked_add_signed(off_y).map(|y| (x, y)))
            })
            .filter(|(x, y)| x < &self.cols && y < &self.rows)
            .for_each(|(x, y)| {
                if !has_stench && (self.wumpus_pos.col, self.wumpus_pos.row) == (x, y) {
                    perceptions.push(Percept::Stench);
                    has_stench = true;
                }

                if !has_breeze {
                    if let Some(RoomKind::Pit) = self.cave[y * self.cols + x] {
                        perceptions.push(Percept::Breeze);
                        has_breeze = true;
                    }
                }
            });

        perceptions
    }
}

impl std::fmt::Display for World {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for row in (0..self.rows).rev() {
            for col in 0..self.cols {
                write!(
                    f,
                    "{}",
                    match self.cave[row * self.cols + col] {
                        None =>
                            if self.agent_pos.col == col && self.agent_pos.row == row {
                                match self.agent_dir {
                                    CardinalDirection::North => " A^",
                                    CardinalDirection::East => " A>",
                                    CardinalDirection::South => " A⌄",
                                    CardinalDirection::West => " A<",
                                }
                            } else {
                                " . "
                            },
                        Some(RoomKind::Wumpus) => " W ",
                        Some(RoomKind::Pit) => " P ",
                        Some(RoomKind::Gold) => " G ",
                    }
                )?;
            }
            writeln!(f)?;
        }

        Ok(())
    }
}

// .collect::<Vec<_>>();
// .filter(|(x, y)| x < self.cols && y < self.cols)
// for (off_x, off_y) in offsets {
//     if let Some(x) = self.agent_pos.x.checked_add_signed(off_x) {
//         if let Some(y) = self.agent_pos.y.checked_add_signed(off_y) {
//             if x < self.cols && y < self.rows {
//                 if !has_stench && (self.wumpus_pos.x, self.wumpus_pos.y) == (x, y) {
//                     perceptions.push(Perception::Stench);
//                     has_stench = true;
//                 }
//
//                 if !has_breeze {
//                     if let Some(RoomType::Pit) = self.cave[y * self.cols + x] {
//                         perceptions.push(Perception::Breeze);
//                         has_breeze = true;
//                     }
//                 }
//             }
//         }
//     }
// }

// self.agent_pos.x.checked_add_signed(off_x).and_then(|x|
//     self.agent_pos.y.checked_add_signed(off_y).and_then(|y| {
//
//     })
// )

// Stench,
// Breeze,

// if self.agent_pos.x > 0 {
//     self.agent_pos.x -= 1;
// } else {
//     self.bump = true;
// }
// if self.agent_pos.x < self.cols - 1 {
//     self.agent_pos.x += 1;
// } else {
//     self.bump = true;
// }
// if self.agent_pos.y > 0 {
//     self.agent_pos.y -= 1;
// } else {
//     self.bump = true;
// }
// if self.agent_pos.y < self.rows - 1 {
//     self.agent_pos.y += 1;
// } else {
//     self.bump = true;
// }

// pub enum TilePerception {
// }
//
// pub enum ReactionPerception {
// }

// pub struct Tile {
//     tile: (PosX, PosY),
//     perc_type: TilePerception,
// }

// TODO: StaticPerceptionType + StaticPerception struct with tile and perception_type
// pub enum Perception {
//     Tile(Tile),
//     Reaction(ReactionPerception),
// }

// Static {
//     tile: (PosX, PosY),
//     perception_type: TilePerception,
// },

// 1. Il programma deve poter generare un’istanza random del mondo del Wumpus di dimensioni arbitrarie, prendendo come argomenti le dimensioni della matrice ed il numero di pozzi.
