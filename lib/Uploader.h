#pragma once

#include <QObject>

#include "AquascopeLibGlobal.h"

class QNetworkAccessManager;
class QNetworkReply;

class AQUASCOPE_LIB_EXPORT Uploader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString address MEMBER address NOTIFY addressChanged)

public:
    explicit Uploader(QObject *parent = nullptr);

    Q_INVOKABLE void upload(QString path);
    Q_INVOKABLE void abort();

signals:
    void addressChanged();
    void success(QString replyData);
    void error(int status, QString errorString);
    void progressChanged(qint64 bytesSent, qint64 bytesTotal);

private:
    QString address;
    QNetworkAccessManager* nam;
    QNetworkReply* reply = nullptr;
};
