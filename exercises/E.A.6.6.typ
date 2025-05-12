#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
#import "template.typ": *

#show: doc => conf([E.A.6.6 (Edge Colouring)], doc)

#show math.equation.where(block: true): set block(breakable: true)
#set math.equation(numbering: none)

== Modellazione

Dato un grafo non diretto $G = (V, E)$ siano
- $cal(C) = {1, 2, 3}$

- $X = { X_(u, v)^c | (u, v) in E and c in cal(C) and u < v}$ l'insieme di variabili t.c.
  - $X_(u, v)^c$ è vera se l'arco $(u, v) in E$ ha colore $c$

\

$
  phi.alt = phi.alt_"almeno_un_colore_per_arco" and phi.alt_"al_più_un_colore_per_arco" and phi.alt_"triangoli"
$

\

$
  phi.alt_"almeno_un_colore_per_arco" & = and.big_((u, v) in E \ u < v) (or.big_(c in cal(C)) X_(u, v)^c) \
  phi.alt_"al_più_un_colore_per_arco" & = and.big_((u, v) in E \ c_1, c_2 in cal(C) \ u < v \ \ c_1 < c_2) (X_(u, v)^(c_1) -> not X_(u, v)^(c_2)) \
  phi.alt_"triangoli" & = and.big_(u, v, w in V \ (u, v), (v, w), (u, w) in E \ c in cal(C) \ u < v < w) (X_(u, v)^c and X_(v, w)^c -> not X_(u, w)^c)
$

#pagebreak()

== Istanziazione

// A -> E, H, I, S
// B -> C, G2, I, J, S
// C -> B, D, G2, S
// D -> C, E, S
// E -> A, D, G1, H
// G1 -> E, H
// G2 -> B, C, J
// H -> A, E, G1, I
// I -> A, B, H
// J -> B, G2
// S -> A, B, C, D

#let E = (
  ("A", "E"),
  ("A", "H"),
  ("A", "I"),
  ("A", "S"),
  ("B", "C"),
  ("B", "G2"),
  ("B", "I"),
  ("B", "J"),
  ("B", "S"),
  // ("C", "B"),
  ("C", "D"),
  ("C", "G2"),
  ("C", "S"),
  // ("D", "C"),
  ("D", "E"),
  ("D", "S"),
  // ("E", "A"),
  // ("E", "D"),
  ("E", "G1"),
  ("E", "H"),
  // ("G1", "E"),
  ("G1", "H"),
  // ("G2", "B"),
  // ("G2", "C"),
  ("G2", "J"),
  // ("H", "A"),
  // ("H", "E"),
  // ("H", "G1"),
  ("H", "I"),
  // ("I", "A"),
  // ("I", "B"),
  // ("I", "H"),
  // ("J", "B"),
  // ("J", "G2"),
  // ("S", "A"),
  // ("S", "B"),
  // ("S", "C"),
  // ("S", "D"),
)

=== Variabili

Dato $G = (V, E)$ come in Figura 1.1 si ha
- $
    & X = { \
      #let i = 0;
      #for (u, v) in E [
        #if i == 0 { $& quad$ }
        #for c in range(1, 4) {
          $X_(#u, #v)^#c,$
          i += 1
        }
        #if i == 6 {
          i = 0
          linebreak()
        }
      ] \
    }
  $

=== Vincoli

$
  & phi_"almeno_un_colore_per_arco" = { \
    #let i = 0
    #for (index, (u, v)) in E.enumerate() {
      if i == 0 { $& quad$ }
      [(]
      for c in range(1, 4) [ $X_(#u, #v)^#c #if c != 3 [ $or$ ]$ ]
      [)]
      if index != E.len() - 1 { $and$ }

      i += 1
      if i == 2 {
        i = 0
        linebreak()
      }
    } \
    & }
$

\

$
  & phi_"al_più_un_colore_per_arco" = { \
    #let i = 0
    #for (index, (u, v)) in E.enumerate() {
      for c1 in range(1, 4) {
        for c2 in range(c1 + 1, 4) {
          $#if i == 0 { $& quad$ } (not X_(#u, #v)^#c1 or not X_(#u, #v)^#c2) #if index != E.len() - 1 or c2 != 3 or c1 != 2 { $and$ }$
          i += 1
          if i == 3 {
            i = 0
            linebreak()
          }
        }
      }
    }
    & }
$

\

$
  & phi_"triangoli" = { \
    #let i = 0
    #for (u, v) in E {
      for (v1, w) in E {
        if v1 == v and u < v and v < w and (u, w) in E {
          for c in range(1, 4) {
            $#if i == 0 { $& quad$ } (not X_(#u, #v)^#c or not X_(#v, #w)^#c or not X_(#u, #w)^#c ) and$
            i += 1
            if i == 2 {
              i = 0
              linebreak()
            }
          }
        }
      }
    } \
    & }
