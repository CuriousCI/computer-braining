#import "template.typ": *

#show: doc => conf([E.A.6.4 ($n$-Queens)], doc)

#show math.equation.where(block: true): set block(breakable: true)
#set math.equation(numbering: none)

== Modellazione

=== Variabili

Dato $n >= 1$ siano
- $cal(N) = {1, 2, 3, ..., n}$ l'insieme dei numeri da $1$ a $n$
- $Q = { Q_(i, j) | i in cal(N) and j in cal(N)}$ l'insieme delle variabili t.c.
  - $Q_(i,j) "è vera se all'"i"-esima riga e" j"-esima colonna è presente una regina"$

=== Vincoli

$
  & phi.alt = phi.alt_"almeno_una_regina_per_colonna" and \
  & quad phi.alt_"no_due_regine_stessa_colonna" and \
  & quad phi.alt_"no_due_regine_stessa_riga" and \
  & quad phi.alt_"no_due_regine_stessa_diagonale" \
$

\

$
  phi_"almeno_una_regina_per_colonna" & = and.big_(c in cal(N)) ( or.big_(r in cal(N)) Q_(r, c) ) \
  phi_"no_due_regine_stessa_colonna" & = and.big_(c in cal(N) \ i in cal(N) \ j in cal(N) \ i < j) Q_(i, c) -> not Q_(j, c) \
  phi_"no_due_regine_stessa_riga" & = and.big_(r in cal(N) \ i in cal(N) \ j in cal(N) \ i < j) Q_(r, i) -> not Q_(r, j) \
  phi_"no_due_regine_stessa_diagonale" & = and.big_(r in cal(N) \ c in cal(N) \ r' in cal(N) \ c' in cal(N) \ |r - r'| = |c - c'| and \ (r != r' or c != c')) Q_(r, c) -> not Q_(r', c')
$

#pagebreak()

== Istanza $n = 4$

=== Variabili

Dato $n = 4$ si ha

- $& Q = { \
    & quad Q_(1, 1), Q_(1, 2), Q_(1, 3), Q_(1, 4), \
    & quad Q_(2, 1), Q_(2, 2), Q_(2, 3), Q_(2, 4), \
    & quad Q_(3, 1), Q_(3, 2), Q_(3, 3), Q_(3, 4), \
    & quad Q_(4, 1), Q_(4, 2), Q_(4, 3), Q_(4, 4) \
    & }$

=== Vincoli

$
  & phi_"almeno_una_regina_per_colonna" = ( \
    & quad (Q_(1, 1) or Q_(2, 1) or Q_(3, 1) or Q_(4, 1)) and \
    & quad (Q_(1, 2) or Q_(2, 2) or Q_(3, 2) or Q_(4, 2)) and \
    & quad (Q_(1, 3) or Q_(2, 3) or Q_(3, 3) or Q_(4, 3)) and \
    & quad (Q_(1, 4) or Q_(2, 4) or Q_(3, 4) or Q_(4, 4)) \
    & ) \
$
$
  & phi_"no_due_regine_stessa_colonna" = ( \
    & quad (Q_(1, 1) -> not Q_(2, 1)) and (Q_(1, 1) -> not Q_(3, 1)) and (Q_(1, 1) -> not Q_(4, 1)) and \
    & quad (Q_(2, 1) -> not Q_(3, 1)) and (Q_(2, 1) -> not Q_(4, 1)) and \
    & quad (Q_(3, 1) -> not Q_(4, 1)) and \
    & quad (Q_(1, 2) -> not Q_(2, 2)) and (Q_(1, 2) -> not Q_(3, 2)) and (Q_(1, 2) -> not Q_(4, 2)) and \
    & quad (Q_(2, 2) -> not Q_(3, 2)) and (Q_(2, 2) -> not Q_(4, 2)) and \
    & quad (Q_(3, 2) -> not Q_(4, 2)) and \
    & quad (Q_(1, 3) -> not Q_(2, 3)) and (Q_(1, 3) -> not Q_(3, 3)) and (Q_(1, 3) -> not Q_(4, 3)) and \
    & quad (Q_(2, 3) -> not Q_(3, 3)) and (Q_(2, 3) -> not Q_(4, 3)) and \
    & quad (Q_(3, 3) -> not Q_(4, 3)) and \
    & quad (Q_(1, 4) -> not Q_(2, 4)) and (Q_(1, 4) -> not Q_(3, 4)) and (Q_(1, 4) -> not Q_(4, 4)) and \
    & quad (Q_(2, 4) -> not Q_(3, 4)) and (Q_(2, 4) -> not Q_(4, 4)) and \
    & quad (Q_(3, 4) -> not Q_(4, 4)) and \
    & )
