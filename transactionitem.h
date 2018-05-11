#ifndef TRANSACTIONITEM_H
#define TRANSACTIONITEM_H

#include <QString>

struct TransactionItem
{
    QString itemType;
    QString itemName;
    int quantity;
    double pricePerUnit;
    double totalCost;
    QString copyMedium;
};

#endif // TRANSACTIONITEM_H
