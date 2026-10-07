#include "CarsService.h"

#include <QMetaType>

CarsService::CarsService(QObject *parent)
    : QObject(parent)
    , m_carsModel(new CarsListModel(this))
{
}

Client *CarsService::client() const
{
    return m_client;
}

void CarsService::setClient(Client *client)
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
            [this](quint64 requestId, int statusCode, const QVariant &body) {
        if (requestId != m_pendingRequestId)
            return;

        m_pendingRequestId = 0;
        setBusy(false);

        if (statusCode < 200 || statusCode >= 300) {
            setErrorMessage(tr("Unable to load cars. Please try again."));
            return;
        }

        if (body.metaType().id() != QMetaType::QVariantList) {
            setErrorMessage(tr("The server returned an invalid cars response."));
            return;
        }

        m_carsModel->setCars(body.toList());
        emit carsChanged();
        setErrorMessage({});
    });

    connect(m_client.data(), &Client::requestFailed, this,
            [this](quint64 requestId, const QString &) {
        if (requestId != m_pendingRequestId)
            return;

        m_pendingRequestId = 0;
        setBusy(false);
        setErrorMessage(tr("Unable to load cars. Please check your connection."));
    });
}

CarsListModel *CarsService::carsModel() const
{
    return m_carsModel;
}

QVariantList CarsService::cars() const
{
    return m_carsModel->cars();
}

bool CarsService::busy() const
{
    return m_busy;
}

QString CarsService::errorMessage() const
{
    return m_errorMessage;
}

void CarsService::loadCars()
{
    if (m_busy)
        return;

    if (!m_client) {
        setErrorMessage(tr("Cars service is unavailable."));
        return;
    }

    setErrorMessage({});
    setBusy(true);
    m_pendingRequestId = m_client->get("cars");
}

void CarsService::setBusy(bool busy)
{
    if (m_busy == busy)
        return;

    m_busy = busy;
    emit busyChanged();
}

void CarsService::setErrorMessage(const QString &message)
{
    if (m_errorMessage == message)
        return;

    m_errorMessage = message;
    emit errorMessageChanged();
}