$

$
  & phi_"no_due_regine_stessa_riga" = ( \
    & quad (Q_(1, 1) -> not Q_(1, 2)) and (Q_(1, 1) -> not Q_(1, 3)) and (Q_(1, 1) -> not Q_(1, 4)) and \
    & quad (Q_(1, 2) -> not Q_(1, 3)) and (Q_(1, 2) -> not Q_(1, 4)) and \
    & quad (Q_(1, 3) -> not Q_(1, 4)) and \
    & quad (Q_(2, 1) -> not Q_(2, 2)) and (Q_(2, 1) -> not Q_(2, 3)) and (Q_(2, 1) -> not Q_(2, 4)) and \
    & quad (Q_(2, 2) -> not Q_(2, 3)) and (Q_(2, 2) -> not Q_(2, 4)) and \
    & quad (Q_(2, 3) -> not Q_(2, 4)) and \
    & quad (Q_(3, 1) -> not Q_(3, 2)) and (Q_(3, 1) -> not Q_(3, 3)) and (Q_(3, 1) -> not Q_(3, 4)) and \
    & quad (Q_(3, 2) -> not Q_(3, 3)) and (Q_(3, 2) -> not Q_(3, 4)) and \
    & quad (Q_(3, 3) -> not Q_(3, 4)) and \
    & quad (Q_(4, 1) -> not Q_(4, 2)) and (Q_(4, 1) -> not Q_(4, 3)) and (Q_(4, 1) -> not Q_(4, 4)) and \
    & quad (Q_(4, 2) -> not Q_(4, 3)) and (Q_(4, 2) -> not Q_(4, 4)) and \
    & quad (Q_(4, 3) -> not Q_(4, 4)) and \
    & )
$

