#include <QDebug>

#include "transactionsmodel.h"
#include "shoppingcart.h"

TransactionsModel::TransactionsModel(QObject *parent)
    : QAbstractListModel(parent),
      m_cart(nullptr),
      m_cartItemCount(0)
{
}

int TransactionsModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !m_cart)
        return 0;

    return m_cart->items().size();
}

QVariant TransactionsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || !m_cart)
        return QVariant();

    const TransactionItem &item = m_cart->items().at(index.row());

    switch (role) {
    case itemTypeRole:
        return item.itemType;
        break;
    case itemNameRole:
        return item.itemName;
        break;
    case quantityRole:
        return item.quantity;
        break;
    case pricePerUnitRole:
        return item.pricePerUnit;
        break;
    case totalCostRole:
        return item.totalCost;
        break;
    case copyMediumRole:
        return item.copyMedium;
        break;
    }

    return QVariant();
}

bool TransactionsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!m_cart)
        return false;

    TransactionItem item = m_cart->items().at(index.row());

    switch (role) {
    case itemTypeRole:
        item.itemType = value.toString();
        break;
    case itemNameRole:
        item.itemName = value.toString();
        break;
    case quantityRole:
        item.quantity = value.toInt();
        break;
    case pricePerUnitRole:
        item.pricePerUnit = value.toDouble();
        break;
    case totalCostRole:
        item.totalCost = value.toDouble();
        break;
    case copyMediumRole:
        item.copyMedium = value.toString();
        break;
    }

    if (m_cart->setItemAt(index.row(), item)) {
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags TransactionsModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> TransactionsModel::roleNames() const
{
    QHash<int, QByteArray> rNames;
    rNames[itemTypeRole] = "itemType";
    rNames[itemNameRole] = "itemName";
    rNames[quantityRole] = "quantity";
    rNames[pricePerUnitRole] = "pricePerUnit";
    rNames[totalCostRole] = "totalCost";
    rNames[copyMediumRole] = "copyMedium";

    return rNames;
}

ShoppingCart *TransactionsModel::cart() const
{
    return m_cart;
}

void TransactionsModel::setCart(ShoppingCart *cart)
{
    beginResetModel();

    if (m_cart)
        disconnect(this);

    m_cart = cart;

    if (m_cart)
    {
        connect(m_cart, &ShoppingCart::preItemAppended, this, [=]() {
            const int index = m_cart->items().size();
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(m_cart, &ShoppingCart::postItemAppended, this, [=]() {
            endInsertRows();
        });

        connect(m_cart, &ShoppingCart::preItemRemoved, this, [=](int index) {
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_cart, &ShoppingCart::postItemRemoved, this, [=]() {
            endRemoveRows();
        });

        connect(m_cart, &ShoppingCart::preCartCleared, this, [=]() {
            beginResetModel();
        });
        connect(m_cart, &ShoppingCart::postCartCleared, this, [=]() {
            endResetModel();
        });

        connect(m_cart, &ShoppingCart::itemCountChanged, this, [=](int count) {
            m_cartItemCount = m_cart->itemCount();
            qDebug () << "itemCountChanged() signal:" << count;
            emit cartItemCountChanged(count);
        });

    }

    endResetModel();
}

int TransactionsModel::cartItemCount() const
{
    return m_cartItemCount;
}
