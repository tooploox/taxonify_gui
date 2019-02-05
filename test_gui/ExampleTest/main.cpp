#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <Uploader.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Dummy instance to enforce proper linking
    Uploader();

    engine.load(QUrl(QStringLiteral("qrc:/test/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
