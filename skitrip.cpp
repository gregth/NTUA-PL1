#include <cstdio>
#include <sstream>
#include <iostream>
#include <fstream>
#include <string>
#include <list>


using namespace std;

class Station {
    public:
        Station(int a,int i) {
            altitude = a;
            index = i;
        };
        ~Station() {
        };
        int getAltitude() {
            return altitude;
        }
        int getIndex() {
            return index;
        }
    private:
        int altitude;
        int index;
};

int main(int argc, char* argv[]) {
	ifstream inFile;
 	inFile.open(argv[1]);
    string line;
    inFile >> line;
    int numOfStations = stoi(line);
    //Array of pointers to stations
    Station* stations[numOfStations];
	//cout << inFile.rdbuf();
	//Read second line
    for (int i = 0; i < numOfStations; i++) {
        string altitude;
        inFile >> altitude;
        stations[i] = new Station(stoi(altitude), i);
    }
	inFile.close();

    //Array of all posible start stations
    list<Station*> startStations;
    //Array of all posible end stations
    list<Station*> endStations;

    //Calculate start stations
    int maxStationIndex = numOfStations - 1;
    startStations.push_back(stations[maxStationIndex]);
    for (int i = numOfStations - 2; i >= 0; i--) {
        if (stations[i]->getAltitude() > stations[maxStationIndex]->getAltitude()) {
            startStations.push_back(stations[i]);
            maxStationIndex = i;
            //cout << startStations.front()->getAltitude() << " ";
        }
    }

    //Calculate end stations
    int minStationIndex = 0;
    endStations.push_front(stations[minStationIndex]);
    for (int i = 0; i < numOfStations; i++) {
        if (stations[i]->getAltitude() < stations[minStationIndex]->getAltitude()) {
            endStations.push_front(stations[i]);
            minStationIndex = i;
            //cout << endStations.back()->getAltitude() << " ";
        }
    }

    list<Station*> mergedStations;
    while (!startStations.empty() && !endStations.empty()) {
        if (startStations.front()->getAltitude() < endStations.front()->getAltitude()) {
            mergedStations.push_back(startStations.front());
            startStations.pop_front();
        }
        else if (startStations.front()->getAltitude() == endStations.front()->getAltitude()) {
            if (startStations.front()->getIndex() < endStations.front()->getIndex()) {
                mergedStations.push_back(startStations.front());
                startStations.pop_front();
            }
            else {
                mergedStations.push_back(endStations.front());
                endStations.pop_front();
            }
        }
        else {
            mergedStations.push_back(endStations.front());
            endStations.pop_front();
        }
    }

    //Append remaining lists
    while(!startStations.empty()){
        mergedStations.push_back(startStations.front());
        startStations.pop_front();
    }
    while(!endStations.empty()){
        mergedStations.push_back(endStations.front());
        endStations.pop_front();
    }


    //Find best path
    int startIndex, endIndex, minIndex;
    startIndex = endIndex = minIndex = mergedStations.front()->getIndex();
    mergedStations.pop_front();

    int index;
    while (!mergedStations.empty()) {
        index = mergedStations.front()->getIndex();
        if (index - minIndex > startIndex - endIndex) {
            startIndex = index;
            endIndex = minIndex;
        }
        else if (index < minIndex ) {
            minIndex = index;
        }
        mergedStations.pop_front();

    }
    int result = startIndex - endIndex;
    cout << result << "\n";
}
