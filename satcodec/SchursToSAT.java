import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class SchursToSAT {
    public static void main(String args[]) {
        int n = 16;

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
