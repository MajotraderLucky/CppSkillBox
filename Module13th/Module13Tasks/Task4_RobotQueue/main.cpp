#include <iostream>
#include <vector>

using namespace std;

int main() {
    vector<int> queue;
    int id;

    cout << "Enter robot IDs (0 to stop):" << endl;
    while (cin >> id && id != 0) {
        queue.push_back(id);
    }

    cout << "Queue:" << endl;
    for (int i = 0; i < queue.size(); i++) {
        cout << i + 1 << ". Robot #" << queue[i] << endl;
    }

    return 0;
}
