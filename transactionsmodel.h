#ifndef TRANSACTIONSMODEL_H
#define TRANSACTIONSMODEL_H

#include <QAbstractListModel>

class ShoppingCart;

class TransactionsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(ShoppingCart *cart READ cart WRITE setCart)
    Q_PROPERTY(int cartItemCount READ cartItemCount NOTIFY cartItemCountChanged)

public:
    explicit TransactionsModel(QObject *parent = nullptr);

    enum {
        itemTypeRole = Qt::UserRole + 1,
        itemNameRole,
        quantityRole,
        pricePerUnitRole,
        totalCostRole,
        copyMediumRole
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    ShoppingCart *cart() const;
    void setCart(ShoppingCart *cart);

    int cartItemCount() const;

signals:
    void cartItemCountChanged(int count);

private:
    ShoppingCart *m_cart;
    int m_cartItemCount;
};

#endif // TRANSACTIONSMODEL_H