$

// #E

//    A  B  C  D  E  1  2  H  I  J  S
// A: -  -  -  -  X  -  -  X  X  -  X
// B: -  -  X  -  -  -  X  -  X  X  X
// C: -  X  -  X  -  -  X  -  -  -  X
// D: -  -  X  -  X  -  -  -  -  -  X
// E: X  -  -  X  -  X  -  X  -  -  -
// 1: -  -  -  -  X  -  -  X  -  -  -
// 2: -  X  X  -  -  -  -  -  -  X  -
// H: X  -  -  -  X  X  -  -  X  -  -
// I: X  X  -  -  -  -  -  X  -  -  -
// J: -  X  -  -  -  -  X  -  -  -  -
// S: X  X  X  X  -  -  -  -  -  -  -

//    A  B  C  D  E  1  2  H  I  J  S
// A: -  -  -  -  X  -  -  X  X  -  X
// B: -  -  X  -  -  -  X  -  X  X  X
// C: -  X  -  X  -  -  X  -  -  -  X
// D: -  -  X  -  X  -  -  -  -  -  X
// E: X  -  -  X  -  X  -  X  -  -  -
// 1: -  -  -  -  X  -  -  X  -  -  -
// 2: -  X  X  -  -  -  -  -  -  X  -
// H: X  -  -  -  X  X  -  -  X  -  -
// I: X  X  -  -  -  -  -  X  -  -  -
// J: -  X  -  -  -  -  X  -  -  -  -
// S: X  X  X  X  -  -  -  -  -  -  -
//    A  B  C  D  E  1  2  H  I  J  S
// A: 1  1  1  1  2  1  1  1  2  1  1
// B: 1  1  1  1  1  1  1  1  1  2  2
// C: 1  1  1  2  1  1  2  1  1  1  1
// D: 1  1  2  1  1  1  1  1  1  1  1
// E: 2  1  1  1  1  2  1  1  1  1  1
// 1: 1  1  1  1  2  1  1  1  1  1  1
// 2: 1  1  2  1  1  1  1  1  1  1  1
// H: 1  1  1  1  1  1  1  1  1  1  1
// I: 2  1  1  1  1  1  1  1  1  1  1
// J: 1  2  1  1  1  1  1  1  1  1  1
// S: 1  2  1  1  1  1  1  1  1  1  1



#pagebreak()

== Codifica in SATCodec

=== EdgeColouringToSAT

```java
import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class EdgeColouringToSAT {
  public static void main(String args[]) {

    var AEdges = new ArrayList<Integer>();
    AEdges.add(4);
    AEdges.add(7);
    AEdges.add(8);
    AEdges.add(10);

    var BEdges = new ArrayList<Integer>();
    BEdges.add(2);
    BEdges.add(6);
    BEdges.add(8);
    BEdges.add(9);
    BEdges.add(10);

    var CEdges = new ArrayList<Integer>();
    CEdges.add(3);
    CEdges.add(6);
    CEdges.add(10);

    var DEdges = new ArrayList<Integer>();
    DEdges.add(4);
    DEdges.add(10);

    var EEdges = new ArrayList<Integer>();
    EEdges.add(5);
    EEdges.add(7);

    var G1Edges = new ArrayList<Integer>();
    G1Edges.add(7);

    var G2Edges = new ArrayList<Integer>();
    G2Edges.add(9);

    var HEdges = new ArrayList<Integer>();
    HEdges.add(8);

    var IEdges = new ArrayList<Integer>();
    var JEdges = new ArrayList<Integer>();
    var SEdges = new ArrayList<Integer>();

    var edges = new ArrayList<ArrayList<Integer>>();
    edges.add(AEdges);
    edges.add(BEdges);
    edges.add(CEdges);
    edges.add(DEdges);
    edges.add(EEdges);
    edges.add(G1Edges);
    edges.add(G2Edges);
    edges.add(HEdges);
    edges.add(IEdges);
    edges.add(JEdges);
    edges.add(SEdges);

    // A = 0
    // B = 1
    // C = 2
    // D = 3
    // E = 4
    // G1 = 5
    // G2 = 6
    // H = 7
    // I = 8
    // J = 9
    // S = 10

    var colorsRange = new IntRange("colors", 1, 3);
    var edgesRange = new IntRange("edges", 0, 10);

    var encoder = new SATEncoder("EdgeColuring", "edge-colouring.cnf");
    encoder.defineFamilyOfVariables("X", edgesRange, edgesRange, colorsRange);

    // Almeno un colore per arco
    for (Integer u : edgesRange.values()) {
      for (Integer v : edges.get(u)) {
        if (u < v) {
          for (Integer c : colorsRange.values()) {
            encoder.addToClause("X", u, v, c);
          }
          encoder.endClause();
        }
      }
    }

    // Al più un colore per arco
    for (Integer u : edgesRange.values()) {
      for (Integer v : edges.get(u)) {
        if (u < v) {
          for (Integer c1 : colorsRange.values()) {
            for (int c2 = c1 + 1; c2 <= 3; c2++) {
              encoder.addNegToClause("X", u, v, c1);
              encoder.addNegToClause("X", u, v, c2);
              encoder.endClause();
            }
          }
        }
      }
    }

    // Triangoli
    for (Integer u : edgesRange.values()) {
      for (Integer v : edgesRange.values()) {
        for (Integer w : edgesRange.values()) {
          if (u < v && v < w && edges.get(u).contains(v) && edges.get(v).contains(w)
              && edges.get(u).contains(w)) {
            for (Integer c : colorsRange.values()) {
              encoder.addNegToClause("X", u, v, c);
              encoder.addNegToClause("X", v, w, c);
              encoder.addNegToClause("X", u, w, c);
              encoder.endClause();
            }
          }
        }
      }
    }

    encoder.end();
  }
}
```

