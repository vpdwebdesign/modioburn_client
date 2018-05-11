#ifndef ROLE_H
#define ROLE_H

#include <QObject>
#include <QVector>

class Role: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int roleID READ roleID WRITE setRoleID NOTIFY roleIDChanged)
    Q_PROPERTY(QString role READ role WRITE setRole NOTIFY roleChanged)

public:
    Role(QObject *parent = nullptr);

    int roleID() const;
    void setRoleID(int roleID);
    QString role() const;
    void setRole(const QString role);

    void deletePermissions();

    QVector<QString> getRolePermissions() const;

    Q_INVOKABLE bool hasPermission(const QString permStr) const;
    Q_INVOKABLE bool addUserRole(const QString username, const QString roleName);

signals:
    void roleIDChanged(int roleID);
    void roleIdSet(const int roleID);
    void roleChanged(const QString role);
    void roleSet(const QString role);
    void rolePermissionsSet();
    void userRoleAdded(const int uid, const int rid);

public slots:
    void setRoleIdFromUsername(const QString username);
    void setRoleFromRoleId(const int roleID);
    void setRolePermissions(const int roleID);

private:
    QVector<QString> m_permissions;
    int m_roleID;
    QString m_role;
};

#endif // ROLE_H
