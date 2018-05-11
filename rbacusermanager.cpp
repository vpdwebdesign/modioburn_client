#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

#include "rbacusermanager.h"

RBACUserManager::RBACUserManager(User *parent)
    : User(parent)
{
    m_role = new Role(this);
    m_session = new Session(this);

    connect(this, &RBACUserManager::authenticated, [=]() {
        QString uname = this->username();
        m_role->setRoleIdFromUsername(uname);
    });

    connect(m_role, &Role::rolePermissionsSet, [=]() {
        m_session->start();
    });

    connect(m_session, &Session::sessionStarted, [=]() {
        QString uname = this->username();
        QString uRole = m_role->role();
        m_session->setUsername(uname);
        m_session->setRole(uRole);
        m_session->setLoggedIn(true);
    });

    connect(m_session, &Session::sessionStopped, [=]() {
        this->setName(QString());
        this->setGender(QString());
        this->setPhone(QString());
        this->setEmail(QString());
        this->setUsername(QString());
        this->setPassStr(QString());
        this->setStatus(QString());

        m_role->setRoleID(0);
        m_role->setRole(QString());
        m_role->deletePermissions();

        m_session->setUsername(QString());
        m_session->setRole(QString());
        m_session->setLoggedIn(false);
    });
}

Role *RBACUserManager::role() const
{
    return m_role;
}

void RBACUserManager::setRole(Role *role)
{
    if (role != m_role)
    {
        m_role = role;
        emit roleChanged();
    }
}

Session *RBACUserManager::session() const
{
    return m_session;
}

void RBACUserManager::setSession(Session *session)
{
    if (session != m_session)
    {
        m_session = session;
        emit sessionChanged();
    }
}

bool RBACUserManager::initGuest()
{
    const QString guestName = "guest";
    const QString guestRole = "guest";
    int guestRoleID = -1;

    QSqlQuery q;
    q.prepare(QLatin1String("SELECT id FROM roles "
                            "WHERE role = :rolename"));
    q.bindValue(":rolename", guestRole);
    if (q.exec())
    {
        if (q.isActive() && q.isSelect())
        {
            while (q.next()) {
                guestRoleID = q.value(0).toInt();
            }
            this->setUsername(guestName);
            m_role->setRoleID(guestRoleID);
            m_role->setRoleFromRoleId(guestRoleID);
            m_role->setRolePermissions(guestRoleID);
            m_session->setUsername(this->username());
            m_session->setRole(m_role->role());
            m_session->setLoggedIn(true);

            qDebug() << "Guest session successfully initiliazed.";

            return true;
        }
        else
        {
            qDebug() << "There was an error executing query. Unable to fetch role_id, therefore unable to initiliaze guest session";
            return false;
        }
    }
    else
    {
        qDebug() << q.lastError();
        return false;
    }
}
