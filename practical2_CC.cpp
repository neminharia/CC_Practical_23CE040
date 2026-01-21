#include<bits/stdc++.h>
using namespace std;

int main(){
    int numSym;
    cout << "Number of input symbols : ";
    cin >> numSym;
    
    vector<char> symbols(numSym);
    cout << "Input symbols : ";
    
    for (int i = 0; i < numSym; i++){
        cin >> symbols[i];
    }
    int numStates;
    cout << "Enter number of states : ";
    cin >> numStates;

    int startState;
    cout << "Initial state : ";
    cin >> startState;

    int numAccept;
    cout << "Number of accepting states : ";
    cin >> numAccept;

    set<int> acceptStates;
    cout << "Accepting states : ";
    for (int i = 0; i < numAccept; i++) {
        int x;
        cin >> x;
        acceptStates.insert(x);
    }

    map<pair<int,char>, int> transition;

    cout << "Transition table :" << endl;
    for (int i = 1; i <= numStates; i++) {
        for (char c : symbols) {
            int nextState;
            cout << i << " to " << c << " -> ";
            cin >> nextState;
            transition[{i, c}] = nextState;
        }
    }

    string input;
    cout << "Input string : ";
    cin >> input;
    int currentState = startState;

    for (char c : input) {
        if (transition.find({currentState, c}) == transition.end()) {
            cout << "\nInvalid String";
            return 0;
        }
        currentState = transition[{currentState, c}];
    }
    
    if (acceptStates.count(currentState))
        cout << "\nValid String";
    else
        cout << "\nInvalid String";

    return 0;
}

