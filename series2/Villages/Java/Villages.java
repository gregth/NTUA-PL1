
import java.io.IOException;

/**
 * Reads a list of villages connected by roads, a number of roads to create
 * and calculates the minimum possible villages after creating those roads
 * Created by Jason on 17/7/2017.
 */

public class Villages {
    public static void main(String[] args) {
        try {
            VillagesReader reader = new VillagesReader(args[0]);
            Solver solver = new Solver(reader.getVillages().getCount(), reader.getK());
            System.out.println(solver.getAnswer());
        }
        catch(IOException e) {
            System.out.println("File reading gone wrong! :(");
        }
    }
}
