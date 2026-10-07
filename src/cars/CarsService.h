#pragma once

#include "client.h"
#include "CarsListModel.h"

#include <QObject>
#include <QPointer>
#include <QString>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

class CarsService : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(Client *client READ client WRITE setClient NOTIFY clientChanged)
    Q_PROPERTY(CarsListModel *carsModel READ carsModel CONSTANT)
    Q_PROPERTY(QVariantList cars READ cars NOTIFY carsChanged)
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)

public:
    explicit CarsService(QObject *parent = nullptr);

    Client *client() const;
    void setClient(Client *client);

    CarsListModel *carsModel() const;
    QVariantList cars() const;
    bool busy() const;
    QString errorMessage() const;

    Q_INVOKABLE void loadCars();

signals:
    void clientChanged();
    void carsChanged();
    void busyChanged();
    void errorMessageChanged();

private:
    void setBusy(bool busy);
    void setErrorMessage(const QString &message);

    QPointer<Client> m_client;
    CarsListModel *m_carsModel;
    quint64 m_pendingRequestId = 0;
    bool m_busy = false;
    QString m_errorMessage;
};
