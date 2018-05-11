#ifndef SESSION_H
#define SESSION_H

#include <QObject>

class Session : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString role READ role WRITE setRole NOTIFY roleChanged)
    Q_PROPERTY(bool loggedIn READ loggedIn WRITE setLoggedIn NOTIFY loggedInChanged)

public:
    explicit Session(QObject *parent = nullptr);

    QString username() const;
    void setUsername(const QString username);
    QString role() const;
    void setRole(const QString role);

    bool loggedIn() const;
    void setLoggedIn(bool loggedIn);

signals:
    void usernameChanged(const QString username);
    void roleChanged(const QString role);
    void loggedInChanged();

    void sessionStarted();
    void sessionStopped();

public slots:
    void start();
    void stop();

private:
    QString m_username;
    QString m_role;

    bool m_loggedIn;
};

#endif // SESSION_H
