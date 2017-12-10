
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Reads number of villages n, number of existing roads m, number of new roads k.
 * Created by Jason on 17/7/2017.
 */

public class VillagesReader extends BufferedReader {
    private int m, k;
    private UF villages;
    
    VillagesReader(String filepath) throws IOException {
        super(new FileReader(filepath));
        String line = this.readLine();
        String[] words = line.split("\\s+"); // Split line in words
        int n = Integer.parseInt(words[0]);
        m = Integer.parseInt(words[1]);
        k = Integer.parseInt(words[2]);
        villages = new UF(n);

        //Read paths between villages
        for(int i = 0; i < m; i++) {
            line = this.readLine();
            words = line.split("\\s+");
            int p = Integer.parseInt(words[0])-1;
            int q = Integer.parseInt(words[1])-1;
            villages.Union(p, q);
        }
    }

    public UF getVillages() {
        return villages;
    }

    public int getK() {
        return k;
    }
}
