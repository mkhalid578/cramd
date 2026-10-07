#pragma once

#include "client.h"

#include <QObject>
#include <QPointer>
#include <QString>
#include <QtQml/qqmlregistration.h>

class AuthService : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(Client *client READ client WRITE setClient NOTIFY clientChanged)
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(bool authenticated READ authenticated NOTIFY authenticatedChanged)
    Q_PROPERTY(QString userName READ userName NOTIFY userNameChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)

public:
    explicit AuthService(QObject *parent = nullptr);

    Client *client() const;
    void setClient(Client *client);

    bool busy() const;
    bool authenticated() const;
    QString userName() const;
    QString errorMessage() const;

    Q_INVOKABLE void login(const QString &userName, const QString &password);
    Q_INVOKABLE void logout();

signals:
    void clientChanged();
    void busyChanged();
    void authenticatedChanged();
    void userNameChanged();
    void errorMessageChanged();

private:
    void setBusy(bool busy);
    void setErrorMessage(const QString &message);

    QPointer<Client> m_client;
    QString m_token;
    QString m_pendingUserName;
    quint64 m_pendingRequestId = 0;
    bool m_busy = false;
    bool m_authenticated = false;
    QString m_userName;
    QString m_errorMessage;
    int auth_count {0};
};