# M20.4 — Запись массивов данных

**Длительность:** ~10 минут
**Тема:** запись массивов в файл (текстом и бинарно), `std::rand`, vector

## Главная идея

> Цикл по массиву + `f << v[i]` для текста, `f.write(arr, sizeof(arr))` для бинарного.

## Текстовая запись массива

```cpp
std::ofstream f("arr.txt");
int arr[5] = {1, 2, 3, 4, 5};
for (int i = 0; i < 5; i++) {
    f << arr[i] << " ";
}
```

## Запись vector

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
for (size_t i = 0; i < v.size(); i++) {
    f << v[i] << " ";
}
// Or range-for:
for (int x : v) f << x << " ";
```

## Генерация random чисел через std::rand

```cpp
#include <cstdlib>
for (int i = 0; i < 100; i++) {
    int r = std::rand();          // 0..RAND_MAX
    int range100 = std::rand() % 100;  // 0..99
    f << range100 << " ";
}
```

Для seed: `std::srand(time(0));`. Для C++11+: `std::mt19937` рекомендуется.

## Бинарная запись массива

```cpp
std::ofstream f("arr.bin", std::ios::binary);
int arr[1000];
// ... fill ...
f.write(reinterpret_cast<char*>(arr), sizeof(arr));   // 4000 bytes
```

## push_back динамически

```cpp
std::vector<int> v;
for (int i = 0; i < 100; i++) {
    v.push_back(std::rand() % 100);
}
// Запись потом:
for (int x : v) f << x << " ";
```

## Связь

- **M19.4:** чтение массивов (eof, vector)
- **M20.5 (next):** hwork по записи файлов
