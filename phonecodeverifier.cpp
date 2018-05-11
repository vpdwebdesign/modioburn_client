#include "phonecodeverifier.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QJsonDocument>
#include <QJsonObject>
#include <QEventLoop>
#include <QDebug>

PhoneCodeVerifier::PhoneCodeVerifier(QObject *parent)
    : QObject(parent), _phoneNum(QString()), _code(QString()), _codeReqMethod(SMS)
{
    networkManager = new QNetworkAccessManager(this);
}

QString PhoneCodeVerifier::phoneNumber() const
{
    return _phoneNum;
}

void PhoneCodeVerifier::setPhoneNumber(const QString &phoneNum)
{
    if (phoneNum != _phoneNum)
    {
        _phoneNum = phoneNum;
        emit phoneNumberChanged();
    }
}

QString PhoneCodeVerifier::code() const
{
    return _code;
}

void PhoneCodeVerifier::setCode(const QString &code)
{
    if (code != _code){
        _code = code;
        emit codeChanged();
    }
}

PhoneCodeVerifier::CommMode PhoneCodeVerifier::codeRequestMethod() const
{
    return _codeReqMethod;
}

void PhoneCodeVerifier::setCodeRequestMethod(const CommMode &codeReqMethod)
{
    if (codeReqMethod != _codeReqMethod){
        _codeReqMethod = codeReqMethod;
        emit codeRequestMethodChanged();
    }
}

bool PhoneCodeVerifier::checkNetworkAvailability()
{
    QNetworkRequest request(QUrl("http://www.google.com"));

    QNetworkReply *reply = networkManager->get(request);

    QEventLoop loop;
    QObject::connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    reply->deleteLater();

    if (reply->bytesAvailable() > 0)
    {
        qDebug() << "Network available";
        return true;
    }
    qDebug() << "No network available";
    return false;
}

bool PhoneCodeVerifier::codeRequest()
{
    QString phoneNum = _phoneNum;
    QString codeReqMeth;

    switch (_codeReqMethod)
    {
    case SMS:
        codeReqMeth = "sms";
        break;
    case CALL:
        codeReqMeth = "call";
    default:
        codeReqMeth = "none";
        break;
    }

    QUrl url = QUrl("https://api.authy.com/protected/json/phones/verification/start?");

    QUrlQuery postData;
    postData.addQueryItem("api_key", "98Z9TPvtyTNzDEOFBmEGB6cQhpzzmwMk");
    postData.addQueryItem("via", codeReqMeth);
    postData.addQueryItem("phone_number", phoneNum);
    postData.addQueryItem("country_code", "254");
    if (codeReqMeth == "sms")
    {
        postData.addQueryItem("locale", "en");
    }

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QNetworkReply *reply;
    reply = networkManager->post(request, postData.query(QUrl::FullyEncoded).toUtf8());

    QEventLoop loop;
    QObject::connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    reply->deleteLater();

    QByteArray postReply = reply->readAll();

    QJsonDocument jsonDoc;
    jsonDoc = QJsonDocument::fromJson(postReply);
    QJsonObject jsonObject = jsonDoc.object();

    if (jsonObject.value("success").toBool())
    {
        qDebug() << "Code request sent!";
        return true;
    }

    qDebug() << "Error while sending code request. Try again!";
    return false;

}

bool PhoneCodeVerifier::codeVerify()
{
    QString phoneNum = _phoneNum;
    QString code = _code;

    QUrl url = QUrl("https://api.authy.com/protected/json/phones/verification/check?");

    QUrlQuery getData;
    getData.addQueryItem("api_key", "98Z9TPvtyTNzDEOFBmEGB6cQhpzzmwMk");
    getData.addQueryItem("phone_number", phoneNum);
    getData.addQueryItem("country_code", "254");
    getData.addQueryItem("verification_code", code);

    url.setQuery(getData);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QNetworkReply *reply;
    reply = networkManager->get(request);

    QEventLoop loop;
    QObject::connect(reply, SIGNAL(readyRead()), &loop, SLOT(quit()));
    loop.exec();

    QByteArray postReply = reply->readAll();
    reply->deleteLater();

    QJsonDocument jsonDoc;
    jsonDoc = QJsonDocument::fromJson(postReply);
    QJsonObject jsonObject = jsonDoc.object();

    if (jsonObject.value("success").toBool())
    {
        qDebug() << "Code verification succeeded!";
        return true;
    }

    qDebug() << "Code verification failed!";
    return false;

}

