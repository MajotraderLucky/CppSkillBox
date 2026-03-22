#include <iostream>
#include <vector>
#include <climits>

using namespace std;

int main() {
    int n;
    cout << "Enter the count of numbers: ";
    cin >> n;

    vector<int> numbers(n);
    cout << "Enter " << n << " integers: ";
    for (int i = 0; i < n; i++) {
        cin >> numbers[i];
    }

    int max = INT_MIN;
    int secondMax = INT_MIN;

    for (int i = 0; i < n; i++) {
        if (numbers[i] > max) {
            secondMax = max;
            max = numbers[i];
        } else if (numbers[i] > secondMax && numbers[i] != max) {
            secondMax = numbers[i];
        }
    }

    cout << "Second largest: " << secondMax << endl;

    return 0;
}
