#import "template.typ": *

#show: doc => conf([E.A.5.10 (Protein Folding)], doc)

== Question 1 _(the protein must be valid)_

Define the schema of a problem instance $I$ suitable for CSP modelling.

Let $S = {S_1, S_2, ..., S_N}$ be a sequence of length $N$ with $S_n in {H, P}$, $cal(N) = {1, ..., N}$ and $(X, D, C)$ s.t.

$
    X = { X_n | n in cal(N) } union { Y_n | n in cal(N) }
$

- $X_n$ is the $x$ coordinate of protein $n$
- $Y_n$ is the $y$ coordinate of protein $n$

All the variables have domains $D = {-N, -N + 1, ..., 0, ... N - 1, N}$

$
    C = C_"adj" union C_"alldiff"
$

All the amino-acids have a different position


== Question 2 _(it must at least some contacts)_

Define the problem of finding a 2D-folding of the protein given as instance $I$ with at least a given number $k in NN$ of contacts as a CSP specification.

== Question 3 _(now optimize it)_

Define the problem of finding a 2D-folding of the protein given as instance $I$ with the
maximum number $k in NN$ of contacts as a Constraint Optimisation Problem specification.
