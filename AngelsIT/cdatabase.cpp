#include "cdatabase.h"
//---------------------------------------------------------------
CDataBase::CDataBase(QObject *parent) : QObject(parent)
{

}
//---------------------------------------------------------------
CDataBase::~CDataBase(){
}
//---------------------------------------------------------------

//---------------------------------------------------------------

bool CDataBase::connectToDataBase(QString username, QString password, QString host, QString database){
    db.setHostName(host);
    db.setDatabaseName(database);
    db.setUserName(username);
    db.setPassword(password);
    db.setPort(3306);
    bool ok = db.open();
//    (ok == true) ? (qDebug("ok")) : (qDebug("not ok"));
    return ok;
}

//---------------------------------------------------------------
////---------------------------------------------------------------
//// Открытие базы данных
//bool CDataBase::openDataBase(){

//}
////---------------------------------------------------------------
//// Восстановление базы данных
//bool CDataBase::restoreDataBase(){

//}
//---------------------------------------------------------------
// Закрытие базы данных
void CDataBase::closeDataBase(){
    db.close();
}
//---------------------------------------------------------------
//// Создание базы таблицы в базе данных
//bool CDataBase::createTable(){

//}
////---------------------------------------------------------------
//// Добавление записей в таблицу
//bool CDataBase::inserIntoTable(const QVariantList &data){

//}
////---------------------------------------------------------------
//// Добавление записей в таблицу
//bool CDataBase::inserIntoTable(const QString &fname, const QString &sname, const QString &nik){

//}
////---------------------------------------------------------------
//// Удаление записи из таблицы по её id
//bool CDataBase::removeRecord(const int id){

//}
//---------------------------------------------------------------
void CDataBase::login(QString userName,QString userPas){
    qDebug(__PRETTY_FUNCTION__);
    if(connectToDataBase(userName, userPas)){
        // 1. send signal to qml !!!
        emit logonGood();
        // 2. Запросить список заявок
    }else{
        emit logonBad();
    }
}
