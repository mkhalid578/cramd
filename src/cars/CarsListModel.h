#pragma once

#include <QAbstractListModel>
#include <QHash>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

class CarsListModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum Roles {
        CarRole = Qt::UserRole + 1
    };

    explicit CarsListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    QVariantList cars() const;
    void setCars(const QVariantList &cars);

private:
    QVariantList m_cars;
};
