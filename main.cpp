#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    auto applicationPath = QCoreApplication::applicationDirPath();
    auto configPath = QDir(applicationPath).filePath("settings.json");

    QVariant settingsPath;

    if(QFile(configPath).exists()) {
        settingsPath = "file:///" + configPath;
    } else {
        settingsPath = QVariant(QVariant::String);
    }

    engine.rootContext()->setContextProperty("settingsPath", settingsPath);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
