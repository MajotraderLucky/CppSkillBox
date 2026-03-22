#include <iostream>
#include <vector>

using namespace std;

int main() {
    vector<int> ages;
    int age;

    cout << "Enter patient ages (-1 to stop):" << endl;
    while (cin >> age && age >= 0) {
        ages.push_back(age);
    }

    if (ages.empty()) {
        cout << "No patients." << endl;
        return 0;
    }

    double sum = 0;
    for (int i = 0; i < ages.size(); i++) {
        sum += ages[i];
    }

    cout << "Count: " << ages.size() << endl;
    cout << "Average age: " << sum / ages.size() << endl;

    return 0;
}
