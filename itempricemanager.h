#ifndef ITEMPRICEMANAGER_H
#define ITEMPRICEMANAGER_H

#include <QObject>

#include "mbproxyquerymodel.h"

class ItemPriceManager : public QObject
{
    Q_OBJECT
public:
    explicit ItemPriceManager(QObject *parent = nullptr);

    Q_INVOKABLE double itemPrice(const QString &item);

public slots:
    void initItemPriceMap();

private:
    MbQueryModel *m_itemPricesModel;
    QHash<QString, double> m_itemToPriceMap;
};

#endif // ITEMPRICEMANAGER_H
