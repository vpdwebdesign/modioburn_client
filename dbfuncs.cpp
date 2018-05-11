#include "dbfuncs.h"
#include <QSqlDatabase>
#include <QSqlError>
#include <QDebug>

void dbConnect()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("localhost");
    db.setUserName("vpd");
    db.setPassword("xesefassixesfles432");
    db.setDatabaseName("mbdb");

    if (!db.open())
    {
        qFatal("Could not open database. Error: %s", qPrintable(db.lastError().text()));
    }
    else {
        qDebug() << "Db opened successfully.";
    }
}
