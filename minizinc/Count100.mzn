include "globals.mzn";

% int: n = 6;
% array [1..n, 1..n] of var 1..n * n: M;
% constraint alldifferent(M);

% constraint forall(x in 1..n, y in 1..n)(
%   exists(px in 1..n, py in 1..n)(
%     (M[x, y] = M[px, py] + 1 \/ M[x, y] = 1) /\
%     (
%       (abs(x - px) = 3 /\ y = py) \/
%       (abs(y - py) = 3 /\ x = px) \/
%       (abs(x - px) = 2 /\ abs(y - py) = 2)
%     )
%   )  
% );

int: n = 6;
type Coord = var record(var 1..n: x, var 1..n: y);
array [1..n * n] of Coord: A;

constraint alldifferent([A[i].y * n + A[i].x | i in 1..n * n]);
constraint forall(i in 2..n * n)(
  (abs(A[i].x - A[i - 1].x) = 3 /\ A[i].y = A[i - 1].y) \/
  (abs(A[i].y - A[i - 1].y) = 3 /\ A[i].x = A[i - 1].x) \/
  (abs(A[i].x - A[i - 1].x) = 2 /\ abs(A[i].y - A[i - 1].y) = 2)
);

% solve :: int_search(A, first_fail, indomain_split) satisfy;

% solve :: 
%     int_search([x], first_fail, indomain_split),
%     int_search([y], impact, indomain_median)
% satisfy;