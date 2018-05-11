#include "mbtimer.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QLatin1String>
#include <QTimer>
#include <QDebug>

MbTimer::MbTimer(QObject *parent) :
    QObject(parent)
{
    init();
}

void MbTimer::init()
{
    _startTime = QTime::currentTime();
    _unitCost = getUnitCost();
    _currencyPrefix = "Ksh ";

    QTimer *t = new QTimer(this);
    connect(t, SIGNAL(timeout()), this, SLOT(setClock()));
    connect(t, SIGNAL(timeout()), this, SLOT(setElapsed()));
    connect(t, SIGNAL(timeout()), this, SLOT(setCost()));
    t->start(1000);
}

double MbTimer::getUnitCost() const
{
    double uCost = 0.0;
    QSqlQuery q;
    if (q.exec(QLatin1String("SELECT unit_cost FROM timer_cost_settings")))
    {
        while (q.next())
        {
            uCost = q.value(0).toDouble();
        }
        qDebug() << "Query successful.";
        return uCost;
    }
    else
    {
        qDebug() << q.lastError();
        return uCost;
    }
}

double MbTimer::unitCost() const
{
    return _unitCost;
}

void MbTimer::setUnitCost(const double &uCost)
{
    QSqlQuery q;
    q.prepare(QLatin1String("UPDATE timer_cost_settings "
                            "SET unit_cost = :unit_cost"));
    q.bindValue(":unit_cost", uCost);
    if (q.exec())
    {
        qDebug() << "Unit cost updated successfully";
    }
    else
    {
        qDebug() << "Unit cost not updated. Error: " << q.lastError();
    }

    if (uCost != _unitCost)
    {
        _unitCost = uCost;
        emit unitCostChanged(uCost);
    }
}

QString MbTimer::clock() const
{
    return _clock;
}

void MbTimer::setClock()
{
    _clock = QTime::currentTime().toString("hh:mm:ss AP");
    emit clockChanged();
}

QString MbTimer::elapsed() const
{
    return _elapsed;
}

void MbTimer::setElapsed()
{
    quint32 minutesElapsed = _startTime.elapsed() / (1000 * 60);
    _elapsed = QString::number(minutesElapsed).append(" minutes");
    emit elapsedChanged();
}

QString MbTimer::cost() const
{
    return _cost;
}

void MbTimer::setCost()
{
    quint32 minutesElapsed = _startTime.elapsed() / (1000 * 60);
    double totalCost = _unitCost * minutesElapsed;

    QString totalCostStr;
    _cost = totalCostStr.prepend(_currencyPrefix).\
            append(QString::number(totalCost, 'f', 2));
    emit costChanged();
}
