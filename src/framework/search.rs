use std::{collections::VecDeque, ops::Add, rc::Rc};

use crate::framework::problem::{GoalBased, Problem, Utility};

pub trait Frontier<T>: Default {
    fn pop(&mut self) -> Option<T>;
    fn insert(&mut self, t: T);
    // la struttura deve solo implementare un hash-set per capire se uno stato è in frontiera? HashSet di riferimenti?
    // No, perché dovrei clonare un po' di robe per avere questo (roba che in teoria faccio comunque?
    // Nah, non mi serve per gli alberi ad esempio, posso fare un trait TreeFrontier, e che
    // frontier deve avere TreeFrontier + altra roba
    fn replace(&mut self, _t: T) {}
}

pub trait Priority<T> {
    fn priority(&self) -> T;
}

#[derive(Default, Clone)]
pub struct UniformCost<T> {
    pub g: T,
}

impl<T: Clone> Priority<T> for UniformCost<T> {
    fn priority(&self) -> T {
        self.g.clone()
    }
}

impl<T: Add<Output = T>> Add for UniformCost<T> {
    type Output = UniformCost<T>;

    fn add(self, rhs: Self) -> Self::Output {
        Self {
            g: self.g.add(rhs.g),
        }
    }
}

#[derive(Default, Clone)]
pub struct GreedyBestFirst<T> {
    pub h: T,
}

impl<T: Clone> Priority<T> for GreedyBestFirst<T> {
    fn priority(&self) -> T {
        self.h.clone()
    }
}

#[derive(Default, Clone)]
pub struct AStar<T> {
    pub g: T,
    pub h: T,
}

impl<T: Add<Output = T>> Add for AStar<T> {
    type Output = AStar<T>;

    fn add(self, rhs: Self) -> Self::Output {
        AStar {
            g: self.g + rhs.g,
            h: rhs.h,
        }
    }
}

impl<T: std::ops::Add<Output = T> + Clone> Priority<T> for AStar<T> {
    fn priority(&self) -> T {
        self.g.clone() + self.h.clone()
    }
}

// meglio avere 3 generic, oppure uno solo che li riassume tutti e 3?
// la frontiera dovrebbe essere definita in termini di T
// - i tipi del nodo sono calcolabili da quelli "dati in input" se vogliamo
// - il problema lo conosco dall'agente
// - il tipo su cui lavorare viene dato
// ok, ora la domanda è: la frontiera può fare a meno del problema? Si e no... il nodo ha bisogno delle azioni e dello stato
// vorrei non dover propagare tutta questa roba
// in generale non posso disaccoppiare la frontiera dal problema (se devo gestire patate, patate gestitsco)
pub struct Node<P: TransitionModel, T> {
    parent: Option<(Rc<Self>, P::Action)>,
    pub state: P::State,
    pub f: T,
}

// e se anziche un problem prendessi un Utility<T>, e a quel punto ho anche la T?, nah
impl<P: TransitionModel, T: Priority<V>, V> Priority<V> for Rc<Node<P, T>> {
    fn priority(&self) -> V {
        self.f.priority()
    }
}

pub struct Agent<P, A> {
    problem: P,
    plan: Option<VecDeque<A>>,
}

impl<P: TransitionModel> Agent<P, P::Action> {
    pub fn new(problem: P) -> Self {
        Self {
            plan: None,
            problem,
        }
    }
}

// impl<P, A> Deref for Agent<P, A> {
//     type Target = P;
//
//     fn deref(&self) -> &Self::Target {
//         &self.problem
//     }
// }

