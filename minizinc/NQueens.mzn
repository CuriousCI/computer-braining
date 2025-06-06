include "alldifferent.mzn";

int: n = 4;
array[1..n] of var 1..n: queens;
constraint alldifferent(queens);
% constraint forall(i in 1..n, j in 1..n)(j != i -> abs(queens[j] - queens[i]) != abs(j - i));
% constraint forall(i in 1..n, j in i + 1..n)(abs(queens[j] - queens[i]) != abs(j - i));
