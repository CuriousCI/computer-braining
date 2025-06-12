#import "template.typ": *

#show: doc => conf([E.A.6.13 (Wumpus)], doc)

== Modelling

Given the knowledge abut the *Wumpus world*, and $R$, $C$ respectively the number of rows and columns of the grid and $T$ the current turn let
// - $cal(R) = {1, ..., R}$
// - $cal(C) = {1, ..., C}$
- $cal(T) = {1, ..., T}$
- $cal(D) = {N, E, S, W}$
- $bold(Rho) = {1, ..., R} times {1, ..., C}$ the set of rooms

\

$
    "LP" =
    & {S_rho | rho in bold(Rho)} union {W_rho | rho in bold(Rho)} union \
    & {G_rho | rho in bold(Rho)} union {P_rho | rho in bold(Rho)} union \
    & {"Stench"_rho | rho in bold(Rho)} union {"Glitter"_rho | rho in bold(Rho)} union \
    & {"Breeze"_rho | rho in bold(Rho)} union \
    & {"Stench"^t | t in cal(T)} union {"Glitter"^t | t in cal(T)} union \
    & {"Breeze"^t | t in cal(T)} union \
$

// & {"Stench"_(r, c) | r in cal(R) and c in cal(C)} union \
// & {"Glitter"_(r, c) | r in cal(R) and c in cal(C)} union \
// & {"Breeze"_(r, c) | r in cal(R) and c in cal(C)} union \
// & {"AgentDir"_d^t | t in cal(T) and d in cal(D)} union \
// & {"AgentPos"_(r, c)^t | t in cal(T) and r in cal(R) and c in cal(C)} union \
// TODO: perceptions too
// & {"Agent"_(r, c) | r in cal(C) and r in cal(R)} union

\

Let $rho = (#math.italic[row], #math.italic[col])$ indicate the room in row _row_ and column _col_ of the grid, and let's assume the rooms are ordered lexicografically by row and column.

- $S_rho$ is true if room $rho$ is *safe*
- $W_rho$ is true if room $rho$ has the *Wumpus*
- $G_rho$ is true if room $rho$ has *gold*
- $P_rho$ is true if room $rho$ has a *pit*

The *Wumpus world* can be modelle through a series of constraints

#show sym.phi: sym.phi.alt

$
    phi = & phi_"ALO_Wumpus" and phi_"AMO_Wumpus" and \
    & phi_"ALO_Gold" and phi_"AMO_Gold" and \
    & phi_"Stench_1" and phi_"Stench_2" and \
    & phi_"Glitter_1" and phi_"Glitter_2" and \
    & phi_"Breeze_1" and phi_"Breeze_2" and \
    & phi_"Other"... \
    & phi_"Other"... \
$

(ALO) There is at least one room with the Wumpus

$
    phi_"ALO_Wumpus" =
    or.big_(rho in bold(Rho))
    W_rho
$

(AMO) There is at most one room with the Wumpus

$
    phi_"AMO_Wumpus" =
    and.big_(rho, rho' in bold(Rho) \ rho < rho')
    W_rho -> not W_rho'
$

(ALO) There is at least one room with the Gold

$
    phi_"ALO_Gold" =
    or.big_(rho in bold(Rho))
    G_rho
$

(AMO) There is at most one room with the Gold

$
    phi_"AMO_Gold" =
    and.big_(rho, rho' in bold(Rho) \ rho < rho')
    G_rho -> not G_rho'
$

// If a room has Stench then there is a Wumpus near-by
//
// #math.equation(block: true, numbering: none)[
//     $
//         phi_"Stench_2" =
//         and.big_(r in cal(R) \ c in cal(C))
//         "Stench"_(r, c) -> "Wumpus"_(r + 1, c) or "Wumpus"_(r - 1, c) or "Wumpus"_(r, c + 1) or "Wumpus"_(r, c - 1)
//     $
// ]
//
// If a room has Glitter then

// or.big_(r in cal(R) \ c in cal(C))
// and.big_(r, r' in cal(R) \ c, c' in cal(C) \ (r, c) < (r', c'))
// W_(r, c) -> not W_(r', c')

// and.big_(r, r' in cal(R) \ c, c' in cal(C) \ (r, c) < (r', c'))
// "Gold"_(r, c) -> not "Gold"_(r', c')
// In the rooms adjacent to the Wumpus there is Stench
//
// $
//     phi_"Stench_1" =
//     and.big_(r in cal(R) \ c in cal(C))
//     "Wumpus"_(r, c) -> "Stench"
// $
// or.big_(r in cal(R) \ c in cal(C))

// ALO 4 stench
// AMO 4 stench

// phi.alt = & phi.alt_"ALO_pos" and phi.alt_"AMO_pos" and phi.alt_"alldiff" and \
// & phi.alt_"ALO_staz" and phi.alt_"AMO_staz" and phi.alt_"staz" and phi.alt_"dist" and \
// & phi.alt_"ord_1" and phi.alt_"ord_2" and phi.alt_"ord_3" and phi.alt_"ord_4" and not S^1_1 and not S^3_N

// Let's start with static stuff

// Dead(Time),
// Agent(PosX, PosY),
// Safe(PosX, PosY),
// Breeze(Time),
// Glitter(Time),
// Wumpus(PosX, PosY),
// Stench(PosX, PosY),
// Pit(PosX, PosY),
// Scream(Time),
// Bump(Time),
// MoveForward(Time),
// TurnLeft(Time),
// TurnRight(Time),
// GrabGold(Time),
// ShootArrow(Time),
// (ALO) etc...
