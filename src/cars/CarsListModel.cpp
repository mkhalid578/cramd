#include "CarsListModel.h"

#include <QModelIndex>
#include <QVariantMap>

CarsListModel::CarsListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int CarsListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_cars.size();
}

QVariant CarsListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_cars.size())
        return {};

    if (role == CarRole)
        return m_cars.at(index.row());

    const QVariantMap car = m_cars.at(index.row()).toMap();
    qDebug() << car;
    const auto names = roleNames();
    const auto roleName = names.constFind(role);
    if (roleName == names.cend())
        return {};

    return car.value(QString::fromUtf8(*roleName));
}

QHash<int, QByteArray> CarsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(CarRole, "car");

    int role = CarRole + 1;
    for (const QVariant &item : m_cars) {
        const QVariantMap car = item.toMap();
        for (auto it = car.cbegin(); it != car.cend(); ++it) {
            const QByteArray roleName = it.key().toUtf8();
            if (!roles.values().contains(roleName))
                roles.insert(role++, roleName);
        }
    }

    return roles;
}

QVariantList CarsListModel::cars() const
{
    return m_cars;
}

void CarsListModel::setCars(const QVariantList &cars)
{
    qDebug() << cars;
    beginResetModel();
    m_cars = cars;
    endResetModel();
}
