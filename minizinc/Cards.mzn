include "globals.mzn";

int: k = 2;
int: n = 4;


array[1..k * n] of var 1..n: cards;
array[1..k * n] of var 1..k * n: positions;

constraint forall(i in 1..n, j in 1..k)(cards[(i - 1) * k + j] == i);

constraint forall(i in 0..n - 1, j in 2..k)(positions[i * k + j] == positions[i * k + j - 1] + cards[i * k + j] + 1);

constraint all_different(positions);

% gcc(positions,[1, 1, 1, 1, 1, 1, 1, 1])?



% array[1..k * n] of var 1..n: cards;

% constraint forall(i in 1..n * k, j in i + 1..n * k)(cards[i] == cards[j] -> j - i == cards[j] + 1);

% array[1..n] of var {k}: counts;
% constraint global_cardinality(cards, 1..n, counts);



% array[1..k * n] of var 1..n: cards;

% constraint forall(i in 1..n * k, j in i + 1..n * k)(cards[i] == cards[j] -> ((j - i) mod (cards[j] + 1)) == 0);

% % constraint forall(i in 1..n)(exactly(k, cards, i)); % deprecated
% constraint forall(i in 1..n)(count(j in cards)(j=i) = k);