// impl<P> Agent<P>
// where
//     P: Problem + GoalBased,
//     P::State: Eq + Hash + Clone,
//     P::Action: Clone,
// {
//     pub fn function<F, T>(&mut self, perception: impl TryInto<P::State>) -> Option<P::Action>
//     where
//         F: Frontier<P, T>,
//         T: Default + std::ops::Add<Output = T> + Clone,
//         P: Utility<T>,
//     {
//         if self.plan.is_none() {
//             self.plan = self.search::<F, T>(perception.try_into().ok()?);
//         };
//
//         self.plan.as_mut()?.pop_front()
//     }
//
//     fn search<F, T>(&self, initial_state: P::State) -> Option<VecDeque<P::Action>>
//     where
//         F: Frontier<P, T>,
//         T: Default + std::ops::Add<Output = T> + Clone,
//         P: Utility<T>,
//     {
//         let mut frontier = F::default();
//         let mut explored = HashSet::new();
//         let mut in_frontier = HashSet::new();
//
//         in_frontier.insert(initial_state.clone());
//         frontier.insert(
//             Node {
//                 parent: None,
//                 state: initial_state,
//                 f: Default::default(),
//             }
//             .into(),
//         );
//
//         while let Some(node) = frontier.next() {
//             if self.goal_test(&node.state) {
//                 let mut plan = VecDeque::new();
//                 let mut node = node;
//                 while let Some((prev, action)) = node.parent.clone() {
//                     plan.push_front(action);
//                     node = prev;
//                 }
//
//                 return Some(plan);
//             }
//
//             explored.insert(node.state.clone());
//             in_frontier.remove(&node.state);
//
//             for action in self.actions(&node.state) {
//                 let state = self.result(&node.state, &action);
//
//                 if !explored.contains(&state) {
//                     let is_in_frontier = in_frontier.contains(&state);
//
//                     let new_node = Rc::new(Node {
//                         f: node.f.clone() + self.utility(&node.state, &state, &action),
//                         parent: Some((node.clone(), action)),
//                         state,
//                     });
//
//                     if is_in_frontier {
//                         frontier.update(new_node);
//                     } else {
//                         in_frontier.insert(new_node.state.clone());
//                         frontier.insert(new_node);
//                     }
//                 }
//             }
//         }
//
//         None
//     }
// }

impl<P> Agent<P, P::Action>
where
    P: TransitionModel + GoalBased,
    P::Action: Clone,
{
    pub fn function_on_tree<F, T>(
        &mut self,
        perception: impl TryInto<P::State>,
    ) -> Option<P::Action>
    where
        F: Frontier<Rc<Node<P, T>>>,
        T: Default + Clone + Add<Output = T>,
        P: Utility<T>,
    {
        if self.plan.is_none() {
            self.plan = self.search_on_tree::<F, T>(perception.try_into().ok()?);
        };

        self.plan.as_mut()?.pop_front()
    }

    // ho bisogno della frontiera e del tipo per il costo?
    // hmmmm, interessante...
    // ma anche la frontiera ha bisogno del tipo per il costo
    // sostanzialmente: l'utilità
    // e se definissi l'agente in termini dell'utilità basta specificare la frontiera?
    // la frontiera usa l'utilità... hmmmmm o in realtà si accontenta di qualcosa che implementa Priority
    //
    // la frontiera mi dice come viene gestita la scelta del prossimo (BFS, DFS, Priorità, albero)
    // l'utilità mi dice che valore hanno le cose che deve gestire la frontiera
    // quindi mi aspetterei una roba tipo
    //
    // Guarda:
    // - usa un bel DFS
    //      - no utilità alla fine dei conti
    //      - non gli frega nenache quale sia il problema?
    //      - Non deve neanche sapere che sta lavorando con dei nodi!
    // - usa un bel BFS
    //      - stesso discorso di sopra... si comporta uguale indipendentemente da cosa gli arriva
    // - usa una bella priorità
    //      - a questo punto lo voglio sapere come cavolo si calcola la priorità
    //      - e voglio sapere anche come disitinguo le cose su cui la calcolo (per trovarle velocemente)
    //      - forse mi serve leggermente sapere che sto lavorando con nodi... considerando che ho
    //      bisogno di fare l'hashing dello stato? (oppure no, dato che effettivamente potrei dire
    //      cosa significa hashare un nodo e che due nodi sono equivalenti) e dato che mi serve
    //      calcolare la priorità (che, di nuovo, è derivabile da parte del nodo, partendo da
    //      quella di T)

    fn search_on_tree<F, T>(&self, state: P::State) -> Option<VecDeque<P::Action>>
    where
        F: Frontier<Rc<Node<P, T>>>,
        T: Default + Clone + Add<Output = T>,
        P: Utility<T>,
    {
        let mut frontier = F::default();
        frontier.insert(
            Node {
                parent: None,
                state,
                f: Default::default(),
            }
            .into(),
        );

        while let Some(node) = frontier.pop() {
            if self.problem.goal_test(&node.state) {
                let mut plan = VecDeque::new();
                let mut node = &node;
                while let Some((parent, action)) = &node.parent {
                    plan.push_front(action.clone());
                    node = parent;
                }

                return Some(plan);
            }

            for action in self.problem.actions(&node.state) {
                let state = self.problem.result(&node.state, &action);

                frontier.insert(
                    Node {
                        f: node.f.clone() + self.problem.utility(&node.state, &state, &action),
                        parent: Some((node.clone(), action)),
                        state,
                    }
                    .into(),
                );
            }
        }

        None
    }
}

pub struct NodeArena<'a, P: TransitionModel, T> {
    parent: Option<(&'a Self, P::Action)>,
    pub state: P::State,
    pub f: T,
}

