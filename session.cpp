#include <QDebug>

#include "session.h"

Session::Session(QObject *parent)
    : QObject(parent), m_username(QString()), m_role(QString()), m_loggedIn(false)
{

}

QString Session::username() const
{
    return m_username;
}

void Session::setUsername(const QString username)
{
    if (m_username != username)
    {
        m_username = username;
        emit usernameChanged(username);
    }
}

bool Session::loggedIn() const
{
    return m_loggedIn;
}

void Session::setLoggedIn(bool loggedIn)
{
    if (m_loggedIn != loggedIn)
    {
        m_loggedIn = loggedIn;
        emit loggedInChanged();
    }
}

QString Session::role() const
{
    return m_role;
}

void Session::setRole(const QString role)
{
    if (m_role != role)
    {
        m_role = role;
        emit roleChanged(role);
    }
}

// Session starter
void Session::start()
{
    emit sessionStarted();

    qDebug() << "Session started. Logged in: " << loggedIn();
}

void Session::stop()
{
    emit sessionStopped();

    qDebug() << "Session stopped. Logged in: " << loggedIn();
}
