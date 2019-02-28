#include "Logger.h"

#include <QFile>

Logger::Logger(QObject *parent)
    : QObject(parent)
{
}

void Logger::log(const QString &message) const {
    auto w = message;
}

Logger::~Logger() {
    writer.flush();
    file.close();
}
