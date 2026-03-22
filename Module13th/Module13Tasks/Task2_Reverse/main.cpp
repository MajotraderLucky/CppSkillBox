#include <iostream>
#include <vector>

using namespace std;

int main() {
    int n;
    cout << "Enter the count of numbers: ";
    cin >> n;

    vector<double> numbers(n);
    cout << "Enter " << n << " real numbers: ";
    for (int i = 0; i < n; i++) {
        cin >> numbers[i];
    }

    cout << "Reverse order: ";
    for (int i = n - 1; i >= 0; i--) {
        cout << numbers[i];
        if (i > 0) cout << " ";
    }
    cout << endl;

    return 0;
}