// A -> E : 3
// A -> H : 3
// A -> I : 3
// A -> S : 3
// B -> C : 3
// B -> G2 : 3
// B -> I : 3
// B -> J : 3
// B -> S : 3
// C -> D : 3
// C -> G2 : 2
// C -> S : 2
// D -> E : 3
// D -> S : 3
// E -> G1 : 3
// E -> H : 2
// G1 -> H : 3
// G2 -> J : 2
// H -> I : 2

=== SATToEdgeColouring

```java
import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class SATToEdgeColouring {
  public static void main(String args[]) throws java.io.IOException, java.io.FileNotFoundException {
    String[] variables = { "A", "B", "C", "D", "E", "G1", "G2", "H", "I", "J", "S" };

    var decoder = new SATModelDecoder(args);
    decoder.run();

    int maxVar = decoder.getMaxVar();
    for (int i = 1; i <= maxVar; i++) {
      Boolean v_i = decoder.getModelValue(i);
      if (v_i == null || !v_i)
        continue;

      SATModelDecoder.Var variable = decoder.decodeVariable(i);
      int u = variable.getIndices().get(0);
      int v = variable.getIndices().get(1);
      int c = variable.getIndices().get(2);
      System.out.println(variables[u] + " -> " + variables[v] + " : " + c);
    }
    System.out.println("-- STOP HERE");
  }
}
```

\

#let green = rgb("#b8bb26")
#let blue = rgb("#83a598")
#let yellow = rgb("#fabd2f")

#figure(caption: [soluzione generata da `picosat`])[
  #diagram(
    node-stroke: .5pt + black,
    node-shape: circle,
    edge-stroke: 1pt + yellow,
    spacing: 2em,
    label-sep: .5pt,

    node((4, 1), [*A*], name: <A>),
    edge(<A>, <E>, "-"),
    edge(<A>, <H>, "-"),
    edge(<A>, <I>, "-"),
    edge(<A>, <S>, "-"),

    node((6, 1), [*B*], name: <B>),
    edge(<B>, <C>, "-"),
    edge(<B>, <G2>, "-"),
    edge(<B>, <I>, "-"),
    edge(<B>, <J>, "-"),
    edge(<B>, <S>, "-"),

    node((6, 3), [*C*], name: <C>),
    edge(<C>, <D>, "-"),
    edge(<C>, <G2>, "-", stroke: blue),
    edge(<C>, <S>, "-", stroke: blue),

    node((2, 3), [*D*], name: <D>),
    edge(<D>, <E>, "-"),
    edge(<D>, <S>, "-"),

    node((1, 2), [*E*], name: <E>),
    edge(<E>, <G1>, "-"),
    edge(<E>, <H>, "-", stroke: blue),

    node((0, 0), [*G1*], name: <G1>),
    edge(<G1>, <H>, "-"),

    node((7, 1), [*G2*], name: <G2>),
    edge(<G2>, <J>, "-", stroke: blue),

    node((2, 0), [*H*], name: <H>),
    edge(<H>, <I>, "-", stroke: blue),

    node((4, 0), [*I*], name: <I>),

    node((6, 0), [*J*], name: <J>),

    node((4, 2), [*S*], name: <S>),
  )
]