$
  & phi_"no_due_regine_stessa_diagonale" = ( \
    & quad (Q_(1, 1) -> not Q_(2, 2)) and (Q_(1, 1) -> not Q_(3, 3)) and (Q_(1, 1) -> not Q_(4, 4)) and \
    & quad (Q_(1, 2) -> not Q_(2, 1)) and (Q_(1, 2) -> not Q_(2, 3)) and (Q_(1, 2) -> not Q_(3, 4)) and \
    & quad (Q_(1, 3) -> not Q_(2, 2)) and (Q_(1, 3) -> not Q_(2, 4)) and (Q_(1, 3) -> not Q_(3, 1)) and \
    & quad (Q_(1, 4) -> not Q_(2, 3)) and (Q_(1, 4) -> not Q_(3, 2)) and (Q_(1, 4) -> not Q_(4, 1)) and \
    & quad (Q_(2, 1) -> not Q_(1, 2)) and (Q_(2, 1) -> not Q_(3, 2)) and (Q_(2, 1) -> not Q_(4, 3)) and \
    & quad (Q_(2, 2) -> not Q_(1, 1)) and (Q_(2, 2) -> not Q_(1, 3)) and (Q_(2, 2) -> not Q_(3, 1)) and \
    & quad (Q_(2, 2) -> not Q_(3, 3)) and (Q_(2, 2) -> not Q_(4, 4)) and (Q_(2, 3) -> not Q_(1, 2)) and \
    & quad (Q_(2, 3) -> not Q_(1, 4)) and (Q_(2, 3) -> not Q_(3, 2)) and (Q_(2, 3) -> not Q_(3, 4)) and \
    & quad (Q_(2, 3) -> not Q_(4, 1)) and (Q_(2, 4) -> not Q_(1, 3)) and (Q_(2, 4) -> not Q_(3, 3)) and \
    & quad (Q_(2, 4) -> not Q_(4, 2)) and (Q_(3, 1) -> not Q_(1, 3)) and (Q_(3, 1) -> not Q_(2, 2)) and \
    & quad (Q_(3, 1) -> not Q_(4, 2)) and (Q_(3, 2) -> not Q_(1, 4)) and (Q_(3, 2) -> not Q_(2, 1)) and \
    & quad (Q_(3, 2) -> not Q_(2, 3)) and (Q_(3, 2) -> not Q_(4, 1)) and (Q_(3, 2) -> not Q_(4, 3)) and \
    & quad (Q_(3, 3) -> not Q_(1, 1)) and (Q_(3, 3) -> not Q_(2, 2)) and (Q_(3, 3) -> not Q_(2, 4)) and \
    & quad (Q_(3, 3) -> not Q_(4, 2)) and (Q_(3, 3) -> not Q_(4, 4)) and (Q_(3, 4) -> not Q_(1, 2)) and \
    & quad (Q_(3, 4) -> not Q_(2, 3)) and (Q_(3, 4) -> not Q_(4, 3)) and (Q_(4, 1) -> not Q_(1, 4)) and \
    & quad (Q_(4, 1) -> not Q_(2, 3)) and (Q_(4, 1) -> not Q_(3, 2)) and (Q_(4, 2) -> not Q_(2, 4)) and \
    & quad (Q_(4, 2) -> not Q_(3, 1)) and (Q_(4, 2) -> not Q_(3, 3)) and (Q_(4, 3) -> not Q_(2, 1)) and \
    & quad (Q_(4, 3) -> not Q_(3, 2)) and (Q_(4, 3) -> not Q_(3, 4)) and (Q_(4, 4) -> not Q_(1, 1)) and \
    & quad (Q_(4, 4) -> not Q_(2, 2)) and (Q_(4, 4) -> not Q_(3, 3)) \
    & )
$

#pagebreak()

== Encoder

È scritto molto male e non usa a pieno la libreria, me ne rendo conto. Ho voluto solo testare un po' tutti i tool al volo.

```java
import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class Main {
  public static void main(String args[])  {
    int n = 4;
    var N = new IntRange("coords", 1, n);
    var NN = new RangeProduct("matrix", N, N);

    var encoder = new SATEncoder("n-Queens", "n-Queens.cnf");
    encoder.defineFamilyOfVariables("Q", NN);
    for (int c = 1; c <= n; c++) {
      for (int r = 1; r <= n; r++) {
        encoder.addToClause("Q", r, c);
      }
      encoder.endClause();
    }


    for (int c = 1; c <= n; c++) {
      for (int i = 1; i <= n; i++) {
        for (int j = i + 1; j <= n; j++) {
          encoder.addNegToClause("Q", i, c);
          encoder.addNegToClause("Q", j, c);
          encoder.endClause();
          encoder.addNegToClause("Q", c, i);
          encoder.addNegToClause("Q", c, j);
          encoder.endClause();
        }
      }
    }

    for (int r1 = 1; r1 <= n; r1++) {
      for (int c1 = 1; c1 <= n; c1++) {
        for (int r2 = 1; r2 <= n; r2++) {
          for (int c2 = 1; c2 <= n; c2++) {
            if (r1 != r2 && c1 != c2) {
              if (Math.abs(r1 - r2) == Math.abs(c1 - c2)) {
                encoder.addNegToClause("Q", r1, c1);
                encoder.addNegToClause("Q", r2, c2);
                encoder.endClause();
              }
            }
          }
        }
      }
    }

    encoder.end();
  }
}
```
