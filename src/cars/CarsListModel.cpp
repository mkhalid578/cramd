#include "CarsListModel.h"

#include <QModelIndex>

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

    if (role != CarRole)
        return {};

    return m_cars.at(index.row());
}

QHash<int, QByteArray> CarsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(CarRole, "car");
    return roles;
}

QVariantList CarsListModel::cars() const
{
    return m_cars;
}

void CarsListModel::setCars(const QVariantList &cars)
{
    if (m_cars == cars)
        return;

    beginResetModel();
    m_cars = cars;
    endResetModel();
}
