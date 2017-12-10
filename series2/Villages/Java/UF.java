

/**
 * Implements a Union-Find structure.
 * Quick Union algortithm used.
 * Based on code found on https://www.cs.princeton.edu/~rs/AlgsDS07/01UnionFind.pdf / Page 21
 * Created by Jason on 17/7/2017.
 */

public class UF {

    private int[] id, size;  // id[i] holds the parent of village denoted by number i+1
    private int count; // Holds the number of disjoint sets

    public UF(int N) {
        id = new int[N];
        size = new int[N];
        count = N;
        for (int i = 0; i < N; i++) {
            id[i] = i;
            size[i] = 1;
            //System.out.print(id[i] + " ");
        }
        //System.out.println(" ");
    }

    public int getCount() {
        return count;
    }

    // Finds and returns root (representative) of element i
    private int Find(int i) {
        if(i == id[i])
            return i;
        id[i] = Find(id[i]);
        return id[i];
    }

    // Unites the sets containing element p and q
    public void Union(int p, int q) {
        int i = Find(p);
        int j = Find(q);
        if (i != j) {
            if (size[i] <= size[j]) {
                id[i] = j;
                //System.out.println("id[" + (i+1) + "] = " + (j+1));
                size[j] += size[i];
            } else if (size[i] > size[j]) {
                id[j] = i;
                //System.out.println("id[" + (j+1) + "] = " + (i+1));
                size[i] += size[j];
            }



            count--;
        }
        //System.out.println("Count = " + count);
    }
}