#include "sqlite.h"
#include <QUrl>
SqLite::SqLite(QObject* parent): QObject(parent)
{
    if (QSqlDatabase::contains("qt_sql_default_connection"))
    {
        db = QSqlDatabase::database("qt_sql_default_connection");
    }else
    {
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName("./database.sqlite");
        if(!db.open())
        {
            qDebug() << "打开数据库失败!";
            return;
        }

    }
}
SqLite::~SqLite(){

}

QVariantList SqLite::search(QString sqlStr){
    QVariantList ret;
    if(db.isOpen()){
        QSqlQuery query;

        if(query.exec(sqlStr))
        {
            int columNum =  query.record().count();
            while (query.isSelect()&&query.next()) {
                QVariantList tempList;
                for(int i=0;i < columNum;i++){
                    tempList.append(query.value(i));
                }
                ret.append(QVariant::fromValue(tempList));
            }
        }
        else{
            qInfo() << query.lastError();
        }
    }
    return ret;
}
bool SqLite::exec(QString sqlStr){
    if(db.isOpen()){
        QSqlQuery query;
        return query.exec(sqlStr);
    }
    return false;
}
