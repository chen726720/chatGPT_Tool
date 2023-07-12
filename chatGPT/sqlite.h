#ifndef SQLITE_H
#define SQLITE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
class SqLite:public QObject
{
    Q_OBJECT
public:
    QVariantList search(QString sqlStr);

    bool exec(QString sqlStr);
    SqLite(QObject * parent);
    ~SqLite();
private:
    QSqlDatabase  db;
};

#endif // SQLITE_H
