#ifndef MBFILEMANAGER_H
#define MBFILEMANAGER_H

#include <QObject>

class MbFileManager : public QObject
{
    Q_OBJECT
public:
    explicit MbFileManager(QObject *parent = nullptr);

    Q_INVOKABLE bool fileExists(const QString &url);
};

#endif // MBFILEMANAGER_H
