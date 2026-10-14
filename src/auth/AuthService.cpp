#include "AuthService.h"

#include <QVariantMap>

AuthService::AuthService(QObject *parent)
    : QObject(parent)
{
}

Client *AuthService::client() const
{
    return m_client;
}

void AuthService::setClient(Client *client)
{
    if (m_client == client)
        return;

    if (m_client)
        disconnect(m_client.data(), nullptr, this, nullptr);
    m_client = client;
    m_pendingRequestId = 0;
    setBusy(false);
    emit clientChanged();

    if (!m_client)
        return;

    connect(m_client.data(), &Client::responseReceived, this,
            [this](quint64 requestId, int statusCode, const QVariant & body) {
        if (requestId != m_pendingRequestId)
            return;

        qDebug() << body;

        m_pendingRequestId = 0;
        setBusy(false);

        switch (statusCode) {
        case 201:
            // we've created something so we should handle that here
            // user object successfully created
            setSuccessMessage("User created successfully");
            break;
        case 200:
            // status is ok (typically login)
            m_token = body.toMap().value("token").toString();
            if (m_token.isEmpty()) {
                setErrorMessage(tr("Sign in response did not include an access token."));
                return;
            }

            if (m_client)
                m_client->setBearerToken(m_token);
            m_authenticated = true;
            m_userName = m_pendingUserName;
            emit userNameChanged();
            m_firstName = body.toMap().value("first_name").toString();
            emit firstNameChanged();
            emit authenticatedChanged();
            break;
        default:
            break;
        }


        if (statusCode >= 300) {

            setErrorMessage (body.toMap().value("error").toString());
        }

    });

    connect(m_client.data(), &Client::requestFailed, this,
            [this](quint64 requestId, const QString &) {
        if (requestId != m_pendingRequestId)
            return;

        m_pendingRequestId = 0;
        setBusy(false);
        setErrorMessage(tr("Unable to connect. Please try again."));

        auth_count++;
    });
}

bool AuthService::busy() const { return m_busy; }
bool AuthService::authenticated() const { return m_authenticated; }
QString AuthService::userName() const { return m_userName; }
QString AuthService::errorMessage() const { return m_errorMessage; }


void AuthService::login(const QString &userName, const QString &password)
{
    if (auth_count > 3) {
        setErrorMessage("Too many authentication attempts");
        return;
    }

    if (m_busy)
        return;

    setErrorMessage({});
    setBusy(true);

    if (!m_client) {
        m_pendingRequestId = 0;
        setBusy(false);
        setErrorMessage(tr("Authentication service is unavailable."));
        return;
    }

    m_client->setBearerToken({});
    m_pendingRequestId = m_client->post(
        "auth/login",
        {{"email", userName}, {"password", password}});

    m_pendingUserName = userName;
}

void AuthService::logout()
{
    m_authenticated = false;
    m_token.clear();
    if (m_client)
        m_client->setBearerToken({});
    m_userName.clear();
    setErrorMessage({});

    emit authenticatedChanged();
    emit userNameChanged();
}

void AuthService::registerUser(const QString &first, const QString &last, const QString &email, const QString &password)
{

    if (m_busy)
        return;

    setErrorMessage({});
    setSuccessMessage({});
    setBusy(true);

    if (!m_client) {
        m_pendingRequestId = 0;
        setBusy(false);
        setErrorMessage(tr("Authentication service is unavailable."));
        return;
    }

    m_client->setBearerToken({});
    m_pendingRequestId = m_client->post(
        "auth/register",
        {{"email", email}, {"password", password}, {"first_name", first}, {"last_name", last}});

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
    if (m_errorMessage == message)
        return;

    m_errorMessage = message;
    emit errorMessageChanged();
}

void AuthService::setSuccessMessage(const QString &message)
{
    if (m_successMsg == message) {
        return;
    }

    m_successMsg = message;
    emit successMsgChanged();
}
QString AuthService::firstName() const
{
    return m_firstName;
}

QString AuthService::successMsg() const
{
    return m_successMsg;
}
