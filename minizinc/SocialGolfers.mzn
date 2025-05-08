include "globals.mzn";

int: card_P = 9;
int: W = 4;
int: G = 3;
int: S = card_P div G;

% |P|=16, W=8, G = 8
% |P|=24, W=8, G = 8
% |P|=9, W=4, G = 3

array[1..W, 1..G, 1..S] of var 1..card_P: X;

constraint forall(w in 1..W)(
  alldifferent([X[w,g,p] | g in 1..G, p in 1..S])
);

constraint forall(w in 1..W, g in 1..G, p in 1..S - 1)(
  X[w,g,p] < X[w,g,p+1]
);

constraint forall(w in 1..W, g in 1..G - 1)(
  X[w,g,1] < X[w, g+1, 1]
);

constraint forall(w1 in 1..W, w2 in w1 + 1..W, g1 in 1..G, g2 in 1..G, i1 in 1..S, j1 in i1 + 1..S, i2 in 1..S, j2 in i2 + 1..S)(
  X[w1, g1, i1] = X[w2, g2, i2] -> X[w1, g1, j1] != X[w2, g2, j2] 
);

output [
  "week " ++ show(w) ++ ": | " ++ concat(
     [concat([show_int(-2, X[w, g, p]) ++ " " | p in 1..S]) ++ "| " | g in 1..G] 
   ) ++ "\n" | w in 1..W
];