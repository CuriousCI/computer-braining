import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class EdgeColouringToSAT {
    public static void main(String args[]) {

        var AEdges = new ArrayList<Integer>();
        // A -> E, H, I, S
        AEdges.add(4);
        AEdges.add(7);
        AEdges.add(8);
        AEdges.add(10);

        var BEdges = new ArrayList<Integer>();
        // B -> C, G2, I, J, S
        BEdges.add(2);
        BEdges.add(6);
        BEdges.add(8);
        BEdges.add(9);
        BEdges.add(10);

        var CEdges = new ArrayList<Integer>();
        // C -> B, D, G2, S
        // CEdges.add(1);
        CEdges.add(3);
        CEdges.add(6);
        CEdges.add(10);

        var DEdges = new ArrayList<Integer>();
        // D -> C, E, S
        // DEdges.add(2);
        DEdges.add(4);
        DEdges.add(10);

        var EEdges = new ArrayList<Integer>();
        // E -> A, D, G1, H
        // EEdges.add(0);
        // EEdges.add(3);
        EEdges.add(5);
        EEdges.add(7);

        var G1Edges = new ArrayList<Integer>();
        // G1 -> E, H
        // G1Edges.add(4);
        G1Edges.add(7);

        var G2Edges = new ArrayList<Integer>();
        // G2 -> B, C, J
        // G2Edges.add(1);
        // G2Edges.add(2);
        G2Edges.add(9);

        var HEdges = new ArrayList<Integer>();
        // H -> A, E, G1, I
        // HEdges.add(0);
        // HEdges.add(4);
        // HEdges.add(5);
        HEdges.add(8);

        var IEdges = new ArrayList<Integer>();
        // I -> A, B, H
        // IEdges.add(0);
        // IEdges.add(1);
        // IEdges.add(7);

        var JEdges = new ArrayList<Integer>();
        // J -> B, G2
        // JEdges.add(1);
        // JEdges.add(6);

        var SEdges = new ArrayList<Integer>();
        // S -> A, B, C, D
        // SEdges.add(0);
        // SEdges.add(1);
        // SEdges.add(2);
        // SEdges.add(3);

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

// Ogni numero in almeno un'urna
// for (var i : numbers.values()) {
// for (var u : urns.values()) {
// encoder.addToClause("X", i, u);
// }
// encoder.endClause();
// }

// Ogni numero in al più un'urna
// for (var i : numbers.values()) {
// for (var u : urns.values()) {
// for (int t = u + 1; t <= 3; t++) {
// encoder.addNegToClause("X", i, u);
// encoder.addNegToClause("X", i, t);
// encoder.endClause();
// }
// }
// }

// Aritmetica
// for (var u : urns.values()) {
// for (int i = 1; i <= n; i++) {
// for (int j = i + 1; i + j <= n; j++) {
// encoder.addNegToClause("X", i, u);
// encoder.addNegToClause("X", j, u);
// encoder.addNegToClause("X", i + j, u);
// encoder.endClause();
// }
// }
// }
