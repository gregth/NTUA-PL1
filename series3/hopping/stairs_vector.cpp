#include <cstdio>
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int count_ways(int n, int k, int moves[], int b, int broken[], int dyn[]) {
	if (n < 1) {
		return 0;
	}
    if (n == 1) {
        return 1;
    }
    if (dyn[n] == 0) {
        return 0;
    }

	if (dyn[n] != -1) {
		return dyn[n];
	}

    int sum = 0;
    int i = 0;
	for (i = 0; i < k; i++) {
        sum += count_ways(n - moves[i], k, moves, b, broken, dyn);
        if (sum >= 1000000009) {
            sum -= 1000000009;
        }
        //printf("Local sum: %d for n = %d & i = %d\n", sum, n, i);
	}
    dyn[n] = sum;
	return dyn[n];

}

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

    int moves[K];
    int broken[B];
    int dyn[N + 1];

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
		dyn[i] = -1; // Aρχικοποίηση πίνακα δυνατών βημάτων στην τιμή -1
	}

	for (int i = 0; i < B; i++) {
		dyn[broken[i]] = 0; // Aρχικοποίηση κατεστραμένων σκαλιών στην τιμή 0
	}

    int result = count_ways(N, K, moves, B, broken, dyn);
    printf("%d\n", result);
    return 0;
}
