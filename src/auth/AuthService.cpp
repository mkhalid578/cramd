#include "AuthService.h"

#include <QVariantMap>

AuthService::AuthService(QObject *parent)
    : QObject(parent)
{
    connect(&m_client, &Client::responseReceived, this,
            [this](quint64 requestId, int statusCode, const QVariant & body) {
                if (requestId != m_pendingRequestId)
                    return;

                m_pendingRequestId = 0;
                setBusy(false);

                if (statusCode >= 200 && statusCode < 300) {
                    m_authenticated = true;
                    m_userName = m_pendingUserName;
                    emit userNameChanged();
                    m_token = body.toMap().value("token").toString();
                    qDebug() << m_token << "recieved";
                    emit authenticatedChanged();
                    return;
                }

                setErrorMessage(statusCode > 300
                                    ? tr("The username or password is incorrect.")
                                    : tr("Sign in failed. Please try again."));
            });

    connect(&m_client, &Client::requestFailed, this,
            [this](quint64 requestId, const QString &) {
                if (requestId != m_pendingRequestId)
                    return;

                m_pendingRequestId = 0;
                setBusy(false);
                setErrorMessage(tr("Unable to connect. Please try again."));
            });
}

QUrl AuthService::baseUrl() const { return m_baseUrl; }

void AuthService::setBaseUrl(const QUrl &url)
{
    if (m_baseUrl == url)
        return;

    m_baseUrl = url;
    m_client.setBaseUrl(url);
    emit baseUrlChanged();
}

bool AuthService::busy() const { return m_busy; }
bool AuthService::authenticated() const { return m_authenticated; }
QString AuthService::userName() const { return m_userName; }
QString AuthService::errorMessage() const { return m_errorMessage; }

void AuthService::login(const QString &userName, const QString &password)
{
    if (m_busy)
        return;

    setErrorMessage({});
    setBusy(true);

    // Use the field names required by your backend's API contract.
    m_pendingRequestId = m_client.post(
        "auth/login",
        {{"email", userName}, {"password", password}});

    m_pendingUserName = userName;
}

void AuthService::logout()
{
    m_authenticated = false;
    m_userName.clear();
    setErrorMessage({});

    emit authenticatedChanged();
    emit userNameChanged();
}

void AuthService::setBusy(bool busy)
{
    if (m_busy == busy)
        return;

    m_busy = busy;
    emit busyChanged();
}

void AuthService::setErrorMessage(const QString &message)
{
    qDebug() << message;
    if (m_errorMessage == message)
        return;

    m_errorMessage = message;
    emit errorMessageChanged();
}