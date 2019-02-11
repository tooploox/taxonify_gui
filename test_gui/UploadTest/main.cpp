#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QProcess>

#include <Uploader.h>

class DockerProcess {
public:
    DockerProcess(QObject* parent, QString app, QStringList arguments) :
      proc(new QProcess(parent))
    {
      proc->start(app, arguments);
    }
    ~DockerProcess(){
      proc->terminate();
      proc->waitForFinished();
    }
private:
    QProcess* proc;
};

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<Uploader>("com.microscopeit", 1, 0, "Uploader");

    DockerProcess proc(&app, "docker", QStringList{"run", "-p", "80:80", "kennethreitz/httpbin"});

    engine.load(QUrl(QStringLiteral("qrc:/test/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
