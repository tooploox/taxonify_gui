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
  qCDebug(logger) << "Uploader:getPlatformFilePath(fileUrl=" << fileUrl << ")";
  QUrl url(fileUrl);
  return QDir::toNativeSeparators(url.toLocalFile());
}

QString Uploader::getFileName(QString filePath) const{
  qCInfo(logger) << "Uploader:getFileName(filePath=" << filePath << ")";
  return QUrl(filePath).fileName();
}

void Uploader::upload(QString path) {
    qCDebug(logger) << "Uploader:upload(path=" << path << ")";

    if(address.isEmpty()) {
        qCDebug(logger) << "Uploader:upload() - Remote address is not set";
        emit error(0, "Remote address is not set.");
        return;
    }

    if(reply) {
        qCDebug(logger) << "Uploader:upload() - already in progress";
        emit error(0, "Upload is already in progress.");
        return;
    }

    QFile* file = new QFile(path);
    bool openResult = file->open(QIODevice::ReadOnly);

    if(!openResult) {
        qCDebug(logger) << "Uploader:upload() - Cannot open the file";
        emit error(0, "Cannot open file: " + path + ".");
        delete file;
        return;
    }

    QFileInfo fileInfo(*file);
    QNetworkRequest request(address + "/" + fileInfo.fileName());

    request.setRawHeader(QByteArray("Accept-Encoding"),
                         QByteArray("gzip, deflate"));

    if(!token.isEmpty()) {
        qCDebug(logger) << "Uploader:upload() - not empty token";
        request.setRawHeader(QByteArray("Authorization"),
                             ("Bearer " + token).toUtf8());
    }

    reply = nam->put(request, file);
    reply->setParent(this);
    file->setParent(reply);

    connect(reply, &QNetworkReply::finished,
            [this]() {

        if(reply->error()) {
            qCDebug(logger) << "Uploader:upload() - reply error";
            int status = reply->attribute(
                        QNetworkRequest::HttpStatusCodeAttribute).toInt();
            emit error(status, reply->errorString());
        } else {
            qCDebug(logger) << "Uploader:upload() - reply success";
            emit success(reply->readAll());
        }

        reply->deleteLater();
        reply = nullptr;
    });

    connect(reply, &QNetworkReply::uploadProgress, this,
            &Uploader::progressChanged);
}

void Uploader::abort() {
    qCInfo(logger) << "Uploader:abort()";
    if(reply) {
        qCDebug(logger) << "Uploader:abort() - reply";
        reply->abort();
    }
}
