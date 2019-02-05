#include "Uploader.h"

#include <QNetworkAccessManager>
#include <QFile>
#include <QNetworkReply>

Uploader::Uploader(QObject *parent)
    : QObject(parent)
{
    nam = new QNetworkAccessManager(this);
}

Uploader::~Uploader() {

}

void Uploader::upload(QString path) {

    QString url = "https://httpbin.org/put";

    QFile* file = new QFile("/home/mcieslak/Downloads/thumb.jpg");
    qDebug() << file->open(QIODevice::ReadOnly);

    qDebug() << "sending put req";

    reply = nam->put(QNetworkRequest(url), file);

    connect(reply, &QNetworkReply::finished,
            [this]() {

        qDebug() << "finished!";

        qDebug() << reply->readAll();

    });

    qDebug() << "connected!";

}


void Uploader::abort() {

}
