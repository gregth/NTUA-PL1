#include <iostream>
#include <queue>
#include <string>
#include <fstream>


using namespace std;
class State {
    public:
        State(int x, int y, bool b)
            : i(x), j(y), loaded(b) {};
        ~State() {};
        int getI() {
            return i;
        }
        int getJ() {
            return j;
        }
        bool getLoaded() {
            return loaded;
        }
        bool isPossibleMove(char c, int N, int M, char** A) {
            switch (c) {
                case 'U':
                    return  i > 0 && A[i-1][j] != 'X';
                    break;
                case 'D':
                    return i < N - 1 && A[i+1][j] != 'X';
                    break;
                case 'L':
                    return j > 0 && A[i][j-1] != 'X';
                    break;
                case 'R':
                    return j < M - 1 && A[i][j+1] != 'X';
                    break;
                case 'W':
                    return A[i][j] == 'W';
                    break;
            }
            return false;
        }
    private:
        int i, j;
        bool loaded;
};

//From coordinates i,j with move m
class Move {
    public:
        Move(int x, int y, char c) {
            i = x;
            j = y;
            m = c;
        };
        ~Move() {};
        int getI() {
            return i;
        }
        int getJ() {
            return j;
        }
        char getM() {
            return m;
        }
    private:
        int i, j;
        char m;
};

int main(int argc, char* argv[]) {


	//Open input files
	ifstream inFile;
	inFile.open(argv[1]);
	string line;
	inFile >> line;
	int M = line.length();
	int lines_counter = 1;
	//Calculate N
	while (true) {
		inFile >> line;
		if (!inFile.eof()) {
			lines_counter++;
		}
		else
			break;
	}
	State* init = nullptr;
	inFile.clear();
	inFile.seekg(0,  inFile.beg);
	int N = lines_counter;
	//printf("%dX%d\n", lines_counter, M);
	//Create a 2D Array
	char** A = new char*[N];
	for (int i = 0; i < N; i++) {
		A[i] = new char[M];
		for (int j = 0; j < M; j++) {
			inFile >> A[i][j];
			if (A[i][j] == 'S') {
				init = new State(i, j, true);
			}
		}
	}

	/*//Print array
	for (int i=0; i<N; i++) {
		for (int j=0; j<M; j++) {
			cout <<  A[i][j];
		}
		cout << "\n";
	 */

	/* TEST POSSIBLE MOVES
	   cout << init->isPossibleMove('L', N, M, A);
	   cout << init->isPossibleMove('W', N, M, A);
	   cout << init->isPossibleMove('R', N, M, A);
	   */

	//Queues initializations
	queue<State*>* nextOnePtr;
	nextOnePtr = new queue<State*>();
    nextOnePtr->push(init);
	queue<State*>* nextTwoPtr;
	nextTwoPtr = new queue<State*>();

	//Declare and initialize moves array
	Move**** prev = new Move***[N];
	for (int i = 0; i < N; i++) {
		prev[i] = new Move**[M];
		for (int j = 0; j < M; j++) {
			prev[i][j] = new Move*[2];
			prev[i][j][0] = prev[i][j][1] = nullptr;
		}
	}

	int cost = 0;
	int sizeOne;
	int sizeTwo;
    int endI = 0, endJ = 0;
	State* nextStatePtr;
    bool delivered = false;
	while(true) {
		//Determine length of queues
		sizeTwo = nextTwoPtr->size();
		sizeOne = nextOnePtr->size();
		//For each element existing till now in queue
		for(int k = 0; k < sizeOne; k++) {
			//Get the element adress
			nextStatePtr = nextOnePtr->front();
            nextOnePtr->pop();
			//Check moves
			//Check moves
			int i = nextStatePtr->getI();
            int j = nextStatePtr->getJ();
            int loaded = nextStatePtr->getLoaded();
            if (A[i][j] == 'E' && loaded) {
                delivered = true;
                endI = i;
                endJ = j;
                break;
            }
            //Move UP
			if (nextStatePtr->isPossibleMove('U', N, M, A)) {
                //Αν δεν έχεις ξαναπάει εκεί (στη νέα κατάσταση δλδ)
                if (prev[i - 1][j][loaded] == nullptr) {
                    prev[i - 1][j][loaded] = new Move(i, j, 'U');
                    if (loaded) {
                        nextTwoPtr->push(new State(i-1, j, loaded));
                    }
                    else {
                        nextOnePtr->push(new State(i-1, j, loaded));
                    }
                }
            }
            //Move DOWN
			if (nextStatePtr->isPossibleMove('D',N, M, A)) {
                //Αν δεν έχεις ξαναπάει εκεί (στη νέα κατάσταση δλδ)
                if (prev[i +1][j][loaded] == nullptr) {
                    prev[i + 1][j][loaded] = new Move(i, j, 'D');
                    if (loaded) {
                        nextTwoPtr->push(new State(i+1, j, loaded));
                    }
                    else {
                        nextOnePtr->push(new State(i+1, j, loaded));
                    }
                }
            }
            //Move LEFT
			if (nextStatePtr->isPossibleMove('L', N, M, A)) {
                //Αν δεν έχεις ξαναπάει εκεί (στη νέα κατάσταση δλδ)
                if (prev[i][j - 1][loaded] == nullptr) {
                    prev[i][j - 1][loaded] = new Move(i, j, 'L');
                    if (loaded) {
                        nextTwoPtr->push(new State(i, j - 1, loaded));
                    }
                    else {
                        nextOnePtr->push(new State(i, j - 1, loaded));
                    }
                }
            }
            //Move RIGHT
			if (nextStatePtr->isPossibleMove('R', N, M, A)) {
                //Αν δεν έχεις ξαναπάει εκεί (στη νέα κατάσταση δλδ)
                if (prev[i][j + 1][loaded] == nullptr) {
                    prev[i][j + 1][loaded] = new Move(i, j, 'R');
                    if (loaded) {
                        nextTwoPtr->push(new State(i, j + 1, loaded));
                    }
                    else {
                        nextOnePtr->push(new State(i, j + 1, loaded));
                    }
                }
            }
            //Move wormhole
			if (nextStatePtr->isPossibleMove('W', N, M, A)) {
                //Αν δεν έχεις ξαναπάει εκεί (στη νέα κατάσταση δλδ)
                if (prev[i][j][!loaded] == nullptr) {
                    prev[i][j][!loaded] = new Move(i, j, 'W');
                    nextOnePtr->push(new State(i, j, !loaded));
                }
            }
		}
        if (delivered)
            break;
        //Αφαίρεσε από την NextTwo τα στοιχεία που είχε από το προηγούμενο κύκλο και βάλε τα στη next one
        for (int k = 0; k < sizeTwo; k++) {
            nextOnePtr->push(nextTwoPtr->front());
            nextTwoPtr->pop();
        }
        cost++;
	}


    string moveSequence = "";
    bool loaded = true;
    Move* currentMove = prev[endI][endJ][loaded];
    while (init->getI() != currentMove->getI() || init->getJ() != currentMove->getJ() || loaded == false) {
        moveSequence.insert(0, 1, currentMove->getM());
        if (currentMove->getM() == 'W') {
            loaded = !loaded;
            currentMove = prev[currentMove->getI()][currentMove->getJ()][loaded];
        }
        else
            currentMove = prev[currentMove->getI()][currentMove->getJ()][loaded];
    }
    moveSequence.insert(0, 1, currentMove->getM());
    cout << cost << " " << moveSequence << "\n";

}
