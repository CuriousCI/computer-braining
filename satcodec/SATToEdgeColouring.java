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
