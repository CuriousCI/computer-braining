#import "template.typ": *

#show: doc => conf([E.A.6.5 (Schur’s Lemma)], doc)

#show math.equation.where(block: true): set block(breakable: true)
#set math.equation(numbering: none)

== Modellazione

=== Variabili

Dato $n >= 1$ siano
- $cal(N) = {1, 2, 3, ..., n}$ l'insieme dei numeri da $1$ a $n$
- $cal(U) = {1, 2, 3}$
- $X = { X_i^u | i in cal(N) and u in cal(U)}$ l'insieme di variabili t.c.
  - $X_i^u$ è vera se l'$i$-esimo numero sta nell'urna $u$

=== Vincoli

$
  & phi.alt = phi.alt_"ogni_numero_in_almeno_un'urna" and \
  & quad phi.alt_"ogni_numero_in_al_più_un'urna" and \
  & quad phi.alt_"aritmetica"
$

\

$
  phi.alt_"ogni_numero_in_almeno_un'urna" & = and.big_(i in cal(N)) (or.big_(u in cal(U)) X_i^u) \
  phi.alt_"ogni_numero_in_al_più_un'urna" & = and.big_(i in cal(N) \ u in cal(U) \ t in cal(U) \ u < t) X_i^u -> not X_i^t \
  phi.alt_"aritmetica" & = and.big_(u in cal(U) \ i in cal(N) \ j in cal(N) \ i < j and \ i + j <= n ) (X_i^u and X_j^u) -> not X_(i + j)^u
$

In particolare

$
  (X_i^u and X_j^u) -> not X_(i + j)^u = \
  not (X_i^u and X_j^u) or not X_(i + j)^u = \
  (not X_i^u or not X_j^u) or not X_(i + j)^u = \
  not X_i^u or not X_j^u or not X_(i + j)^u = \
$

#pagebreak()

== Istanziazione

=== Variabili

Dato $n = 5$ si ha

- $X = { X_1^1, X_1^2, X_1^3, X_2^1, X_2^2, X_2^3, X_3^1, X_3^2, X_3^3, X_4^1, X_4^2, X_4^3, X_5^1, X_5^2, X_5^3 }$

=== Vincoli

$
  & phi.alt_"ogni_numero_in_almeno_un'urna" = ( \
    & quad (X_1^1 or X_1^2 or X_1^3) and \
    & quad (X_2^1 or X_2^2 or X_2^3) and \
    & quad (X_3^1 or X_3^2 or X_3^3) and \
    & quad (X_4^1 or X_4^2 or X_4^3) and \
    & quad (X_5^1 or X_5^2 or X_5^3) \
    & )
$

$
  & phi.alt_"ogni_numero_in_al_più_un'urna" = ( \
    & quad (X_1^1 -> not X_1^2) and (X_1^1 -> not X_1^3) and (X_1^2 -> not X_1^3) and \
    & quad (X_2^1 -> not X_2^2) and (X_2^1 -> not X_2^3) and (X_2^2 -> not X_2^3) and \
    & quad (X_3^1 -> not X_3^2) and (X_3^1 -> not X_3^3) and (X_3^2 -> not X_3^3) and \
    & quad (X_4^1 -> not X_4^2) and (X_4^1 -> not X_4^3) and (X_4^2 -> not X_4^3) and \
    & quad (X_5^1 -> not X_5^2) and (X_5^1 -> not X_5^3) and (X_5^2 -> not X_5^3) \
    & )
$

$
  & phi.alt_"aritmetica" = ( \
    & quad (X_1^1 and X_2^1 -> not X_3^1) and (X_1^1 and X_3^1 -> not X_4^1) and (X_1^1 and X_4^1 -> not X_5^1) and\
    & quad (X_2^1 and X_3^1 -> not X_5^1) and \
    & quad (X_1^2 and X_2^2 -> not X_3^2) and (X_1^2 and X_3^2 -> not X_4^2) and (X_1^2 and X_4^2 -> not X_5^2) and\
    & quad (X_2^2 and X_3^2 -> not X_5^2) and \
    & quad (X_1^3 and X_2^3 -> not X_3^3) and (X_1^3 and X_3^3 -> not X_4^3) and (X_1^3 and X_4^3 -> not X_5^3) and\
    & quad (X_2^3 and X_3^3 -> not X_5^3) and \
    & )
$

#pagebreak()

== Encoder

```java
import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class SchursToSAT {
  public static void main(String args[]) {
    int n = 32;

    var numbers = new IntRange("numbers", 1, n);
    var urns = new IntRange("urns", 1, 3);

    var encoder = new SATEncoder("Schurs", "schurs.cnf");
    encoder.defineFamilyOfVariables("X", numbers, urns);

    // Ogni numero in almeno un'urna
    for (var i : numbers.values() ) {
      for (var u : urns.values()) {
        encoder.addToClause("X", i, u);
      }
      encoder.endClause();
    }

    // Ogni numero in al più un'urna
    for (var i : numbers.values()) {
      for (var u : urns.values()) {
        for (int t = u + 1; t <= 3; t++) {
          encoder.addNegToClause("X", i, u);
          encoder.addNegToClause("X", i, t);
          encoder.endClause();
        }
      }
    }

    // Aritmetica
    for (var u : urns.values()) {
      for (int i = 1; i <= n; i ++) {
        for (int j = i + 1; i + j <= n; j ++) {
          encoder.addNegToClause("X", i, u);
          encoder.addNegToClause("X", j, u);
          encoder.addNegToClause("X", i + j, u);
          encoder.endClause();
        }
      }
    }

    encoder.end();
  }
}
```

== Decoder

```java
import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class SATToSchurs {
  public static void main(String args[]) throws java.io.IOException, java.io.FileNotFoundException {
    var decoder = new SATModelDecoder(args);
    decoder.run();

    int maxVar = decoder.getMaxVar();
    int n = maxVar / 3;

    ArrayList<ArrayList<Integer>> urns = new ArrayList();
    urns.add(new ArrayList<Integer>());
    urns.add(new ArrayList<Integer>());
    urns.add(new ArrayList<Integer>());

    for (int i = 1; i <= maxVar; i++) {
			Boolean v_i = decoder.getModelValue(i);
      if (v_i == null || !v_i) continue;

			SATModelDecoder.Var variable = decoder.decodeVariable(i);
			int number = variable.getIndices().get(0);
			int urn = variable.getIndices().get(1) - 1;

      urns.get(urn).add(number);
    }

    for (var urn : urns) {
      for (var number : urn) {
        System.out.print("" + number + ", ");
      }
      System.out.println();
    }
    System.out.println();
  }
}
```
