// M34.5 Task 1 — minimum Qt5 Widgets app to verify setup.
// Прогоняется в --offscreen режиме для CI (без X11).
//
// Запуск:
//   ./qtsetup --no-loop      — создать виджеты, проверить что Qt инициализировался, и выйти
//   ./qtsetup                — нормальный GUI режим (требует display)

#include <QApplication>
#include <QLabel>
#include <QPushButton>
#include <QVBoxLayout>
#include <QWidget>
#include <iostream>

int main(int argc, char** argv) {
    bool noLoop = false;
    for (int i = 1; i < argc; ++i) {
        if (std::string(argv[i]) == "--no-loop") noLoop = true;
    }

    QApplication app(argc, argv);

    QWidget window;
    window.setWindowTitle("Skillbox M34.5 Qt Setup");

    auto* layout = new QVBoxLayout(&window);
    layout->addWidget(new QLabel("Hello, Qt!"));
    layout->addWidget(new QPushButton("Click me"));

    if (noLoop) {
        // CI mode — verify init only, do not show or enter event loop.
        std::cout << "Qt initialized OK"
                  << " | qVersion=" << qVersion()
                  << " | layoutCount=" << layout->count()
                  << std::endl;
        return 0;
    }

    window.resize(300, 120);
    window.show();
    return app.exec();
}
