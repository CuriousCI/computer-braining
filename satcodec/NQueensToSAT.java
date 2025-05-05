import it.uniroma1.di.tmancini.utils.*;
import it.uniroma1.di.tmancini.teaching.ai.SATCodec.*;
import java.util.*;

public class NQueensToSAT {
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
                                System.out.println("Q_(" + r1 + ", " + c1 + ") -> not Q_(" + r2 + ", " + c2 + "),");
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
