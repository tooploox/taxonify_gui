#include "Logger.h"

#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QStandardPaths>

Logger::Logger(QObject *parent)
    : QObject(parent)
{
    if (!QDir(filename).isAbsolute())
        filename = QDir::currentPath() + "/" + filename;

    QDir::root().mkpath(QFileInfo(filename).absolutePath());

    file.setFileName(filename);
    if (file.open(QIODevice::WriteOnly | QIODevice::Append))
        writer.setDevice(&file);
    else
        qCritical() << "Logger::Logger(): Could not open file: " << file.errorString();
}

inline QString Logger::prefix() const {
    return "[" + QDateTime::currentDateTimeUtc().toString("yyyy-MM-dd HH:mm:ss.zzz") + "] ";
}

void Logger::log(const QString &message) {
    if(file.isOpen())
        writer << prefix() << message << endl;
    else
        qCritical() << "Logger::log(): File is not open";
}

Logger::~Logger() {
    writer.flush();
    file.close();
}
