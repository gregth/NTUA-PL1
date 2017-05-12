#include <iostream>
#include <queue>
#include <file>
#include <string>
#include <fstream>


using namespace std;



int main(int arg c, char* argv[]) {

	//estw oti exw etoimo ton pinaka

	State init(true, i, j);
	queue<State>* nextMinPtr;
	nextMinPtr = new queue<State>();
	queue<State>* nextTwoPtr;
	nextTwoPtr = new queue<State>();

	nextMinPtr->push(init);

	char prev[2*N][M];
	prev[i][j] = 'S';

	int cost = 0;
	int size;
	State* nextStatePtr;
	bool delivered = false;

	while(true) {
		size = nextTwoPtr->size();

		while(!nextMinPtr->empty()) {
			nextStatePtr = &nextMinPtr->pop();
			if(nextStatePtr->getType() == 'E' && nextStatePtr->getLoaded() == true) {
				delivered = true;
				break;
			}
			
		}

	}

}
	
	
