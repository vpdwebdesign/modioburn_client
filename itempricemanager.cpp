#include "itempricemanager.h"
#include <QDebug>

ItemPriceManager::ItemPriceManager(QObject *parent)
    : QObject(parent)
{
    m_itemPricesModel = new MbQueryModel(this);

    initItemPriceMap();
}

void ItemPriceManager::initItemPriceMap()
{
    MbProxyQueryModel *mbProxyQueryModel = new MbProxyQueryModel(this);
    m_itemPricesModel = mbProxyQueryModel->itemPricesModel();

    // Copy model data to hash map for fast retrieval
    const int numRows = m_itemPricesModel->rowCount();

    for (int i = 0; i < numRows; ++i)
    {
        QString key = m_itemPricesModel->data(m_itemPricesModel->index(i , 0), Qt::DisplayRole).toString();
        double value = m_itemPricesModel->data(m_itemPricesModel->index(i, 1), Qt::DisplayRole).toDouble();

        m_itemToPriceMap[key] = value;
    }
}

double ItemPriceManager::itemPrice(const QString &item)
{
    return m_itemToPriceMap[item];
}
