#include <iostream>
#include <vector>

using namespace std;

vector<int> add_to_position(vector<int> vec, int val, int position) {
    if (position < 0) position = 0;
    if (position > vec.size()) position = vec.size();
    vec.insert(vec.begin() + position, val);
    return vec;
}

int main() {
    vector<int> queue;
    string command;

    cout << "Commands: 'add' (add to end), 'insert' (add to position), 'show', 'quit'" << endl;

    while (cin >> command) {
        if (command == "quit") {
            break;
        } else if (command == "add") {
            int id;
            cout << "Robot ID: ";
            cin >> id;
            queue.push_back(id);
            cout << "Robot #" << id << " added to end." << endl;
        } else if (command == "insert") {
            int id, pos;
            cout << "Robot ID: ";
            cin >> id;
            cout << "Position (1-based): ";
            cin >> pos;
            queue = add_to_position(queue, id, pos - 1);
            cout << "Robot #" << id << " inserted at position " << pos << "." << endl;
        } else if (command == "show") {
            cout << "Queue:" << endl;
            for (int i = 0; i < queue.size(); i++) {
                cout << i + 1 << ". Robot #" << queue[i] << endl;
            }
        }
    }

    return 0;
}
