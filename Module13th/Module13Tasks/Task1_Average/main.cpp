#include <iostream>
#include <vector>

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

    double sum = 0;
    for (int i = 0; i < n; i++) {
        sum += numbers[i];
    }

    double average = sum / n;
    cout << "Average: " << average << endl;

    return 0;
}
