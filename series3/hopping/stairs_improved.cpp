#include <cstdio>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

int main(int argc, char*  argv[]) {

    if (argc != 2) {
        printf("Wrong usage. Only one argument, please.");
        return 1;
    }

    ifstream myfile;
    myfile.open(argv[1]);
    string line;
    myfile >> line;
    int N = stoi(line);
    myfile >> line;
    int K = stoi(line);
    myfile >> line;
    int B = stoi(line);

    vector<int> moves(K);
    vector<int> broken(B);
    vector<int> dyn(N + 1);


	for (int i = 0; i < K; i++) {
        myfile >> line;
        moves[i] = stoi(line);
    }
	for (int i = 0; i < B; i++) {
        myfile >> line;
        broken[i] = stoi(line);
    }
    myfile.close();


	for (int i = 0; i <= N; i++) {
		dyn[i] = 0; // Aρχικοποίηση πίνακα δυνατών βημάτων στην τιμή -1
	}
	for (int i = 0; i < B; i++) {
		dyn[broken[i]] = -1; // Aρχικοποίηση κατεστραμένων σκαλιών στην τιμή 0
	}


    if( dyn[1] == -1 || dyn[N] == -1 ) {
        printf("0\n");
        return 0;
    }
    dyn[1]=1;
	for (int i = 1; i < N; i++) {
        if (dyn[i] > 0) { //Άρα έχει βρεθεί τρόπος να φτάσει στο σκαλία αυτό
            for (int j = 0; j < K; j++) {
                int next_step = i + moves[j];
                if (next_step <= N && dyn[next_step] != -1) {
                    dyn[next_step] += dyn[i];
                    if (dyn[next_step] >= 1000000009) {
                        dyn[next_step] -= 1000000009;
                    }
                }
            }
        }
    }

    //int result = count_ways(N, K, moves, B, broken, dyn);
    printf("%d\n", dyn[N]);
    return 0;
}
