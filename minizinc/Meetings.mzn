include "globals.mzn";

int: N;
int: K;
int: M;
int: T;
int: S;

% int: N = 6;
% int: K = 3;
% int: M = 8;
% int: T = 5;
% int: S = 6;

int: R = min(N div K, S);

array[1..T, 1..R, 1..K] of var 1..N: X;
array[1..T] of var 0..R: Y;

constraint sum(t in 1..T)(Y[t]) = M;

constraint forall(t in 1..T)(
  alldifferent([X[t, r, k] | r in 1..R, k in 1..K])
);

constraint forall(t in 1..T, r in 1..R, k in 1..K - 1)(
  X[t, r, k] < X[t, r, k + 1]
);

constraint forall(i in 1..N - 1, j in i + 1..N)( 
  exists(t in 1..T, r in 1..R, k in 1..K - 1, l in k + 1..K)(
    X[t, r, k] = i /\ X[t, r, l] = j /\ r <= Y[t] 
  )
);

output[
  "turn" ++ show(t) ++ ": | " ++ concat(
    [concat([show_int(-2, X[t, r, k]) ++ " " | k in 1..K]) ++ "| " | r in 1..R]
  ) ++ "\n" | t in 1..T
];

output [show(Y[t]) ++ " " | t in 1..T];

% output [show(Z[n, m]) ++ " " | n in 1..N - 1, m in n + 1..N];
