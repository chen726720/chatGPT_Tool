#include "mclass.h"

MClass::MClass(QObject *parent)
    : QThread{parent}
{
    sql = new SqLite(this);
}
MClass::~MClass(){

    quit();
    wait();
//    delete sql;
}
QString MClass::getMsg(QString apiKey,  QJsonObject msg){
    emit waitData();
    QNetworkAccessManager manager;
    QNetworkRequest request;
    qInfo() <<  QJsonDocument(msg);
    request.setUrl(QUrl("https://api.openai.com/v1/chat/completions"));
    request.setRawHeader("Content-Type","application/json");
    request.setRawHeader("Authorization", QString("Bearer %1").arg(apiKey).toLocal8Bit());
    reply = manager.post(request, QJsonDocument(msg).toJson());
    QElapsedTimer time;
    time.start();
    while(time.elapsed() < 60000){
        QCoreApplication::processEvents();
        if(reply->isFinished()){
            emit acceptChanged();
            QString ret =  QString::fromUtf8(reply->readAll());
            qInfo() << ret;
            return ret;
        }

    }
        qInfo() << "超时" <<reply->error() ;
        emit acceptChanged();
        return "";
}
QStringList MClass::getModelList(QString apiKey, QString url){
    QStringList ret;
    QNetworkAccessManager manager;
    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setRawHeader("Authorization", QString("Bearer %1").arg(apiKey).toLocal8Bit());
    reply = manager.get(request);
    QElapsedTimer time;
    time.start();
    while(time.elapsed() < 3000){
        QCoreApplication::processEvents();
        if(reply->isFinished()){
            QJsonDocument data = QJsonDocument::fromJson(reply->readAll());
            QJsonObject jsonObject = data.object();
            QJsonArray array = jsonObject["data"].toArray();
            for(QJsonArray::iterator ite= array.begin(); ite!=array.end();++ite){
                ret << ite->toObject()["root"].toString();
            }
            return ret;
        }
    }
    qInfo() << "超时";
    return ret;
}



void MClass ::run(){

}
