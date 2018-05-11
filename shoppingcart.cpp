#include <QSqlQuery>
#include <QSqlError>
#include <QVariantList>
#include <QDebug>

#include "shoppingcart.h"
#include "session.h"

ShoppingCart::ShoppingCart(QObject *parent)
    : QObject(parent)
{
    m_session = new Session(this);
}

QString ShoppingCart::paymentMethod() const
{
    return m_paymentMethod;
}

void ShoppingCart::setPaymentMethod(const QString &paymentMethod)
{
    if (paymentMethod != m_paymentMethod)
    {
        m_paymentMethod = paymentMethod;
        emit paymentMethodChanged();
    }
}

Session *ShoppingCart::session() const
{
    return m_session;
}

void ShoppingCart::setSession(Session *session)
{
    if (session != m_session)
    {
        m_session = session;
        emit sessionChanged();
    }
}

QVector<TransactionItem> ShoppingCart::items() const
{
    return m_items;
}

bool ShoppingCart::setItemAt(int index, const TransactionItem &item)
{
    if (index < 0 || index >= m_items.size())
        return false;

    const TransactionItem &oldItem = m_items.at(index);

    if (item.itemName == oldItem.itemName &&
        item.itemType == oldItem.itemType &&
        item.quantity == oldItem.quantity &&
        item.pricePerUnit == oldItem.pricePerUnit &&
        item.totalCost == oldItem.totalCost &&
        item.copyMedium == oldItem.copyMedium)
    {
        return false;
    }

    m_items[index] = item;
    emit itemCountChanged(itemCount());
    return true;
}

int ShoppingCart::itemCount() const
{
    return m_items.size();
}

void ShoppingCart::addNewItem(const QVariantList &newItem)
{
    TransactionItem item;
    item.itemType = newItem.at(0).toString();
    item.itemName = newItem.at(1).toString();
    item.quantity = newItem.at(2).toInt();
    item.pricePerUnit = newItem.at(3).toDouble();
    item.totalCost = newItem.at(4).toDouble();
    item.copyMedium = newItem.at(5).toString();

    appendItem(item);

}

void ShoppingCart::appendItem(const TransactionItem &item)
{
    emit preItemAppended();

    m_items.append(item);
    emit itemCountChanged(itemCount());

    emit postItemAppended();
}

bool ShoppingCart::removeItemAt(int index)
{
    if (index < 0 || index >= m_items.size())
        return false;

    emit preItemRemoved(index);

    m_items.removeAt(index);
    emit itemCountChanged(itemCount());

    emit postItemRemoved();

    return true;
}

void ShoppingCart::clearCart()
{
    if (m_items.size() > 0)
    {
        emit preCartCleared();

        m_items.clear();
        emit itemCountChanged(itemCount());

        emit postCartCleared();
    }
}

bool ShoppingCart::checkoutItems()
{
    QSqlQuery query;

    QString itemType = QString();
    QString itemName = QString();
    int quantity = 0;
    double pricePerUnit = 0.00;
    double totalCost = 0.00;
    QString copyMedium = QString();

    // loop through container of items, adding data to db    
    int successfulQueryCounter = 0;
    QVector<TransactionItem>::const_iterator i;
    for (i = m_items.begin(); i != m_items.end(); ++i)
    {
        itemType = (*i).itemType;
        itemName = (*i).itemName;
        quantity = (*i).quantity;
        pricePerUnit = (*i).pricePerUnit;
        totalCost = (*i).totalCost;
        copyMedium = (*i).copyMedium;

        query.prepare("INSERT INTO transactions (item_type, item_name, quantity, "
                      "price_per_unit, total_cost, copy_medium, payment_method, status, "
                      "username, initiated_at) "
                      "VALUES (:item_type, :item_name, :quantity, :price_per_unit, "
                      ":total_cost, :copy_medium, :payment_method, 'pending', :username, localtimestamp)");
        query.bindValue(":item_type", itemType);
        query.bindValue(":item_name", itemName);
        query.bindValue(":quantity", quantity);
        query.bindValue(":price_per_unit", pricePerUnit);
        query.bindValue(":total_cost", totalCost);
        query.bindValue(":copy_medium", copyMedium);
        query.bindValue(":payment_method", m_paymentMethod);
        query.bindValue(":username", m_session->username()); // the Session object's username() getter function is guaranteed to return
                                                             // a username since the ShoppingCart object cannot be instantiated before
                                                             // a user logs in

        if (query.exec())
        {
            ++successfulQueryCounter;
            qDebug() << "Insert transaction items query successful.";
        }
        else
        {
            qDebug() << "Error:" << query.lastError().text();
        }
    }

    if (successfulQueryCounter == m_items.size())
    {
        qDebug() << "All transaction items successfully checked out.";
        clearCart();
        emit itemsCheckedout();

        return true;
    }
    else {
        qDebug() << "Some transaction items were not checked out.";
        return false;
    }

    return false;
}
