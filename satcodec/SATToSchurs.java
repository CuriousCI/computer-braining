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
