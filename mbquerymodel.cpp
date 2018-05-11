#include "mbquerymodel.h"

#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

MbQueryModel::MbQueryModel(QObject *parent)
    : QSqlQueryModel(parent)
{
}

void MbQueryModel::generateRoleNames()
{
    _roleNames.clear();

    for (int i = 0; i < record().count(); ++i)
    {
        _roleNames.insert(Qt::UserRole + i, record().fieldName(i).toUtf8());
    }
}

QHash<int, QByteArray> MbQueryModel::roleNames() const
{
    return _roleNames;
}

QVariant MbQueryModel::data(const QModelIndex &index, int role) const
{
    QVariant value;

     if (index.isValid()) {
        if (role < Qt::UserRole) {
            value = QSqlQueryModel::data(index, role);
        } else {
            int columnIdx = role - Qt::UserRole;
            QModelIndex modelIndex = this->index(index.row(), columnIdx);
            value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
        }
    }
    return value;
}
