#include "mbfilemanager.h"
#include <QFileInfo>

MbFileManager::MbFileManager(QObject *parent) : QObject(parent)
{
}

bool MbFileManager::fileExists(const QString &url)
{
    return QFileInfo::exists(url);
}
