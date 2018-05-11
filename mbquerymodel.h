#ifndef MBQUERYMODEL_H
#define MBQUERYMODEL_H

#include <QSqlQueryModel>

class MbQueryModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit MbQueryModel(QObject *parent = 0);

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &, int) const override;

    void generateRoleNames();

private:
    QHash<int, QByteArray> _roleNames;
};

#endif // MBQUERYMODEL_H
