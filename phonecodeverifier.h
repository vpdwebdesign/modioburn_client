#ifndef PHONECODEVERIFIER_H
#define PHONECODEVERIFIER_H

#include <QObject>

class QNetworkAccessManager;

class PhoneCodeVerifier : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString phoneNumber READ phoneNumber WRITE setPhoneNumber NOTIFY phoneNumberChanged)
    Q_PROPERTY(QString code READ code WRITE setCode NOTIFY codeChanged)
    Q_PROPERTY(CommMode codeRequestMethod READ codeRequestMethod WRITE setCodeRequestMethod NOTIFY codeRequestMethodChanged)

public:
    explicit PhoneCodeVerifier(QObject *parent = nullptr);

    enum CommMode
    {
        SMS,
        CALL
    };
    Q_ENUMS(CommMode)

    QString phoneNumber() const;
    void setPhoneNumber(const QString &phoneNum);
    QString code() const;
    void setCode(const QString &code);
    CommMode codeRequestMethod() const;
    void setCodeRequestMethod(const CommMode &codeReqMethod);

    Q_INVOKABLE bool checkNetworkAvailability();

signals:
    void phoneNumberChanged();
    void codeChanged();
    void codeRequestMethodChanged();

public slots:
    bool codeRequest();
    bool codeVerify();

private:
    QString _phoneNum;
    QString _code;
    CommMode _codeReqMethod;

    QNetworkAccessManager *networkManager;
};

#endif // PHONECODEVERIFIER_H
