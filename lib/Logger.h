#pragma once

#include <QFile>
#include <QObject>
#include <QTextStream>

#include "AquascopeLibGlobal.h"

class AQUASCOPE_LIB_EXPORT Logger : public QObject
{
    Q_OBJECT
public:
    explicit Logger(QObject *parent = nullptr);
    ~Logger();

    Q_INVOKABLE void log(const QString &message);

private:
    QFile file;
    QString filename = "log.txt";
    QTextStream writer;

    QString prefix() const;
};
