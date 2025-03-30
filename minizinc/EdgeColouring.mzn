% include "alldifferent.mzn";

% A, B, C, D, E, G1, G2, H, I, J,  S
% 1, 2, 3, 4, 5,  6,  7, 8, 9, 10, 11

% A -> E, H, I, S
% B -> C, G2, I, J, S
% C -> B, D, G2, S
% D -> C, E, S
% E -> A, D, G1, H
% G1 -> E, H
% G2 -> B, C, J
% H -> A, E, G1, I
% I -> A, B, H
% J -> B, G2
% S -> A, B, C, D

% 1 -> 5, 8, 9, 11
% 2 -> 3, 7, 9, 10, 11
% 3 -> 2, 4, 7, 11
% 4 -> 3, 5, 11
% 5 -> 1, 4, 6, 8
% 6 -> 5, 8
% 7 -> 2, 3, 10
% 8 -> 1, 5, 6, 9
% 9 -> 1, 2, 8
% 10 -> 2, 7
% 11 -> 1, 2, 3, 4

set of int: V = 1..11;
array [V, V] of var 1..3: C;

any: E = [|
    false, false, false, false, true, false, false, true, true, false, true |
    false, false, true, false, false, false, true, false, true, true, true |
    false, true, false, true, false, false, true, false, false, false, true |
    false, false, true, false, true, false, false, false, false, false, true |
    true, false, false, true, false, true, false, true, false, false, false |
    false, false, false, false, true, false, false, true, false, false, false |
    false, true, true, false, false, false, false, false, false, true, false |
    true, false, false, false, true, true, false, false, true, false, false |
    true, true, false, false, false, false, false, true, false, false, false |
    false, true, false, false, false, false, true, false, false, false, false |
    true, true, true, true, false, false, false, false, false, false, false
|];

constraint  forall(i in V, j in V, k in V)(
    (E[k, i] /\ E[k, j] /\ E[i, j]) -> (C[k, i] == C[k, j] -> C[k, i] != C[i, j])
);

constraint  forall(i in V, j in V)(
    C[i, j] == C[j, i]
);
