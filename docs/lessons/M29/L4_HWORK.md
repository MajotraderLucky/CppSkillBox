# M29.4 — Практическая работа (homework)

**Источник:** `https://go.skillbox.ru/.../homework/9751d300-07f6-457e-bd12-2ed50662d594`
**Цели:** ООП — virtual functions, abstract classes, runtime polymorphism

## Что входит

- 1 обязательная задача + 1 дополнительная

---

## 1. Суперпёс (mandatory)

### Что нужно

- Класс **`Dog`** + динамически добавляемые **способности** (talents)
- Абстрактный класс **`Talent`** — pure virtual `name()` или `show()`
- Дочерние таланты: **`Swimming`**, **`Dancing`**, **`Counting`**
- У `Dog` метод **`show_talents()`** выводит все его способности

### Архитектура

```cpp
class Talent {
public:
    virtual ~Talent() = default;
    virtual std::string name() const = 0;     // pure virtual
};

class Swimming : public Talent { /* ... */ };
class Dancing  : public Talent { /* ... */ };
class Counting : public Talent { /* ... */ };

class Dog {
    std::string name_;
    std::vector<Talent*> talents_;
public:
    Dog(std::string name);
    void addTalent(Talent* t);
    void show_talents();
};
```

### Пример вывода

```text
This is Steve and it has some talents:
   It can "Dance"
   It can "Swim"
```

### Оценивается

- Talent — abstract (нельзя создать экземпляр)
- Все таланты наследуются от Talent
- Dog **не** наследуется от Talent
- show_talents выводит **все** добавленные

---

## 2. Интерфейс Shape (optional)

### Что нужно

Абстрактный класс `Shape` с pure virtual методами:
- `double square()` — площадь
- `BoundingBoxDimensions dimensions()` — описывающий прямоугольник
- `std::string type()` — название («Triangle» / «Circle» / «Rectangle»)

`BoundingBoxDimensions { double width, height; }`

Дочерние классы:
- `Circle(radius)` — bbox = 2r × 2r
- `Rectangle(w, h)` — bbox = w × h
- `Triangle(a, b, c)` — формула Герона + bbox через описанную окружность

Глобальная функция:
```cpp
void printParams(Shape* shape) {
    std::cout << "Type: " << shape->type() << "\n"
              << "Square: " << shape->square() << "\n"
              << "Width: " << shape->dimensions().width << "\n"
              << "Height: " << shape->dimensions().height << "\n";
}
```

### Триангул формулы

- Площадь (Heron): `sqrt(p*(p-a)*(p-b)*(p-c))` где `p = (a+b+c)/2`
- Описанная окружность радиус: `a*b*c / (4 * area)`
- bbox: side = `2 * R` (квадратный bbox через описанную окружность)

---

## Submission

- .cpp + CMakeLists для Task 2 (рекомендуется одна фигура — один файл)
- Replit deep-link или архив
- Проверка отключена (content-first phase)
