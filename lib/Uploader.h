#ifndef UPLOADER_H
#define UPLOADER_H

#include <QObject>

#include "AquascopeLibGlobal.h"

class QNetworkAccessManager;
class QNetworkReply;

class AQUASCOPE_LIB_EXPORT Uploader : public QObject
{
    Q_OBJECT

public:
    explicit Uploader(QObject *parent = 0);
    ~Uploader();

    Q_INVOKABLE void upload(QString path);
    Q_INVOKABLE void abort();

private:
    QNetworkAccessManager* nam;
    QNetworkReply* reply;
};

#endif // UPLOADER_H
