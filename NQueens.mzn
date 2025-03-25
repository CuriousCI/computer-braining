include "alldifferent.mzn";

int: n = 8; /* l'editor va in crash a n = 21 */
array[1..n] of var 1..n: queens;
constraint alldifferent(queens);
constraint forall(i in 1..n, j in (i + 1)..n)(abs(queens[j] - queens[i]) != j - i);
