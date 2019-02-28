#pragma once

#include <QFile>
#include <QObject>
#include <QTextStream>

#include "AquascopeLibGlobal.h"

class AQUASCOPE_LIB_EXPORT Logger : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString filename MEMBER filename NOTIFY filenameChanged)

public:
    explicit Logger(QObject *parent = nullptr);
    ~Logger();

    Q_INVOKABLE void log(const QString &message) const;

signals:
    void filenameChanged();

private:
    QFile file;
    QString filename;
    QTextStream writer;
};
