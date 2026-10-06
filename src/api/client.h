#pragma once

#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QObject>
#include <QUrl>
#include <QVariant>

#include <QtQml/qqmlregistration.h>

class Client : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QUrl baseUrl READ baseUrl WRITE setBaseUrl NOTIFY baseUrlChanged)

public:
    explicit Client(QObject *parent = nullptr);

    QUrl baseUrl() const;
    void setBaseUrl(const QUrl &baseUrl);

    Q_INVOKABLE quint64 get(const QString &path);
    Q_INVOKABLE quint64 post(const QString &path, const QVariantMap &body);

signals:
    void baseUrlChanged();
    void responseReceived(quint64 requestId, int statusCode, const QVariant &body);
    void requestFailed(quint64 requestId, const QString &message);

private:
    QUrl urlForPath(const QString &path) const;
    quint64 sendRequest(const QString &path, const QByteArray &method,
                        const QByteArray &body = {});

    QNetworkAccessManager m_networkAccessManager;
    QUrl m_baseUrl;
    quint64 m_nextRequestId = 1;
};
