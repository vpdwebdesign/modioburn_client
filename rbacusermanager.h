#ifndef RBACUSERMANAGER_H
#define RBACUSERMANAGER_H

#include <QObject>
#include <QMap>
#include <QList>

#include "user.h"
#include "role.h"
#include "session.h"

class RBACUserManager : public User
{
    Q_OBJECT
    Q_PROPERTY(Role *role READ role WRITE setRole NOTIFY roleChanged)
    Q_PROPERTY(Session *session READ session WRITE setSession NOTIFY sessionChanged)

public:
    explicit RBACUserManager(User *parent = nullptr);

    Role *role() const;
    void setRole(Role *role);

    Session *session() const;
    void setSession(Session *session);

    Q_INVOKABLE bool initGuest();

signals:
    void roleChanged();
    void sessionChanged();

private:
    Role *m_role;
    Session *m_session;
};

#endif // RBACUSERMANAGER_H
