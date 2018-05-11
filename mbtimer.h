#ifndef MBTIMER_H
#define MBTIMER_H

#include <QObject>
#include <QString>
#include <QTime>

class MbTimer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double unitCost READ unitCost WRITE setUnitCost NOTIFY unitCostChanged)
    Q_PROPERTY(QString clock READ clock NOTIFY clockChanged)
    Q_PROPERTY(QString elapsed READ elapsed NOTIFY elapsedChanged)
    Q_PROPERTY(QString cost READ cost NOTIFY costChanged)

public:
    explicit MbTimer(QObject *parent = nullptr);

    Q_INVOKABLE void init();

    double unitCost() const;
    QString clock() const;
    QString elapsed() const;
    QString cost() const;

public slots:
    void setUnitCost(const double &uCost);
    void setClock();
    void setElapsed();
    void setCost();

signals:
    void unitCostChanged(const double &uCost);
    void clockChanged();
    void elapsedChanged();
    void costChanged();

private:
    QTime _startTime;
    double _unitCost;
    QString _clock;
    QString _elapsed;
    QString _cost;
    QString _currencyPrefix;

    double getUnitCost() const;
};

#endif // MBTIMER_H
