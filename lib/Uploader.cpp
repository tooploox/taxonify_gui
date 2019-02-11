#include "Uploader.h"

#include <QNetworkAccessManager>
#include <QDir>
#include <QFile>
#include <QNetworkReply>
#include <QUrl>

Uploader::Uploader(QObject *parent)
    : QObject(parent), nam(new QNetworkAccessManager(this))
{
}

QString Uploader::getPlatformFilePath(QString fileUrl) const{
  QUrl url(fileUrl);
  return QDir::toNativeSeparators(url.path());
}

void Uploader::upload(QString path) {

    if(address.isEmpty()) {
        emit error(0, "Remote address is not set.");
        return;
    }

    if(reply) {
        emit error(0, "Upload is already in progress.");
        return;
    }

    QFile* file = new QFile(path);
    bool openResult = file->open(QIODevice::ReadOnly);

    if(!openResult) {
        emit error(0, "Cannot open file: " + path + ".");
        return;
    }

    QFileInfo fileInfo(*file);
    QNetworkRequest request(address + "/" + fileInfo.fileName());

    if(!token.isEmpty()) {
        request.setRawHeader(QByteArray("Authorization"),
                             ("Bearer " + token).toUtf8());
    }

    reply = nam->put(request, file);
    reply->setParent(this);

    connect(reply, &QNetworkReply::finished,
            [this]() {

        if(reply->error()) {
            int status = reply->attribute(
                        QNetworkRequest::HttpStatusCodeAttribute).toInt();
            emit error(status, reply->errorString());
        } else {
            emit success(reply->readAll());
        }

        reply->deleteLater();
        reply = nullptr;
    });

    connect(reply, &QNetworkReply::uploadProgress, this,
            &Uploader::progressChanged);
}

void Uploader::abort() {
    if(reply) {
        reply->abort();
    }
}
