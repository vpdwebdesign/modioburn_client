#ifndef SHOPPINGCART_H
#define SHOPPINGCART_H

#include <QObject>
#include <QVector>

#include "transactionitem.h"

class Session;

class ShoppingCart : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString paymentMethod READ paymentMethod WRITE setPaymentMethod NOTIFY paymentMethodChanged)
    Q_PROPERTY(Session *session READ session WRITE setSession NOTIFY sessionChanged())

public:
    explicit ShoppingCart(QObject *parent = nullptr);

    QString paymentMethod() const;
    void setPaymentMethod(const QString &paymentMethod);

    Session *session() const;
    void setSession(Session *session);

    QVector<TransactionItem> items() const;

    bool setItemAt(int index, const TransactionItem &item);

    int itemCount() const;
    Q_INVOKABLE void addNewItem(const QVariantList &newItem);
    Q_INVOKABLE void appendItem(const TransactionItem &item);
    Q_INVOKABLE bool removeItemAt(int index);
    Q_INVOKABLE void clearCart();

    Q_INVOKABLE bool checkoutItems();

signals:
    void paymentMethodChanged();
    void sessionChanged(); // Dummy signal to avoid warning about a missing notify signal

    void preItemAppended();
    void postItemAppended();

    void preItemRemoved(int index);
    void postItemRemoved();

    void preCartCleared();
    void postCartCleared();

    void itemCountChanged(const int itemCount);

    void itemsCheckedout();

private:
    QString m_paymentMethod;
    QVector<TransactionItem> m_items;

    Session *m_session; // We need a pointer to a session object so that we can get the username of the currently logged in
                        // customer to add to the transaction object
};


#endif // SHOPPINGCART_H
