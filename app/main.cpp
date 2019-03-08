#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <Logger.h>
#include <Uploader.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("EAWAG");
    app.setOrganizationDomain("Underwater microscopy");
    app.setApplicationName("Aquascope annotation");

    QQmlApplicationEngine engine;
    auto applicationPath = QCoreApplication::applicationDirPath();
    auto configPath = QDir(applicationPath).filePath("settings.json");

    QVariant settingsPath;

    if(QFile(configPath).exists()) {
        settingsPath = QUrl::fromLocalFile(configPath);
    } else {
        settingsPath = QVariant(QVariant::String);
    }

    initLogging();
    qmlRegisterType<Uploader>("com.microscopeit", 1, 0, "Uploader");

    engine.rootContext()->setContextProperty("settingsPath", settingsPath);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