impl<P: TransitionModel, T: Priority<V>, V> Priority<V> for &NodeArena<'_, P, T> {
    fn priority(&self) -> V {
        self.f.priority()
    }
}

use bumpalo::Bump;

use super::problem::TransitionModel;

impl<P> Agent<P, P::Action>
where
    P: TransitionModel + GoalBased,
    P::Action: Clone,
{
    pub fn function_on_tree_arena<'a, F, T>(
        &mut self,
        perception: impl TryInto<P::State>,
        bump: &'a Bump,
    ) -> Option<P::Action>
    where
        F: Frontier<&'a NodeArena<'a, P, T>>,
        T: Default + Clone + Add<Output = T> + 'a,
        P: Utility<T> + 'a,
    {
        if self.plan.is_none() {
            self.plan = self.search_on_tree_arena::<F, T>(perception.try_into().ok()?, bump);
        };

        self.plan.as_mut()?.pop_front()
    }

    fn search_on_tree_arena<'a, F, T>(
        &self,
        state: P::State,
        arena: &'a Bump,
    ) -> Option<VecDeque<P::Action>>
    where
        F: Frontier<&'a NodeArena<'a, P, T>>,
        T: Default + Clone + Add<Output = T> + 'a,
        P: Utility<T> + 'a,
    {
        let mut frontier = F::default();

        let node = arena.alloc(NodeArena {
            parent: None,
            state,
            f: Default::default(),
        });

        frontier.insert(node);

        while let Some(node) = frontier.pop() {
            if self.problem.goal_test(&node.state) {
                let mut plan = VecDeque::new();
                let mut node = &node;
                while let Some((parent, action)) = &node.parent {
                    plan.push_front(action.clone());
                    node = parent;
                }

                return Some(plan);
            }

            for action in self.problem.actions(&node.state) {
                let state = self.problem.result(&node.state, &action);

                let node = arena.alloc(NodeArena {
                    f: node.f.clone() + self.problem.utility(&node.state, &state, &action),
                    parent: Some((node, action)),
                    state,
                });

                frontier.insert(node);
            }
        }

        None
    }
}

// - problema
//      - viene dall'agente, easy
// - utilità
//      - dipende da
//          - [x] problema
//          - [ ] algoritmo (MinCost è solo g + come si calcola g; per A* è g e h, + come si calcolano g e h, I might use Depth)
//          - [ ] tipo del costo (costi diversi si calcolano in modo diverso)
// - frontiera
//      - dipende da utilità (e dallo stato, che ignoriamo per ora)
//      - [x] dipende dal problema (fortemente, se è un tree o un non tree)
//      - hmmm, ma se dipende dall'utilità...
//          - ad AStar è associato un priority qualcosa?
//
//  il problema è che utilità
//      - dipende da problema (+ deve essere specificata)
//      - frontiera dipende da utilità (+ deve essere specificata)
//

// .map(|action| (self.result(&node.state, &action), action))
// .for_each(|(state, action)| {

// pub struct Node<P: Search> {
//     prev: Option<(Rc<Self>, P::Action)>,
//     pub state: P::State,
//     // pub cost: P::Value,
//     // pub heuristic: P::Value,
// }

// questo T mi rappresenta quale algoritmo sto usando, quindi mi aspetterei una roba tipo
// Agent<NQueens<BreadthFrist>>
// pub struct Agent<P: Search<T>, T> {
// non tutte le frontiere richiedono priority, vero è un argomento in più di solito
// che coincidenza, priorio quelle che hanno T!

// #[derive(Default)]
// pub struct BreadthFirst;
//
// #[derive(Default)]
// pub struct DepthFirst;

// Node<AStar<Patate>>
// Node<AStar<Volatili>>
// Node<AStar<usize>>
// Node<AStar<banane>>
// P::Value: Default + Clone + Add<Output = P::Value>,

// prev: None,
// cost: Default::default(),
// heuristic: self.heuristic(&state),
// state,

// let new_node = self.child_node(node, );
// cost: node.cost.clone() + cost,
// heuristic: self.heuristic(&state),
// P::Value: Default + Clone + Add<Output = P::Value>,

// for action in self.actions(&node.state) {
//     let state = self.result(&node.state, &action);
//
//     frontier.insert(
//         Node {
//             f: node.f.clone() + self.utility(&node.state, &state, &action),
//             parent: Some((node.clone(), action)),
//             state,
//         }
//         .into(),
//     );
// }

// cost: Default::default(),
// heuristic: self.heuristic(&state),
// f:
// cost: node.cost.clone() + cost,
// heuristic: self.heuristic(&state),
