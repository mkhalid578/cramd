#include "client.h"

#include <QJsonDocument>
#include <QJsonParseError>
#include <QNetworkReply>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QTimer>

Client::Client(QObject *parent)
    : QObject(parent)
{
}

QUrl Client::baseUrl() const
{
    return m_baseUrl;
}

void Client::setBaseUrl(const QUrl &baseUrl)
{
    if (m_baseUrl == baseUrl)
        return;

    m_baseUrl = baseUrl;
    emit baseUrlChanged();
}

void Client::setBearerToken(const QString &token)
{
    m_bearerToken = token;
}

quint64 Client::get(const QString &path)
{
    return sendRequest(path, "GET");
}

quint64 Client::post(const QString &path, const QVariantMap &body)
{
    const QJsonDocument document(QJsonObject::fromVariantMap(body));
    return sendRequest(path, "POST", document.toJson(QJsonDocument::Compact));
}

QUrl Client::urlForPath(const QString &path) const
{
    if (!m_baseUrl.isValid() || m_baseUrl.isEmpty())
        return {};

    return m_baseUrl.resolved(QUrl(path));
}

quint64 Client::sendRequest(const QString &path, const QByteArray &method,
                            const QByteArray &body)
{
    const quint64 requestId = m_nextRequestId++;
    const QUrl url = urlForPath(path);
    if (!url.isValid() || url.host().isEmpty()
        || (url.scheme() != "http" && url.scheme() != "https")) {
        QTimer::singleShot(0, this, [this, requestId] {
            emit requestFailed(
                requestId,
                tr("Set a valid HTTP or HTTPS base URL before making requests."));
        });
        return requestId;
    }

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Accept", "application/json");
    if (!m_bearerToken.isEmpty())
        request.setRawHeader("Authorization", "Bearer " + m_bearerToken.toUtf8());
    QNetworkReply *reply = m_networkAccessManager.sendCustomRequest(request, method, body);

    connect(reply, &QNetworkReply::finished, this, [this, reply, requestId] {
        const int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        const QByteArray responseBody = reply->readAll();
        const QString errorMessage = reply->errorString();
        reply->deleteLater();

        if (statusCode == 0) {
            emit requestFailed(requestId, errorMessage);
            return;
        }

        QJsonParseError parseError;
        const QJsonDocument document = QJsonDocument::fromJson(responseBody, &parseError);
        if (parseError.error != QJsonParseError::NoError && !responseBody.isEmpty()) {
            emit requestFailed(requestId,
                               tr("The server returned invalid JSON (HTTP %1).").arg(statusCode));
            return;
        }

        QVariant body;
        if (document.isObject())
            body = document.object().toVariantMap();
        else if (document.isArray())
            body = document.array().toVariantList();

        emit responseReceived(requestId, statusCode, body);
    });

    return requestId;
}