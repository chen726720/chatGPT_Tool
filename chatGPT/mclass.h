#ifndef MCLASS_H
#define MCLASS_H

#include <QtQml>
#include <QObject>
#include <QThread>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include "sqlite.h"
class MClass : public QThread
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit MClass(QObject *parent = nullptr);
    ~MClass();
    Q_INVOKABLE QStringList getModelList(QString apiKey, QString url = "https://api.openai.com/v1/models");
    Q_INVOKABLE QString getMsg(QString apiKey, QJsonObject msg);
    Q_INVOKABLE QString calculateHash(const QString& data)
    {
        QByteArray byteArray(data.toUtf8());
        QCryptographicHash hash(QCryptographicHash::Md5);
        hash.addData(byteArray);
        return hash.result().toHex();
    }
    Q_INVOKABLE  QVariantList search(QString sqlStr){return sql->search(sqlStr);}
    Q_INVOKABLE bool exec(QString sqlStr){return sql->exec(sqlStr);}
protected:
    void run();
signals:
    void waitData();
    void acceptChanged();
private:
    QNetworkReply * reply;
    SqLite * sql;
};

#endif // MCLASS_H
