#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <Uploader.h>

int main(int argc, char *argv[])
{
    // dummy initialization to enforce proper linking
    Uploader();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/test/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
