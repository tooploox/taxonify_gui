#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "components/RequestError.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    qmlRegisterUncreatableType<RequestError>(
        "Application", 1, 0, "RequestError",
        "Provides enum for request errors.");

    return app.exec();
}
