

/**
 * Calculates number of villages after road construction
 * Created by Jason on 17/7/2017.
 */
public class Solver {

    private int answer;

    public Solver(int count, int k) {
        if (count > k)
            answer = count - k;
        else answer = 1;
    }

    public int getAnswer() {
        return answer;
    }
}
